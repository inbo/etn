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
#>  [15] "2023_meuse_Lith_Linne"          "2024_allis_shad_rhine"         
#>  [17] "2024_Anguilla_bb_Harlingen"     "2024_BECO_IIM_RIAVIGO"         
#>  [19] "2024_bovenschelde"              "2024-2031_Northsea_Ecowende"   
#>  [21] "2025_anguilla_volkerak_array"   "2025_IJmuidenRotterdam_array"  
#>  [23] "2025_langsdammen_array"         "2025_Nederrijn_Lek_array"      
#>  [25] "2025-2026_RijnWest_array"       "2025-28_NorthSeaNL_MONS_array" 
#>  [27] "2026_PhD_Visser_network"        "2026-7_Solent_Seascape"        
#>  [29] "aagone_study_aude_network"      "Aberdeen"                      
#>  [31] "albert"                         "Albertkanaal_VPS_Ham"          
#>  [33] "Albertkanaal_VPS_Hasselt"       "Allis_shad_migration_Oise_2024"
#>  [35] "Apelafico"                      "ARAISOLA02"                    
#>  [37] "ARAISOLA03"                     "Ars"                           
#>  [39] "Artevigo"                       "ASMOP1"                        
#>  [41] "ASMOP2"                         "AZO"                           
#>  [43] "BALANCE"                        "Baltic_Sturgeon_Restoration"   
#>  [45] "BECORV"                         "BIT_array"                     
#>  [47] "Blueconnect"                    "BlueCrab2022Algarve"           
#>  [49] "Bodden_Pike"                    "BOOGMR"                        
#>  [51] "BOOPAP"                         "BOOPIRATA"                     
#>  [53] "BOORAMA"                        "BOOSBI"                        
#>  [55] "bpns"                           "Brasem_IJM_MM"                 
#>  [57] "BristolChannelArray"            "BSTN"                          
#>  [59] "BTN"                            "BTN_BOATS_network"             
#>  [61] "BTN_LOST_ARRAY"                 "BTN-DeepWater-IMEDEA"          
#>  [63] "BTN-IMEDEA"                     "CANAPE"                        
#>  [65] "Carlingford"                    "CESB_network"                  
#>  [67] "CMAX_Hebrides"                  "COD_OG_DK_2023"                
#>  [69] "COD_OWF"                        "Cod-connectivity"              
#>  [71] "CODEVCO_fish_detectors"         "COLAGANG"                      
#>  [73] "CONNECT-MED"                    "Conon"                         
#>  [75] "COREMAR"                        "CORYTRACK"                     
#>  [77] "cpodnetwork"                    "Crab_behavior_aquaculture_Norw"
#>  [79] "Csapidus_Southern_France"       "CTN"                           
#>  [81] "DAbecasis_PhD"                  "DAERA_Elasmobranch_Network"    
#>  [83] "DAK"                            "Danish_southeastern_strait"    
#>  [85] "Danish_Straits"                 "Danube_Sturgeons"              
#>  [87] "DEHINC.HABI.GUACETO"            "Delfzijl"                      
#>  [89] "demer"                          "Deveron"                       
#>  [91] "dijle"                          "Dijle_VPS"                     
#>  [93] "DSM"                            "DTU-Skjern"                    
#>  [95] "DuskMaro"                       "EBAMAR"                        
#>  [97] "Eel_HighRhine_26-29_array"      "Eel_migration_Test_2023"       
#>  [99] "Eel-source-to-sea"              "eemskanaal_I"                  
#> [101] "eemskanaal_II"                  "eemskanaal_III"                
#> [103] "EMFish_test"                    "EMMN"                          
#> [105] "ESGL"                           "ETN_network_project_group_1"   
#> [107] "ETN_network_project_group_2"    "ETN_network_project_group_3"   
#> [109] "ETN_network_project_group_4"    "ETN_network_project_group_5"   
#> [111] "ETN_network_project_group_6"    "ETN_network_project_group_7"   
#> [113] "ETN_network_project_group_8"    "ETN_network_project_group_9"   
#> [115] "EUTN"                           "FarmTrack_network"             
#> [117] "Finescale_Helgoland"            "Fish_Mig_Wad_Sea"              
#> [119] "FISHINTEL"                      "FISHINTEL_aquaculture"         
#> [121] "FISHOWF"                        "FISHOWF+"                      
#> [123] "FISP"                           "Foyle_Catchment"               
#> [125] "Friesland"                      "GEPESCART2_ARRAY"              
#> [127] "GIBRALTRACK_pilot"              "Grotenete"                     
#> [129] "GTN"                            "Gudena_network"                
#> [131] "GuitarProtect_array"            "Haringvliet2023-2026"          
#> [133] "Hevring_Trout_Denmark"          "HinkleyFineScaleArray2025"     
#> [135] "HinkleyFineScaleArray2026"      "HR2_3D_tracking_eel_reservoir" 
#> [137] "IBASS"                          "ICOD_receiver_array"           
#> [139] "IG_II_Fish_Pass"                "IG_Waves"                      
#> [141] "Iller_VPS"                      "IMR_OWF"                       
#> [143] "Inforbiomares"                  "Inner_Foyle"                   
#> [145] "IOA"                            "Jersey_Coastal"                
#> [147] "JJ_Belwind"                     "JSATS-PalmaBay-2019"           
#> [149] "Kattegat_Islands"               "KBTN"                          
#> [151] "KERG"                           "KiBiAN"                        
#> [153] "kornwerderzand"                 "Lake_Anundsjo_VPS"             
#> [155] "LamTre20_21"                    "LamYorOus18-20"                
#> [157] "lauwersmeer"                    "LBSSM"                         
#> [159] "leopold"                        "LESPUR"                        
#> [161] "life4fish"                      "lifewatch"                     
#> [163] "Lifewatch_additional_stations"  "Lifewatch_performance_test"    
#> [165] "Limfjord"                       "LionFishMED"                   
#> [167] "LSTSTJ_MPA"                     "MacFish"                       
#> [169] "Mangar-Keban"                   "Mapping_Algarve_Sharks"        
#> [171] "Marble_rainbow_trout"           "mare_wind_finescale"           
#> [173] "MariagerFjord_network"          "MBA_Massmo"                    
#> [175] "MBA_Wavehub"                    "MBA_Whitsand"                  
#> [177] "Mecklenburg_fish_movements"     "mepnsw_network"                
#> [179] "MERMOZ_ARRAY"                   "MI_ClewBay_Achill_network"     
#> [181] "MIGRATOEBRE"                    "MMERMAID"                      
#> [183] "MOBEIA"                         "Mobula_IMAR"                   
#> [185] "MOPP"                           "MorayFirth"                    
#> [187] "MOVE_CCMAR_NETWORK"             "mrc_vliz"                      
#> [189] "NARVAEEL"                       "NETFISH_ARRAY"                 
#> [191] "no_info"                        "none"                          
#> [193] "Noordzeekanaal"                 "North_sea_wrecks"              
#> [195] "Northern_Norfolk_Broads"        "NTNU-Gaulosen"                 
#> [197] "OP-Test"                        "Orbetello_lagoon_array"        
#> [199] "Orstedcod"                      "OTN_UPLOAD"                    
#> [201] "OTN-Hemnfjorden"                "OTN-Skjerstadfjorden"          
#> [203] "OTN-Tosenfjorden"               "Outer_Foyle"                   
#> [205] "paintedcomber"                  "pc4c"                          
#> [207] "PelFish"                        "PhD_Barbara_Koeck"             
#> [209] "PhD_Jeremy_Pastor"              "PhD_Marrocco"                  
#> [211] "PhD_Nolan"                      "PhD_Parcerisas"                
#> [213] "PhysFish"                       "porbeagle_tracking_network"    
#> [215] "PrePARED"                       "PTN_ATLAZUL"                   
#> [217] "PTN_MEROSW2021"                 "PTN_MIGRACORV"                 
#> [219] "PTN_PROTECT2012"                "PTN_PROTECT2013"               
#> [221] "PTN-MARSW"                      "PTN-Silver-eel-Mondego"        
#> [223] "PureWind_fish_detectors"        "RAJIBAL-COFIB"                 
#> [225] "RATJADA"                        "RBVV2"                         
#> [227] "RECCRU_array"                   "Reelease"                      
#> [229] "RESBIO"                         "ResMed"                        
#> [231] "river_severn_array"             "River_Usk"                     
#> [233] "RNP"                            "rt2020_zeeschelde"             
#> [235] "RTT"                            "Running_eel"                   
#> [237] "saeftinghe"                     "Salmo_Migration_NSIC"          
#> [239] "Salmon_Eastern_Greenland"       "SAMARCH"                       
#> [241] "SARTELARAM"                     "SARTELTG"                      
#> [243] "SARTELZINGARO"                  "SCHUFI"                        
#> [245] "Scytrack"                       "SeaMonitor"                    
#> [247] "SEAMONITOR_ARRAY"               "SEM_array"                     
#> [249] "SEMP"                           "severn_multi_species_network"  
#> [251] "SGB"                            "Shark_Levant_tracking"         
#> [253] "SIARC_ARRAY"                    "Siganid_East_Med"              
#> [255] "Siganid_Gulf_Aqaba"             "Skagerrak-NorthSea-array"      
#> [257] "SkagNor"                        "Skye"                          
#> [259] "SMAFBI"                         "SmartBay_array"                
#> [261] "SMLA"                           "SMOLTRACK-I-Engeland"          
#> [263] "SMOLTRACK-II-Engeland"          "SMUOG"                         
#> [265] "SPAWNSEIS"                      "SPICARA_network"               
#> [267] "SPIDER_GNB_array"               "SrivAqab"                      
#> [269] "SrivEMed"                       "ST08SWE"                       
#> [271] "STRAITS_GIBRALTAR_ARRAY"        "STRAITS_TSTN"                  
#> [273] "Sturgeon_reintroduction_array"  "sturgeonSK"                    
#> [275] "STURNETGEBZE_ARRAY"             "SU.MO.ELASMO.Adriatic"         
#> [277] "SUBSEA_S3"                      "Sudle_IMPULS"                  
#> [279] "Sudle_INNOV"                    "super_smolts_array"            
#> [281] "SUPERSAT"                       "SVALBARD_NICE_ARRAY"           
#> [283] "SVNL-FISH-WATCH"                "SW_Oude_Ijssel"                
#> [285] "SWIMWAY_2021"                   "Swimway_vechte"                
#> [287] "Swiss_AcTel"                    "SWRL_array"                    
#> [289] "TelePomiMer_array"              "TelMarsw"                      
#> [291] "TeRi"                           "testvr2ar"                     
#> [293] "thornton"                       "TRACE_network"                 
#> [295] "Trout_movement_Skye_2021-2023"  "TurkishMEDTrack"               
#> [297] "TurkishTunaTrack"               "UseIT_BlueCrab_Tracking_array" 
#> [299] "UtS"                            "V2LBEIAR"                      
#> [301] "V2LCASP"                        "V2LCHASES"                     
#> [303] "V2LFALK"                        "V2LGOL"                        
#> [305] "V2LIMFSTP"                      "V2LLIMS"                       
#> [307] "V2LNR"                          "V2LSMQUB"                      
#> [309] "V2LWATCH"                       "VFM_BP"                        
#> [311] "VFM_Braviken"                   "VFM_DSTL"                      
#> [313] "VFM_GoB"                        "VFM_Hjalmaren"                 
#> [315] "VFM_Malaren"                    "VFM_RG"                        
#> [317] "VFM_Siljan"                     "VFM_Vattern"                   
#> [319] "VFM_WCC"                        "VFMLNU_Blekinge"               
#> [321] "VFMLNU_Osby_network"            "VLIZ_SANDEEL"                  
#> [323] "VMLSMMI"                        "VMLSOCBS"                      
#> [325] "VVV"                            "Walloneel"                     
#> [327] "WCTP_array"                     "Winde_Tjeukemeer"              
#> [329] "ws1"                            "ws2"                           
#> [331] "ws3"                            "Z001"                          
#> [333] "zeeschelde"                     "ZRM_network"                   
```
