# loadWxObs v0.0.2 (Release date: 2023-11-30)
==============
* stringr removed from the list of R dependencies. No commands from stringr are used in the code.
* load_tidy_obs() function added
* load_stnmeta() function added

* Housekeeping changes: 
	* added version 0.0.2 listing to NEWS
	* updated cran-comments file for new version

# loadWxObs v0.0.1 (Release date: 2023-03-22)
==============
Changes:

* obsdbr renamed to loadWxObs, which stands for load weather station observations
	* reasons:
		1. obsdbr is hard to remember
		2. obsdbr is not very meaningful

* Housekeeping changes: 
	* added version 0.0.1 listing to NEWS
	* updated cran-comments file for new version
	* added license, installation, author, and maintainer info to README

# obsdbr v0.0.0.9 (Release date: 2023-03-22)
==============

Changes:

* Housekeeping changes: added NEWS (including retroactive listing of changes) and cran-comments file.
* Change of obsdbr maintainer
* Added some function examples based on those in the original README
* Added singularity definition file for testing package development

Addressed CRAN-COMMENTS: 
 
* Fixed: Version contains large components (0.0.0.9000) ==> 0.0.0.9 (numbers must be between 1-9). 
* Fixed: The Title field should be in title case.
* Fixed: Non-standard license specification: GNU General Public License v3.0 ==> GPL-3
* Fixed: '::' or ':::' imports not declared from: ‘xts’ ‘zoo’ ==> declared imports in NAMESPACE
* Fixed: Undefined global functions or variables: 'aggregate.data.frame' 'as.formula' ==> declared imported functions
* Fixed: Undocumented arguments:
	* in 'coerce_spacewide_xts_to_STFDF': ‘xts_sw’ ‘spdf_locs’ ‘varname’
	* in 'coerce_tidy_df_to_spacewide_xts': ‘df_tidy’ ‘value.var’ ‘time_col’ ‘id_col’

# obsdbr v0.0.0.9000 (Release date: 2019-08-25)
==============

* Initial pre-release.