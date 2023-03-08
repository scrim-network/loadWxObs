#' Load station metadata as a SpatialPointsDataFrame
#'
#' @param ds H5File object pointing to netCDF observation file
#' @param vnames Variables names of station metadata to load,
#'   Default: c("station_id", "station_name", "longitude", "latitude", "elevation")
#' @param vname_stnid Variable name from vnames representing unique station identifier,
#'   Default: "station_id"
#' @param vnames_xy Variable names from vnames representing x,y position,
#'   Default: c("longitude", "latitude")
#' @return A SpatialPointsDataFrame
#' @export
load_stns <- function(ds,
                      vnames = c("station_id", "station_name", "longitude", "latitude", "elevation"),
                      vname_stnid = "station_id",
                      vnames_xy = c("longitude", "latitude")) {

  stns <- list()

  for (vname in vnames) {

    vals <- ds[[vname]]$read()

    # Create vector of strings if 2D character
    if (is.character(vals) & length(dim(vals)) == 2) {
      vals <- apply(vals, 2, paste0, collapse = "")
    }

    stns[[vname]] <- vals

  }

  stns[["obs_index"]] <- 1:length(stns[[1]])

  # Turn station dataframe into spatial dataframe
  stns <- as.data.frame(stns, stringsAsFactors = FALSE)
  row.names(stns) <- stns[, vname_stnid]
  coordinates(stns) <- as.formula(paste0("~", vnames_xy[1], "+", vnames_xy[2]))
  proj4string(stns) = CRS("+proj=longlat +datum=WGS84")

  return(stns)

}

#' Load time data as a vector of POSIXct times
#'
#' @param ds H5File object pointing to netCDF observation file
#' @param vname_time Variable name representing time, Default: "time"
#' @return POSIXct vector of times
#' @export
load_time <- function(ds, vname_time = "time") {

  times <- ds[[vname_time]][]
  times <- utcal.nc(h5attr(ds[[vname_time]], "units"), times, type = "c")
  return(times)

}

#' Quickly load station metadata and observations from a netCDF observation file
#'
#' @param fpath_ds File path to netCDF observation file
#' @param vname Variable name(s) for which to load observations
#' @param start_end Character vector of size 2 with start and end dates,
#'   Default: loads observations for all times in the netCDF file
#' @param stnids Station ids for which to load observations,
#'   Default: loads observations for all stations in the netCDF file
#' @return List of station metadata and observations. Station metdata is a
#'   SpatialPointsDataFrame and observations are in a spacewise xts object.
#' @export
quick_load_stnobs <- function(fpath_ds, vname, start_end = NULL, stnids = NULL) {

  # Open netcdf observation file
  ds <- H5File$new(fpath_ds, mode='r')

  # Load station metadata as SpatialPointsDataFrame
  stns <- load_stns(ds)

  # Load dates for the observation time series
  times <- load_time(ds)

  # Load observations for dates in chunk
  # Observations are returned as an xts object
  obs <- list()
  for (a_vname in vname) {
    obs[[a_vname]] <- load_obs(ds, a_vname, stns, times, start_end, stnids)
  }

  # Close netcdf observation file
  ds$close_all()

  if (!is.null(stnids)) stns <- stns[stnids,]

  obs[['stns']] <- stns

  return(obs)

}

#' Load station observation time series as a "spacewide" xts object
#'
#' @param ds H5File object pointing to netCDF observation file
#' @param vname Variable name for which to load observations
#' @param stns SpatialPointsDataFrame of station metadata from \code{\link{load_stns}}
#' @param times POSIXct vector of times for the netCDF observation file from
#'   \code{\link{load_time}}
#' @param start_end Character vector of size 2 with start and end dates,
#'   Default: loads observations for all times in the netCDF file
#' @param stnids Station ids for which to load observations,
#'   Default: loads observations for all stations in the netCDF file
#' @return A spacewide xts object of observations
#' @export
load_obs <- function(ds, vname, stns, times, start_end = NULL, stnids = NULL) {

  if (is.null(start_end) & is.null(stnids)) {

    stnids <- stns$station_id
    obs <- ds[[vname]]$read()

  } else if (is.null(start_end) & (!is.null(stnids))) {

    i <- stns@data[stnids, "obs_index"]

    if (is.unsorted(i, strictly = TRUE))
      stop("Station ids must be in obs_index order")

    obs <- ds[[vname]][i,]

  } else if ((!is.null(start_end)) & is.null(stnids)) {

    stnids <- stns$station_id
    i <- which(times >= start_end[1] & times <= start_end[2])
    times <- times[i]
    obs <- ds[[vname]][,i]

  } else {
    i_stns <- stns@data[stnids, "obs_index"]

    if (is.unsorted(i_stns, strictly = TRUE))
      stop("Station ids must be in obs_index order")

    i_time <- which(times >= start_end[1] & times <= start_end[2])
    times <- times[i_time]
    obs <- ds[[vname]][i_stns, i_time]
  }

  if (is.null(dim(obs))) {
    dim(obs) <- c(1, length(obs))
  }

  obs <- t(obs)
  colnames(obs) <- stnids

  if (ds[[vname]]$attr_exists("missing_value")) {
    obs[obs == h5attr(ds[[vname]], "missing_value")] = NA
  }

  if (ds[[vname]]$attr_exists("_FillValue")) {
    obs[obs == h5attr(ds[[vname]], "_FillValue")] = NA
  }

  obs <- xts(obs, times)

  return(obs)

}

#' Build a boolean mask for stations that have long enough period-of-record
#'
#' @param ds H5File object pointing to netCDF observation file
#' @param vname Variable name for which to load observations
#' @param stns SpatialPointsDataFrame of station metadata from \code{\link{load_stns}}
#' @param times POSIXct vector of times for the netCDF observation file from
#'   \code{\link{load_time}}
#' @param nyrs The minimum period of record in years. The function tests
#'   whether a station has at least nyrs years of data in each month.
#' @param start_end Character vector of size 2 with start and end dates,
#'   Default: uses observations for all times in the netCDF file
#' @param stnids Station ids for which to load observations,
#'   Default: uses observations for all stations in the netCDF file
#' @return boolean mask for stations
#' @export
build_pormask <- function(ds, vname, stns, times, nyrs, start_end = NULL, stnids = NULL) {

  obs <- load_obs(ds, vname, stns, times, start_end, stnids)

  # Create mask of which observations are not NA
  mask_notna <- !is.na(obs)

  # Get mth for each observation
  mth <- .indexmon(obs)+1

  # Aggregate sum of non-NA observations by month
  obs_cnts <- aggregate.data.frame(mask_notna, by=list(mth=mth), sum)
  # Remove first column which is the months used for grouping
  obs_cnts <- obs_cnts[, -1]

  # Get number of days in each month for a non leap year
  mths_yr <- as.POSIXlt(seq(as.Date("2015-01-01"),
                            as.Date("2015-12-31"), by = "day"))$mon + 1
  days_in_month <- sapply(1:12, FUN = function(x) {
    sum(mths_yr == x)
  })

  # Multiply by number years to get the min number of observations that are needed
  # for n years of data in each month
  nmin <- days_in_month * nyrs

  # Create final por mask
  mask_por <- t(sapply(1:12, function(x) {
    obs_cnts[x, ] >= nmin[x]
  }))
  mask_por <- colSums(mask_por) == 12

  return(mask_por)

}

#' Initialize a new netCDF observation file
#'
#' @param fpath File path for the new netCDF observation file
#' @param stns SpatialPointsDataFrame with station metadata
#' @param times POSIXct vector of observation times
#' @param vnames Vector of observation variable names (e.g.--tmin, tmax, prcp)
#' @return A H5File object pointing to new netCDF observation file
#' @export
init_obsnc <- function(fpath, stns, times, vnames) {

  # Create station_id dimension
  dim_stnid <- ncdim_def("station_id", "", seq(length(stns$station_id)),
                                create_dimvar = FALSE)

  # Create time dimension
  times <- as.POSIXct(times)
  tunits <- sprintf("days since %s", strftime(min(times), "%Y-%m-%d"))
  dim_time <- ncdim_def("time", tunits, utinvcal.nc(tunits, times))

  # Create station metadata variables
  vars_meta <- list()
  vals_meta <- list()
  i <- 1

  # First loop through data variables
  for (vname in colnames(stns@data)) {

    a_vals_meta <- stns@data[, vname]

    if (class(a_vals_meta) == "character") {

      # If character datatype, values must be stored in 2d variable
      char_len <- max(nchar(a_vals_meta))

      # Create string dimension with size char_len
      dim_string <- ncdim_def(paste0("string_", vname), "", seq(char_len),
                                     create_dimvar = FALSE)
      # Create 2-d variable
      a_var <- ncvar_def(vname, "", list(dim_string, dim_stnid), prec = "char")

    } else {

      a_var <- ncvar_def(vname, "", list(dim_stnid), prec = "double")

    }

    vars_meta[[i]] <- a_var
    vals_meta[[i]] <- a_vals_meta
    i = i + 1

  }

  # Add coordinate variables to the metadata
  for (vname in colnames(coordinates(stns))) {

    a_vals <- as.numeric(coordinates(stns)[, vname])
    a_var <- ncvar_def(vname, "", list(dim_stnid), prec = "double")

    vars_meta[[i]] <- a_var
    vals_meta[[i]] <- a_vals
    i = i + 1

  }

  # Create main 2D observation variables
  vars_main = list()
  i = 1

  for (vname in vnames) {
    a_var <- ncvar_def(vname, "", list(dim_stnid, dim_time), prec = "double",
                              compression = 4, chunksizes = c(1, length(times)), missval = NA)
    vars_main[[i]] <- a_var
    i = i + 1
  }

  # Create netcdf file and add station metadata
  ds <- nc_create(fpath, append(vars_meta, vars_main), force_v4 = T)

  for (i in seq(length(vals_meta))) {

    a_var <- vars_meta[[i]]
    a_vals_meta <- vals_meta[[i]]

    ncvar_put(ds, a_var, a_vals_meta)

  }

  nc_sync(ds)
  nc_close(ds)

  # Return h5file object pointing to the new netcdf file
  return(H5File$new(fpath))

}

#' Convert a tidy/longform dataframe into a spacewide xts object
#'
#' @param df_tidy
#' @param value.var
#' @param time_col
#' @param id_col
#' @return A xts object
#' @export
coerce_tidy_df_to_spacewide_xts <- function(df_tidy, value.var, time_col = "time",
                                            id_col = "station_id") {

  xts_sw <- dcast(df_tidy, as.formula(paste0(time_col, "~", id_col)), value.var = value.var)
  row.names(xts_sw) <- xts_sw[[time_col]]
  xts_sw <- as.xts(xts_sw[, colnames(xts_sw) != time_col])
  return(xts_sw)

}

#' Convert a spacewide xts object to a spacetime STFDF object
#'
#' @param xts_sw
#' @param spdf_locs
#' @param varname
#' @return A STFDF object
#' @export
coerce_spacewide_xts_to_STFDF <- function(xts_sw, spdf_locs, varname) {

  # Create spacetime STFDF object.  Data needs to be a single column data.frame
  # with station id varying the fastest By default time varies the fastest with
  # as.vector call, so transpose first

  adf <- data.frame(as.vector(t(xts_sw)))
  colnames(adf) <- varname
  times <- index(xts_sw)

  if (length(times) < 1) {
    a_stfdf <- STFDF(spdf_locs, times, data = adf)
  } else {
    a_stfdf <- STFDF(spdf_locs, times, data = adf,  endTime = times)
  }

  return(a_stfdf)
}
