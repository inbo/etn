# cite_imis_dataset() doesn't introduce encoding issues

    Code
      dplyr::pull(cite_imis_dataset(imis_dataset_ids = c(8856, 6336, 8857, 6333, 6716)),
      "citation")
    Output
      [1] "Aarestrup, K.; Thorstad, EB.; Koed, A.; Svendsen, JC.; Jepsen, N.; Pedersen, MI.; Økland, F.; (2004) Acoustic receiver array in the Gudena River, Denmark, from 2005-2005. https://doi.org/10.14284/735"           
      [2] "Bultel, E.; Lasne, E.; Acou, .A.; Guillaudeau, J.; Bertier, C.; Feunteun, E.; (2014) Migration behaviour of silver eels (Anguilla anguilla) in a large estuary of Western Europe inferred from acoustic telemetry."
      [3] "Frankowski, J.; Dorow, M.; Reckordt, M.; Ubl, C. (2019). Acoustic telemetry receiver array in the River Warnow (Germany) from 2011-2012. https://doi.org/10.14284/741"                                             
      [4] "Barry, J., Newton, M., Dodd, J. A., Lucas, M. C., Boylan, P., & Adams, C. E. (2016). Freshwater and coastal migration patterns in the silver‐stage eel Anguilla anguilla."                                         
      [5] "Winter, Erwin. (2021). ORSTED COD project"                                                                                                                                                                         

# Encoding issue persists starting from identical file

    Code
      cite_imis_dataset(8856)
    Output
      # A tibble: 1 x 6
        imis_dataset_id citation  doi   contact_name contact_email contact_affiliation
                  <int> <chr>     <chr> <chr>        <chr>         <chr>              
      1            8856 Aarestru~ http~ Kim Aarestr~ kaa@aqua.dtu~ National Institute~

