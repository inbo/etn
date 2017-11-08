# Script to download denormalized detection data from the OTN database at VLIZ
# Note: this script will only work on the Rstudio server environment at VLIZ
#
# Load libraries:
library(RODBC)
library(readr)

# Read credentials of the database connection:
pgcreds <- scan("./.pgpass", what="")

# Read SQL query file:
denorm_query <- read_file("denormalized_observations.sql")

# Connect to database and execute string:
data_connect <- odbcConnect("ETN", pgcreds[1], pgcreds[2])
odbcQuery(channel = data_connect, query = denorm_query)
table <- sqlGetResults(channel = data_connect)
mess <- odbcGetErrMsg(data_connect)
print(mess)
close(data_connect)

# Save data as a CSV file:
write.csv(table, "../data/raw/denormalized_observations.csv", na = "", row.names = FALSE, fileEncoding = "UTF-8")
