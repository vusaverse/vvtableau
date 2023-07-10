# vvtableau 0.2.0

## Breaking Changes in Version  0.2.0

* Deprecated the `base_url`, `site_id`, and `token` arguments in favor of the `tableau` argument in the `get_server_workbooks` function. Users are now required to pass a `tableau` object returned by the `authenticate_tableau_server` function for authentication.

* Added a `NEWS.md` file to track changes to the package.
