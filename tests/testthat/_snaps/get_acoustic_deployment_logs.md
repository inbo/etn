# get_acoustic_deployment_logs() returns nice message on missing logs

    Code
      get_acoustic_deployment_logs(c(ids_no_logs, ids_with_logs))
    Condition
      Warning:
      x Can't find any logs for `deployment_id` "1758" and "2489".
      i Use `get_acoustic_deployments()` to get general information for these deployment(s).
    Output
      # A tibble: 10,108 x 20
         deployment_id receiver_id record_type datetime            station_name
                 <int> <chr>       <chr>       <dttm>              <chr>       
       1         53790 VR2W-136740 DIAG        2020-08-30 18:00:00 G09         
       2         53790 VR2W-136740 DIAG        2021-04-03 05:00:00 G09         
       3         53790 VR2W-136740 DIAG        2021-07-24 12:00:00 G09         
       4         53790 VR2W-136740 DIAG        2020-12-22 06:00:00 G09         
       5         53790 VR2W-136740 DIAG        2020-09-02 22:00:00 G09         
       6         53790 VR2W-136740 DIAG        2021-06-13 10:00:00 G09         
       7         53790 VR2W-136740 DIAG        2021-02-07 04:00:00 G09         
       8         53790 VR2W-136740 DIAG        2021-06-21 12:00:00 G09         
       9         53790 VR2W-136740 DIAG        2020-10-05 17:00:00 G09         
      10         53790 VR2W-136740 DIAG        2020-10-06 08:00:00 G09         
      # i 10,098 more rows
      # i 15 more variables: PPM_pings <int>, PPM_detections <int>,
      #   device_time_UTC <dttm>, battery_voltage_V <dbl>, RTC_time <chr>,
      #   `memory_remaining_%` <dbl>, index <int>, decoder <chr>, PPM_map_ID <chr>,
      #   frequency_khz <int>, source <chr>, external_time_UTC <dttm>,
      #   external_difference_s <int>, firmware_version <chr>,
      #   external_time_zone <chr>

