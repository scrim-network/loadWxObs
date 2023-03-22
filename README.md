# obsdbr

The obsdbr R package contains a set of utility functions for loading and writing
weather station observations. Currently supports loading and writing from/to local netCDF
observation files.

obsdbr has the following R package dependencies:

* [hdf5r](https://cran.r-project.org/web/packages/hdf5r/index.html)
* [ncdf4](https://cran.r-project.org/web/packages/ncdf4/index.html)
* [reshape2](https://cran.r-project.org/web/packages/reshape2/index.html)
* [RNetCDF](https://cran.r-project.org/web/packages/RNetCDF/index.html)
* [sp](https://cran.r-project.org/web/packages/sp/index.html)
* [spacetime](https://cran.r-project.org/web/packages/spacetime/index.html)
* [stringr](https://cran.r-project.org/web/packages/stringr/index.html)

Example of loading daily precipitation observations from a ChesWx netCDF station observation file.

```r

# Set timezone for environment to UTC
Sys.setenv(TZ="UTC")

# Set file path for ChesWx netCDF observation file
PATH_CHESWX = "/Users/jaredwo/Downloads/data/cheswx"
path_obsnc <- file.path(PATH_CHESWX, "station_data/prcp_homog_19480101_20171231.nc")

# Open observation netCDF file
ds <- hdf5r::H5File$new(path_obsnc, mode='r')

# Load station metadata as a SpatialPointsDataFrame
stns <- obsdbr::load_stns(ds)

# Plot the station points
sp::plot(stns)

# Load time variable data and create vector of POSIXct times
# This is needed when loading actual observations
times <- obsdbr::load_time(ds)

# Load precipitation time series for Richmond airport (station id: GHCND_USW00013740)
# Observations are returned as an xts object
ts_prcp <- obsdbr::load_obs(ds, 'prcp', stns, times, stnids=c('GHCND_USW00013740'))

# Plot Richmond time series
xts::plot.xts(ts_prcp)

# Load precipitation observations from all stations for May 1980
# Observations are returned as an xts object with a column for each station
# This is considered a "spacewide" data structure
prcp <- obsdbr::load_obs(ds, 'prcp', stns, times, start_end=c('1980-05-01','1980-05-31'))

# Convert spacewide xts object to a spatiotemporal data structure from the
# spacetime package
prcp_stfdf <- obsdbr::coerce_spacewide_xts_to_STFDF(prcp, stns, 'prcp')

# Plot map of observations for May 14, 1980
sp::spplot(prcp_stfdf[,'1980-05-14','prcp'])

# Plot multiple maps of observations from May 14-21
spacetime::stplot(prcp_stfdf[,'1980-05-14/1980-05-21','prcp'])

# Close netcdf file
ds$close_all()

```

Example of loading daily precipitation observations from a ChesWx netCDF station observation file using the quick load function. The quick load function loads station metadata and observations
in a single call. Data are returned as a list of station metadata and observations.
Station metadata is a SpatialPointsDataFrame and observations are in a spacewide xts object

```r
# Set timezone for environment to UTC
Sys.setenv(TZ="UTC")

stnobs <- obsdbr::quick_load_stnobs(path_obsnc, 'prcp', c('1980-05-01','1980-05-31'))
stns <- stnobs[['stns']]
obs <- stnobs[['prcp']]

```
## Checking the package
### Singularity
To facilitate building and checking the package, the environment rwas built as a "writable" Singularity container. The built container is stored on Firkin (where it was built). Only the Singularity definition file is provided (`cwx.def`). This definition file can be used to reproduce the container on another system. 

#### Building the container
##### --fakeroot option
A “fake root” user has almost the same administrative rights as root but only inside the container and the requested namespaces, which means that this user:

* can set different user/group ownership for files or directories they own
* can change user/group identity with su/sudo commands
* has full privileges inside the requested namespaces (network, ipc, uts)

##### --sandbox option
To create a container within a writable directory (called a sandbox), it is done with the `--sandbox` option. It’s possible to create a sandbox without root privileges, but to ensure proper file permissions it is recommended to do so as root. We do so using the `--fakeroot` option. 

```
singularity build --fakeroot --sandbox cwx/ cwx.def
``` 
#### Running the container
##### --writable option
To make changes within the container, use the `--writable` flag when invoking the container. This will need to be done in an interactive mode. Once in the container you have update or install packages. 

NOTE: You cannot make fundamental changes to a writeable container. This option is instead great for updating and installing R and python packages interactively as well as downloading git repos.

```
singularity shell --writable cwx/
``` 

### Running CRAN Checks
#### Step 1: Clone the repo within the container
```
git clone https://github.com/klr324/obsdbr.git
```
#### Step 2: Build the package
```
 R CMD build obsdbr
```
#### Step 3: Run the checks
```
R CMD check --as-cran obsdbr_0.0.0.9.tar.gz
```

