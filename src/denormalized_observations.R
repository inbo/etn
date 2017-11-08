# Script to download denormalized detection data from the OTN database at VLIZ
# Note: this script will only work on the Rstudio server environment at VLIZ
#
# Load libraries:
library(RODBC)
library(readr)

# Read credentials of the database connection:
pgcreds <- scan("./.pgpass", what="")

denorm_query <- read_file("./data_publication/denormalized_observations.sql")
# Read SQL query file:

# Connect to database and execute string:
data_connect <- odbcConnect("ETN", pgcreds[1], pgcreds[2])
odbcQuery(channel = data_connect, query = denorm_query)
tabel <- sqlGetResults(channel = data_connect)
mess <- odbcGetErrMsg(data_connect)
print(mess)
close(data_connect)

write.csv(tabel, "./data_publication/detections_normalized.csv", quote = FALSE)
# Save data as a CSV file:
