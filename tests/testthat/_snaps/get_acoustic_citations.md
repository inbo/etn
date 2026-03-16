# get_acoustic_citations() prints citations to console

    Code
      get_acoustic_citations("Orstedcod")
    Message
      
      -- ORSTEDCOD : ORSTED COD --
      
      * Winter, Erwin. (2021). ORSTED COD project

# get_acoustic_citations() can group citations for multiple acoustic_project_codes

    Code
      get_acoustic_citations(c("2004_Gudena", "2011_bovenschelde", "2011_Loire",
        "2011_Warnow", "2013_Foyle"))
    Condition
      Warning:
      No citation found on IMIS for: 2011_Bovenschelde
    Message
      
      -- 2004_Gudena : Acoustic receiver array in the Gudena River, Denmark, from 2004-2006 --
      
      * Aarestrup, K.; Thorstad, EB.; Koed, A.; Svendsen, JC.; Jepsen, N.; Pedersen,
      MI.;  Økland, F.; (2004) Acoustic receiver array in the Gudena River, Denmark,
      from 2005-2005 <https://doi.org/10.14284/735>
      
      -- 2011_Loire : Migration behaviour of silver eels (Anguilla anguilla) in a large estuary of Western Europe inferred from acoustic telemetry --
      
      * Bultel, E.; Lasne, E.; Acou, .A.; Guillaudeau, J.; Bertier, C.; Feunteun, E.;
      (2014) Migration behaviour of silver eels (Anguilla anguilla) in a large
      estuary of Western Europe inferred from acoustic telemetry.
      
      -- 2011_Warnow : Acoustic telemetry receiver array in the River Warnow (Germany) from 2011-2012 --
      
      * Frankowski, J.; Dorow, M.; Reckordt, M.; Ubl, C. (2019). Acoustic telemetry
      receiver array in the River Warnow (Germany) from 2011-2012
      <https://doi.org/10.14284/741>
      
      -- 2013_Foyle : Freshwater and coastal migration patterns in the silver-stage eel Anguilla anguilla --
      
      * Barry, J., Newton, M., Dodd, J. A., Lucas, M. C., Boylan, P., & Adams, C. E.
      (2016). Freshwater and coastal migration patterns in the silver‐stage eel
      Anguilla anguilla.

