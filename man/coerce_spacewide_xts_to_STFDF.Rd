% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/obs_netcdf.R
\name{coerce_spacewide_xts_to_STFDF}
\alias{coerce_spacewide_xts_to_STFDF}
\title{Convert a spacewide xts object to a spacetime STFDF object}
\usage{
coerce_spacewide_xts_to_STFDF(xts_sw, spdf_locs, varname)
}
\arguments{
\item{xts_sw}{A spacewide xts object.}

\item{spdf_locs}{Stations as a SpatialPointsDataFrame.}

\item{varname}{Variables names of station metadata to load.}
}
\value{
A STFDF object
}
\description{
Convert a spacewide xts object to a spacetime STFDF object
}
\seealso{
  \code{\link{load_time}}, \code{\link{load_stns}}, \code{\link{load_obs}}
}
\examples{
\dontrun{
# Set timezone for environment to UTC
Sys.setenv(TZ="UTC")

# Set file path for ChesWx netCDF observation file
PATH_CHESWX = "/Users/jaredwo/Downloads/data/cheswx"
path_obsnc <- file.path(PATH_CHESWX, "station_data/prcp_homog_19480101_20171231.nc")

# Open observation netCDF file
ds <- H5File$new(path_obsnc, mode='r')

# Load station metadata as a SpatialPointsDataFrame
stns <- load_stns(ds)

# Plot the station points
plot(stns)

# Load time variable data and create vector of POSIXct times
# This is needed when loading actual observations
times <- load_time(ds)

# Load precipitation time series for Richmond airport (station id: GHCND_USW00013740)
# Observations are returned as an xts object
ts_prcp <- load_obs(ds, 'prcp', stns, times, stnids=c('GHCND_USW00013740'))

# Plot Richmond time series
plot.xts(ts_prcp)

# Load precipitation observations from all stations for May 1980
# Observations are returned as an xts object with a column for each station
# This is considered a "spacewide" data structure
prcp <- load_obs(ds, 'prcp', stns, times, start_end=c('1980-05-01','1980-05-31'))

# Convert spacewide xts object to a spatiotemporal data structure from the
# spacetime package
prcp_stfdf <- coerce_spacewide_xts_to_STFDF(prcp, stns, 'prcp')

# Plot map of observations for May 14, 1980
spplot(prcp_stfdf[,'1980-05-14','prcp'])

# Plot multiple maps of observations from May 14-21
stplot(prcp_stfdf[,'1980-05-14/1980-05-21','prcp'])

# Close netcdf file
ds$close_all()
}
}