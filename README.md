# obsdbr

The obsdbr R package contains a set of utility functions for loading and writing
weather station observations. Currently supports loading and writing from/to local netCDF
observation files.

obsdbr has the following R package dependencies:

* [h5](https://cran.r-project.org/web/packages/h5/index.html)
* [ncdf4](https://cran.r-project.org/web/packages/ncdf4/index.html)
* [reshape2](https://cran.r-project.org/web/packages/reshape2/index.html)
* [RNetCDF](https://cran.r-project.org/web/packages/RNetCDF/index.html)
* [sp](https://cran.r-project.org/web/packages/sp/index.html)
* [spacetime](https://cran.r-project.org/web/packages/spacetime/index.html)
* [stringr](https://cran.r-project.org/web/packages/stringr/index.html)

Example of loading daily minimum temperature observations from a [TopoWx netCDF station observation file](https://download.scrim.psu.edu/TopoWx/release_2017-07/auxiliary_data/station_data).

```r

# Set timezone for environment to UTC
Sys.setenv(TZ="UTC")

# Open netcdf observation file
ds <- h5::h5file('stn_obs_tmin.nc', mode='r')

# Load station metadata as a SpatialPointsDataFrame
stns <- obsdbr::load_stns(ds)

# Plot the station points
sp::plot(stns)

# Load time variable data and create vector of POSIXct times
# This is needed when loading actual observations
times <- obsdbr::load_time(ds)

# Load Tmin time series for Richmond airport (station id: GHCND_USW00013740)
# Observations are returned as an xts object
ts_tmin <- obsdbr::load_obs(ds, 'tmin_homog', stns, times, stnids=c('GHCND_USW00013740'))

# Plot Richmond time series
xts::plot.xts(ts_tmin)

# Load Tmin observations from all stations for May 1980
# Observations are returned as an xts object with a column for each station
# This is considered a "spacewide" data structure
tmin <- obsdbr::load_obs(ds, 'tmin_homog', stns, times, start_end=c('1980-05-01','1980-05-31'))

# Convert spacewide xts object to a spatiotemporal data structure from the
# spacetime package
prcp_stfdf <- obsdbr::coerce_spacewide_xts_to_STFDF(tmin, stns, 'tmin')

# Plot map of observations for May 14, 1980
sp::spplot(prcp_stfdf[,'1980-05-14','tmin'])

# Plot multiple maps of observations from May 14-21
spacetime::stplot(prcp_stfdf[,'1980-05-14/1980-05-21','tmin'])

# Close netcdf file
h5::h5close(ds)

```

Example of loading daily minimum temperature observations from a [TopoWx netCDF station observation file](https://download.scrim.psu.edu/TopoWx/release_2017-07/auxiliary_data/station_data) using the quick load function. The quick load function loads station metadata and observations
in a single call. Data are returned as a list of station metadata and observations.
Station metadata is a SpatialPointsDataFrame and observations are in a spacewide xts object

```r
# Set timezone for environment to UTC
Sys.setenv(TZ="UTC")

stnobs <- obsdbr::quick_load_stnobs('stn_obs_tmin.nc', 'tmin_homog', c('1980-05-01','1980-05-31'))
stns <- stnobs[[1]]
obs <- stnobs[[2]]

```

