#
# Denormalized data download from the VLIZ server
# -> only works on the Rstudio server installation of VLIZ
#

library(RODBC)
library(readr)

# Read credentials of the database connection
pgcreds <- scan("./.pgpass", what="")

# Read the SQL query
denorm_query <- read_file("./data_publication/denormalized_observations.sql")

# Connect to dbase and execute string
data_connect <- odbcConnect("ETN", pgcreds[1], pgcreds[2])
odbcQuery(channel = data_connect, query = denorm_query)
tabel <- sqlGetResults(channel = data_connect)
mess <- odbcGetErrMsg(data_connect)
print(mess)
close(data_connect)

# Store data as CSV table
write.csv(tabel, "./data_publication/detections_normalized.csv", quote = FALSE)
