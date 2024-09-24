# etn 2.3.0

* Added a `NEWS.md` file to track changes to the package.
* All functions now make use of an API to connect to the database, allowing you use the etn package on your computer. Still working from the [LifeWatch RStudio Server](https://rstudio.lifewatch.be/)? Then you can use the argument `api = FALSE` in your functions to get a direct connection to the database, which is generally faster.
* The connection argument is no longer used. You will be prompted for credentials instead. So use `get_animals(animal_id = 305)`, not `get_animals(con, animal_id = 305)` or `get_animals(connection = con, animal_id = 305)`.
* Deprecated functions `get_deployments()`, `get_detections()`, `get_projects()`, `get_receivers()`, `list_network_project_codes()` and `list_tag_ids()` are now end of life and no longer included in etn 3.0.0
* `write_dwc()` now invisibly returns a list of data.frames even when writing out to a file (with `directory` set to a path)

