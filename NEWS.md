# vvtableau 0.7.0
* Updated function to get a list of all projects on the server.
* Added all possible arguments to the `download_tableau_date` function.
* Added vignettes on data and user management.

# vvtableau 0.6.0
* Added a function to run extract refresh task immediately on server.
* Added a function to update a data source on server.
* Added a function to update a workbook on server.

# vvtableau 0.5.0
* Fixes missing export tags.
* Added page_number arguments.
* Added a function to extract URLs from local workbooks using XML.
* Added a function to download datasources.

# vvtableau 0.4.0
* Added Users and Groups Tableau REST Api methods.
* Organized the reference page on package website.

# vvtableau 0.3.0
* Added a function to authenticate to Tableau Server and Tableau Cloud using personal access token.

# vvtableau 0.2.0

## Breaking Changes in Version  0.2.0

* Deprecated the `base_url`, `site_id`, and `token` arguments in favor of the `tableau` argument in the `get_server_workbooks` function. Users are now required to pass a `tableau` object returned by the `authenticate_tableau_server` function for authentication.

* Added a `NEWS.md` file to track changes to the package.
