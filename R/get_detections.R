# detections_view

# RODBCext
# https://cran.r-project.org/web/packages/RODBCext/vignettes/Parameterized_SQL_queries.html

#   if("All" %in% projectlist) projectlist=NULL
#   if("All" %in% tagprojectlist) tagprojectlist=NULL


get_detections <- function(connection,
                           netwerk_project = NULL,
                           animal_project = NULL,
                           start_date = NULL,
                           end_date = Inf,
                           station = -Inf,
                           tags = NULL) {
  NULL

  # mainquery <- "
  #   SELECT * from vliz.detections_view
  #   WHERE datetime  >= ? and datetime <= ? AND
  #         ...
  #   "
  # data <- data.frame(start_date, end_date)
  # sqlExecute(connection, mainquery, data, fetch = TRUE)

}

# {
# wherecode=""
# # Notice that the 'detections_view' has a different structure + is not a materialized view, which is the reason for
# # the slightly different approach of building the 'where' clause.
# if(!is.null(projectlist)){
#   wherecode <- paste(wherecode," and network_project_name in ( #project# )");
#   wherecode <- str_replace_all(wherecode,"#project#",paste("'",projectlist,"'",sep="",collapse=","));
# }
# if(!is.null(tagprojectlist)){
#     wherecode <- paste(wherecode," and animal_project_name in ( #project# )");
#     wherecode <- paste(wherecode," and tagproj.name in ( #project# )");
# if(!logged){
#   wherecode <- paste(wherecode," and (network_moratorium is null or network_moratorium = FALSE ) ");
# }

