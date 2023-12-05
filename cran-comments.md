# Test environments
* system: Ubuntu, BootStrap: docker, OSVersion: xenial

# RCMD check results
* using log directory ‘/storage/home/klr324/loadWxObs.Rcheck’
* using R version 3.6.3 (2020-02-29)
* using platform: x86_64-pc-linux-gnu (64-bit)
* using session charset: UTF-8
* using option ‘--as-cran’
* checking for file ‘loadWxObs/DESCRIPTION’ ... OK
* checking extension type ... Package
* this is package ‘loadWxObs’ version ‘0.0.2’
* package encoding: UTF-8
* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Kelsey Ruckert <klr324@psu.edu>’

New submission
* checking package namespace information ... OK
* checking package dependencies ... OK
* checking if this is a source package ... OK
* checking if there is a namespace ... OK
* checking for executable files ... OK
* checking for hidden files and directories ... OK
* checking for portable file names ... OK
* checking for sufficient/correct file permissions ... OK
* checking serialization versions ... OK
* checking whether package ‘loadWxObs’ can be installed ... OK
* checking installed package size ... OK
* checking package directory ... OK
* checking for future file timestamps ... OK
* checking DESCRIPTION meta-information ... OK
* checking top-level files ... OK
* checking for left-over files ... OK
* checking index information ... OK
* checking package subdirectories ... OK
* checking R files for non-ASCII characters ... OK
* checking R files for syntax errors ... OK
* checking whether the package can be loaded ... OK
* checking whether the package can be loaded with stated dependencies ... OK
* checking whether the package can be unloaded cleanly ... OK
* checking whether the namespace can be loaded with stated dependencies ... OK
* checking whether the namespace can be unloaded cleanly ... OK
* checking loading without being on the library search path ... OK
* checking use of S3 registration ... OK
* checking dependencies in R code ... OK
* checking S3 generic/method consistency ... OK
* checking replacement functions ... OK
* checking foreign function calls ... OK
* checking R code for possible problems ... NOTE
load_stnmeta: no visible global function definition for ‘read.csv’
load_tidy_obs: no visible global function definition for ‘read.csv’
load_tidy_obs: no visible global function definition for ‘index<-’
Undefined global functions or variables:
  index<- read.csv
Consider adding
  importFrom("utils", "read.csv")
to your NAMESPACE file.
* checking Rd files ... OK
* checking Rd metadata ... OK
* checking Rd line widths ... OK
* checking Rd cross-references ... OK
* checking for missing documentation entries ... OK
* checking for code/documentation mismatches ... OK
* checking Rd \usage sections ... OK
* checking Rd contents ... OK
* checking for unstated dependencies in examples ... OK
* checking examples ... OK
* checking PDF version of manual ... OK
* checking for detritus in the temp directory ... OK
* DONE

Status: 2 NOTEs
See
  ‘/storage/home/klr324/loadWxObs.Rcheck/00check.log’
for details.