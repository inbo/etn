# etn 2.3.0

* **The etn package can now be used on your computer!** It connects to the ETN database with an API provided by the [etnservice](https://github.com/inbo/etnservice) package. All functions make use of this API by default, which may result in **slower response times**. To use the previous method of directly connecting to the database (only possible when working on the [LifeWatch RStudio Server](https://rstudio.lifewatch.be/)), set `api = false` in all functions (#280).
* The `connection` argument is no longer used and therefore deprecated. You will be prompted for credentials instead. Use e.g. `get_animals(animal_id = 305)`, not `get_animals(con, animal_id = 305)` or `get_animals(connection = con, animal_id = 305)` (#301).
* `connect_to_etn()` is no longer necessary and is deprecated as of this version. All functions will create their own connection when used. If you have no credentials stored in the system environment, the functions will require you to enter them once per session. (#303)
* The deprecated functions `get_deployments()`, `get_detections()`, `get_projects()`, `get_receivers()`, `list_network_project_codes()` are no longer included.
* `write_dwc()` now invisibly returns the transformed data as a list of data frames (rather than a data frame) (#302).
