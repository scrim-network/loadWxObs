# Test environments
* system: Ubuntu, BootStrap: debootstrap, OSVersion: focal

# RCMD check results
* using log directory ‘/home/staff/klr324/obsdbr.Rcheck’
* using R version 3.6.3 (2020-02-29)
* using platform: x86_64-pc-linux-gnu (64-bit)
* using session charset: UTF-8
* using option ‘--as-cran’
* checking for file ‘obsdbr/DESCRIPTION’ ... OK
* this is package ‘obsdbr’ version ‘0.0.0.9000’
* package encoding: UTF-8
* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Jared Oyler <jaredwo@gmail.com>’

New submission

Version contains large components (0.0.0.9000)

Non-FOSS package license (GNU General Public License v3.0)

The Title field should be in title case. Current version is:
‘Loads and writes station observations from/to local binary files or databases’
In title case that is:
‘Loads and Writes Station Observations from/to Local Binary Files or Databases’
* checking package namespace information ... OK
* checking package dependencies ... OK
* checking if this is a source package ... OK
* checking if there is a namespace ... OK
* checking for executable files ... OK
* checking for hidden files and directories ... OK
* checking for portable file names ... OK
* checking for sufficient/correct file permissions ... OK
* checking serialization versions ... OK
* checking whether package ‘obsdbr’ can be installed ... OK
* checking installed package size ... OK
* checking package directory ... OK
* checking for future file timestamps ... OK
* checking DESCRIPTION meta-information ... WARNING
Non-standard license specification:
  GNU General Public License v3.0
Standardizable: FALSE
* checking top-level files ... NOTE
Files ‘README.md’ or ‘NEWS.md’ cannot be checked without ‘pandoc’ being installed.
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
* checking dependencies in R code ... WARNING
'::' or ':::' imports not declared from:
  ‘xts’ ‘zoo’
* checking S3 generic/method consistency ... OK
* checking replacement functions ... OK
* checking foreign function calls ... OK
* checking R code for possible problems ... NOTE
build_pormask: no visible global function definition for
  ‘aggregate.data.frame’
coerce_tidy_df_to_spacewide_xts: no visible global function definition
  for ‘as.formula’
load_stns: no visible global function definition for ‘as.formula’
Undefined global functions or variables:
  aggregate.data.frame as.formula
Consider adding
  importFrom("stats", "aggregate.data.frame", "as.formula")
to your NAMESPACE file.
* checking Rd files ... OK
* checking Rd metadata ... OK
* checking Rd line widths ... OK
* checking Rd cross-references ... OK
* checking for missing documentation entries ... OK
* checking for code/documentation mismatches ... OK
* checking Rd \usage sections ... WARNING
Undocumented arguments in documentation object 'coerce_spacewide_xts_to_STFDF'
  ‘xts_sw’ ‘spdf_locs’ ‘varname’

Undocumented arguments in documentation object 'coerce_tidy_df_to_spacewide_xts'
  ‘df_tidy’ ‘value.var’ ‘time_col’ ‘id_col’

Functions with \usage entries need to have the appropriate \alias
entries, and all their arguments documented.
The \usage entries must correspond to syntactically valid R code.
See chapter ‘Writing R documentation files’ in the ‘Writing R
Extensions’ manual.
* checking Rd contents ... OK
* checking for unstated dependencies in examples ... OK
* checking examples ... NONE
* checking PDF version of manual ... WARNING
LaTeX errors when creating PDF version.
This typically indicates Rd problems.
* checking PDF version of manual without hyperrefs or index ... ERROR
Re-running with no redirection of stdout/stderr.
Hmm ... looks like a package
Error in texi2dvi(file = file, pdf = TRUE, clean = clean, quiet = quiet,  : 
  pdflatex is not available
Error in texi2dvi(file = file, pdf = TRUE, clean = clean, quiet = quiet,  : 
  pdflatex is not available
Error in running tools::texi2pdf()
You may want to clean up by 'rm -Rf /tmp/RtmpcokT2R/Rd2pdfcdacc16f5900c'
* checking for code which exercises the package ... WARNING
No examples, no tests, no vignettes
* checking for detritus in the temp directory ... OK
* DONE

Status: 1 ERROR, 5 WARNINGs, 3 NOTEs
See
  ‘/home/staff/klr324/obsdbr.Rcheck/00check.log’
for details.