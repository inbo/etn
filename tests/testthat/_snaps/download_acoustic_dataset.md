# download_acoustic_dataset() returns message and summary stats

    Code
      cat(download_acoustic_dataset(con, animal_project_code = "2014_demer"))
    Message <simpleMessage>
      Downloading data to directory `2014_demer`:
      * (1/6): downloading animals.csv
      * (2/6): downloading tags.csv
      * (3/6): downloading detections.csv
      * (4/6): downloading deployments.csv
      * (5/6): downloading receivers.csv
      * (6/6): adding datapackage.json as file metadata
      
      Summary statistics for dataset `2014_demer`:
      * number of animals:           16
      * number of tags:              16
      * number of detections:        236918
      * number of deployments:       1081
      * number of receivers:         244
      * first date of detection:     2014-04-18
      * last date of detection:      2018-09-15
      * included scientific names:   Petromyzon marinus, Rutilus rutilus, Silurus glanis, Squalius cephalus
      * included acoustic projects:  V2LCHASES, albert, demer, dijle, zeeschelde
      

