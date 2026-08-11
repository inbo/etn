# List all available acoustic project codes

List all available acoustic project codes

## Usage

``` r
list_acoustic_project_codes(connection)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

## Value

A vector of all unique `project_code` of `type = "acoustic"` in
`project.sql`.

## See also

Other list functions:
[`list_acoustic_tag_ids()`](https://inbo.github.io/etn/reference/list_acoustic_tag_ids.md),
[`list_animal_ids()`](https://inbo.github.io/etn/reference/list_animal_ids.md),
[`list_animal_project_codes()`](https://inbo.github.io/etn/reference/list_animal_project_codes.md),
[`list_cpod_project_codes()`](https://inbo.github.io/etn/reference/list_cpod_project_codes.md),
[`list_deployment_ids()`](https://inbo.github.io/etn/reference/list_deployment_ids.md),
[`list_receiver_ids()`](https://inbo.github.io/etn/reference/list_receiver_ids.md),
[`list_scientific_names()`](https://inbo.github.io/etn/reference/list_scientific_names.md),
[`list_station_names()`](https://inbo.github.io/etn/reference/list_station_names.md),
[`list_tag_serial_numbers()`](https://inbo.github.io/etn/reference/list_tag_serial_numbers.md),
[`list_values()`](https://inbo.github.io/etn/reference/list_values.md)

## Examples

``` r
list_acoustic_project_codes()
#>   [1] "2004_Gudena"                    "2011_bovenschelde"             
#>   [3] "2011_Loire"                     "2011_Warnow"                   
#>   [5] "2013_Foyle"                     "2013_Maas"                     
#>   [7] "2014_Frome"                     "2014_Nene"                     
#>   [9] "2015_PhD_Gutmann_Roberts"       "2016_Diaccia_Botrona"          
#>  [11] "2017_Fremur"                    "2020_PhD_Winter"               
#>  [13] "2021_YEELAZ"                    "2022_Beaver_Durme"             
#>  [15] "2023_meuse_Lith_Linne"          "2024_Anguilla_bb_Harlingen"    
#>  [17] "2024_BECO_IIM_RIAVIGO"          "2024_bovenschelde"             
#>  [19] "2024-2031_Northsea_Ecowende"    "2025_anguilla_volkerak_array"  
#>  [21] "2025_IJmuidenRotterdam_array"   "2025_langsdammen_array"        
#>  [23] "2025_Nederrijn_Lek_array"       "2025-2026_RijnWest_array"      
#>  [25] "2025-28_NorthSeaNL_MONS_array"  "2026_PhD_Visser_network"       
#>  [27] "aagone_study_aude_network"      "Aberdeen"                      
#>  [29] "albert"                         "Albertkanaal_VPS_Ham"          
#>  [31] "Albertkanaal_VPS_Hasselt"       "Allis_shad_migration_Oise_2024"
#>  [33] "Apelafico"                      "ARAISOLA02"                    
#>  [35] "ARAISOLA03"                     "Ars"                           
#>  [37] "Artevigo"                       "ASMOP1"                        
#>  [39] "ASMOP2"                         "AZO"                           
#>  [41] "BALANCE"                        "Baltic_Sturgeon_Restoration"   
#>  [43] "BECORV"                         "BIT_array"                     
#>  [45] "Blueconnect"                    "BlueCrab2022Algarve"           
#>  [47] "BOATS_network"                  "Bodden_Pike"                   
#>  [49] "BOOGMR"                         "BOOPAP"                        
#>  [51] "BOOPIRATA"                      "BOORAMA"                       
#>  [53] "BOOSBI"                         "bpns"                          
#>  [55] "Brasem_IJM_MM"                  "BristolChannelArray"           
#>  [57] "BSTN"                           "BTN"                           
#>  [59] "BTN_LOST_ARRAY"                 "BTN-DeepWater-IMEDEA"          
#>  [61] "BTN-IMEDEA"                     "CANAPE"                        
#>  [63] "Carlingford"                    "CESB_network"                  
#>  [65] "CMAX_Hebrides"                  "COD_OG_DK_2023"                
#>  [67] "COD_OWF"                        "Cod-connectivity"              
#>  [69] "CODEVCO_fish_detectors"         "COLAGANG"                      
#>  [71] "CONNECT-MED"                    "Conon"                         
#>  [73] "COREMAR"                        "CORYTRACK"                     
#>  [75] "cpodnetwork"                    "Crab_behavior_aquaculture_Norw"
#>  [77] "Csapidus_Southern_France"       "CTN"                           
#>  [79] "DAbecasis_PhD"                  "DAERA_Elasmobranch_Network"    
#>  [81] "DAK"                            "Danish_southeastern_strait"    
#>  [83] "Danish_Straits"                 "Danube_Sturgeons"              
#>  [85] "DEHINC.HABI.GUACETO"            "Delfzijl"                      
#>  [87] "demer"                          "Deveron"                       
#>  [89] "dijle"                          "Dijle_VPS"                     
#>  [91] "DSM"                            "DTU-Skjern"                    
#>  [93] "DuskMaro"                       "EBAMAR_array"                  
#>  [95] "Eel_HighRhine_26-29_array"      "Eel_migration_Test_2023"       
#>  [97] "Eel-source-to-sea"              "eemskanaal_I"                  
#>  [99] "eemskanaal_II"                  "eemskanaal_III"                
#> [101] "EMFish_test"                    "EMMN"                          
#> [103] "ESGL"                           "ETN_network_project_group_1"   
#> [105] "ETN_network_project_group_2"    "ETN_network_project_group_3"   
#> [107] "ETN_network_project_group_4"    "ETN_network_project_group_5"   
#> [109] "ETN_network_project_group_6"    "ETN_network_project_group_7"   
#> [111] "ETN_network_project_group_8"    "ETN_network_project_group_9"   
#> [113] "EUTN"                           "FarmTrack_network"             
#> [115] "Finescale_Helgoland"            "Fish_Mig_Wad_Sea"              
#> [117] "FISHINTEL"                      "FISHINTEL_aquaculture"         
#> [119] "FISHOWF"                        "FISHOWF+"                      
#> [121] "FISP"                           "Foyle_Catchment"               
#> [123] "Friesland"                      "GEPESCART2_ARRAY"              
#> [125] "GIBRALTRACK_pilot"              "Grotenete"                     
#> [127] "GTN"                            "Gudena_network"                
#> [129] "GuitarProtect_array"            "Haringvliet2023-2026"          
#> [131] "Hevring_Trout_Denmark"          "HinkleyFineScaleArray2025"     
#> [133] "HinkleyFineScaleArray2026"      "HR2_3D_tracking_eel_reservoir" 
#> [135] "IBASS"                          "ICOD_receiver_array"           
#> [137] "IG_II_Fish_Pass"                "IG_Waves"                      
#> [139] "Iller_VPS"                      "IMR_OWF"                       
#> [141] "Inforbiomares"                  "Inner_Foyle"                   
#> [143] "IOA"                            "Jersey_Coastal"                
#> [145] "JJ_Belwind"                     "JSATS-PalmaBay-2019"           
#> [147] "Kattegat_Islands"               "KBTN"                          
#> [149] "KERG"                           "KiBiAN"                        
#> [151] "kornwerderzand"                 "Lake_Anundsjo_VPS"             
#> [153] "LamTre20_21"                    "LamYorOus18-20"                
#> [155] "lauwersmeer"                    "LBSSM"                         
#> [157] "leopold"                        "LESPUR"                        
#> [159] "life4fish"                      "lifewatch"                     
#> [161] "Lifewatch_additional_stations"  "Lifewatch_performance_test"    
#> [163] "Limfjord"                       "LionFishMED"                   
#> [165] "LSTSTJ_MPA"                     "MacFish"                       
#> [167] "Mangar-Keban"                   "Mapping_Algarve_Sharks"        
#> [169] "Marble_rainbow_trout"           "mare_wind_finescale"           
#> [171] "MariagerFjord_network"          "MBA_Massmo"                    
#> [173] "MBA_Wavehub"                    "MBA_Whitsand"                  
#> [175] "Mecklenburg_fish_movements"     "mepnsw_network"                
#> [177] "MERMOZ_ARRAY"                   "MI_ClewBay_Achill_network"     
#> [179] "MIGRATOEBRE"                    "MMERMAID"                      
#> [181] "MOBEIA"                         "Mobula_IMAR"                   
#> [183] "MOPP"                           "MorayFirth"                    
#> [185] "MOVE_CCMAR_NETWORK"             "mrc_vliz"                      
#> [187] "NARVAEEL"                       "NETFISH_ARRAY"                 
#> [189] "no_info"                        "none"                          
#> [191] "Noordzeekanaal"                 "North_sea_wrecks"              
#> [193] "Northern_Norfolk_Broads"        "NTNU-Gaulosen"                 
#> [195] "OP-Test"                        "Orbetello_lagoon_array"        
#> [197] "Orstedcod"                      "OTN_UPLOAD"                    
#> [199] "OTN-Hemnfjorden"                "OTN-Skjerstadfjorden"          
#> [201] "OTN-Tosenfjorden"               "Outer_Foyle"                   
#> [203] "paintedcomber"                  "pc4c"                          
#> [205] "PelFish"                        "PhD_Barbara_Koeck"             
#> [207] "PhD_Jeremy_Pastor"              "PhD_Marrocco"                  
#> [209] "PhD_Nolan"                      "PhD_Parcerisas"                
#> [211] "PhysFish"                       "porbeagle_tracking_network"    
#> [213] "PrePARED"                       "PTN_ATLAZUL"                   
#> [215] "PTN_MEROSW2021"                 "PTN_MIGRACORV"                 
#> [217] "PTN_PROTECT2012"                "PTN_PROTECT2013"               
#> [219] "PTN-MARSW"                      "PTN-Silver-eel-Mondego"        
#> [221] "PureWind_fish_detectors"        "RAJIBAL-COFIB"                 
#> [223] "RATJADA"                        "RBVV2"                         
#> [225] "RECCRU_array"                   "Reelease"                      
#> [227] "RESBIO"                         "ResMed"                        
#> [229] "river_severn_array"             "River_Usk"                     
#> [231] "RNP"                            "rt2020_zeeschelde"             
#> [233] "RTT"                            "Running_eel"                   
#> [235] "saeftinghe"                     "Salmo_Migration_NSIC"          
#> [237] "Salmon_Eastern_Greenland"       "SAMARCH"                       
#> [239] "SARTELARAM"                     "SARTELTG"                      
#> [241] "SARTELZINGARO"                  "SCHUFI"                        
#> [243] "Scytrack"                       "SeaMonitor"                    
#> [245] "SEAMONITOR_ARRAY"               "SEM_array"                     
#> [247] "SEMP"                           "severn_multi_species"          
#> [249] "SGB"                            "Shark_Levant_tracking"         
#> [251] "SIARC_ARRAY"                    "Siganid_East_Med"              
#> [253] "Siganid_Gulf_Aqaba"             "Skagerrak-NorthSea-array"      
#> [255] "SkagNor"                        "Skye"                          
#> [257] "SMAFBI"                         "SmartBay_array"                
#> [259] "SMLA"                           "SMOLTRACK-I-Engeland"          
#> [261] "SMOLTRACK-II-Engeland"          "SMUOG"                         
#> [263] "SPAWNSEIS"                      "SPICARA_network"               
#> [265] "SPIDER_GNB_array"               "SrivAqab"                      
#> [267] "SrivEMed"                       "ST08SWE"                       
#> [269] "STRAITS_GIBRALTAR_ARRAY"        "STRAITS_TSTN"                  
#> [271] "Sturgeon_reintroduction_array"  "sturgeonSK"                    
#> [273] "STURNETGEBZE_ARRAY"             "SU.MO.ELASMO.Adriatic"         
#> [275] "SUBSEA_S3"                      "Sudle_IMPULS"                  
#> [277] "Sudle_INNOV"                    "super_smolts_array"            
#> [279] "SUPERSAT"                       "SVNL-FISH-WATCH"               
#> [281] "SW_Oude_Ijssel"                 "SWIMWAY_2021"                  
#> [283] "Swimway_vechte"                 "Swiss_AcTel"                   
#> [285] "SWRL_array"                     "TelePomiMer_array"             
#> [287] "TelMarsw"                       "TeRi"                          
#> [289] "testvr2ar"                      "thornton"                      
#> [291] "TRACE_network"                  "Trout_movement_Skye_2021-2023" 
#> [293] "TurkishMEDTrack"                "TurkishTunaTrack"              
#> [295] "UseIT_BlueCrab_Tracking_array"  "UtS"                           
#> [297] "V2LBEIAR"                       "V2LCASP"                       
#> [299] "V2LCHASES"                      "V2LFALK"                       
#> [301] "V2LGOL"                         "V2LIMFSTP"                     
#> [303] "V2LLIMS"                        "V2LNR"                         
#> [305] "V2LSMQUB"                       "V2LWATCH"                      
#> [307] "VFM_BP"                         "VFM_Braviken"                  
#> [309] "VFM_DSTL"                       "VFM_GoB"                       
#> [311] "VFM_Hjalmaren"                  "VFM_Malaren"                   
#> [313] "VFM_RG"                         "VFM_Siljan"                    
#> [315] "VFM_Vattern"                    "VFM_WCC"                       
#> [317] "VFMLNU_Blekinge"                "VFMLNU_Osby_network"           
#> [319] "VLIZ_SANDEEL"                   "VMLSMMI"                       
#> [321] "VMLSOCBS"                       "VVV"                           
#> [323] "Walloneel"                      "WCTP_array"                    
#> [325] "Winde_Tjeukemeer"               "ws1"                           
#> [327] "ws2"                            "ws3"                           
#> [329] "Z001"                           "zeeschelde"                    
#> [331] "ZRM_network"                   
```
