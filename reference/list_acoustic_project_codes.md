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
#>  [27] "2026_InnerTrdFjord"             "2026_PhD_Visser_network"       
#>  [29] "2026-7_Solent_Seascape"         "aagone_study_aude_network"     
#>  [31] "Aberdeen"                       "albert"                        
#>  [33] "Albertkanaal_VPS_Ham"           "Albertkanaal_VPS_Hasselt"      
#>  [35] "Allis_shad_migration_Oise_2024" "Apelafico"                     
#>  [37] "ARAISOLA02"                     "ARAISOLA03"                    
#>  [39] "Ars"                            "Artevigo"                      
#>  [41] "ASMOP1"                         "ASMOP2"                        
#>  [43] "AZO"                            "BALANCE"                       
#>  [45] "Baltic_Sturgeon_Restoration"    "BECORV"                        
#>  [47] "BIT_array"                      "Blueconnect"                   
#>  [49] "BlueCrab2022Algarve"            "Bodden_Pike"                   
#>  [51] "BOOGMR"                         "BOOPAP"                        
#>  [53] "BOOPIRATA"                      "BOORAMA"                       
#>  [55] "BOOSBI"                         "bpns"                          
#>  [57] "Brasem_IJM_MM"                  "BristolChannelArray"           
#>  [59] "BSTN"                           "BTN"                           
#>  [61] "BTN_BOATS_network"              "BTN_LOST_ARRAY"                
#>  [63] "BTN-DeepWater-IMEDEA"           "BTN-IMEDEA"                    
#>  [65] "CANAPE"                         "Carlingford"                   
#>  [67] "CESB_network"                   "CMAX_Hebrides"                 
#>  [69] "COD_OG_DK_2023"                 "COD_OWF"                       
#>  [71] "Cod-connectivity"               "CODEVCO_fish_detectors"        
#>  [73] "COLAGANG"                       "CONNECT-MED"                   
#>  [75] "Conon"                          "COREMAR"                       
#>  [77] "CORYTRACK"                      "cpodnetwork"                   
#>  [79] "Crab_behavior_aquaculture_Norw" "Csapidus_Southern_France"      
#>  [81] "CTN"                            "DAbecasis_PhD"                 
#>  [83] "DAERA_Elasmobranch_Network"     "DAK"                           
#>  [85] "Danish_southeastern_strait"     "Danish_Straits"                
#>  [87] "Danube_Sturgeons"               "DEHINC.HABI.GUACETO"           
#>  [89] "Delfzijl"                       "demer"                         
#>  [91] "Deveron"                        "dijle"                         
#>  [93] "Dijle_VPS"                      "DSM"                           
#>  [95] "DTU-Skjern"                     "DuskMaro"                      
#>  [97] "EBAMAR"                         "Eel_HighRhine_26-29_array"     
#>  [99] "Eel_migration_Test_2023"        "Eel-source-to-sea"             
#> [101] "eemskanaal_I"                   "eemskanaal_II"                 
#> [103] "eemskanaal_III"                 "EMFish_test"                   
#> [105] "EMMN"                           "ESGL"                          
#> [107] "ETN_network_project_group_1"    "ETN_network_project_group_2"   
#> [109] "ETN_network_project_group_3"    "ETN_network_project_group_4"   
#> [111] "ETN_network_project_group_5"    "ETN_network_project_group_6"   
#> [113] "ETN_network_project_group_7"    "ETN_network_project_group_8"   
#> [115] "ETN_network_project_group_9"    "EUTN"                          
#> [117] "FarmTrack_network"              "Finescale_Helgoland"           
#> [119] "Fish_Mig_Wad_Sea"               "FISHINTEL"                     
#> [121] "FISHINTEL_aquaculture"          "FISHOWF"                       
#> [123] "FISHOWF+"                       "FISP"                          
#> [125] "Foyle_Catchment"                "Friesland"                     
#> [127] "GEPESCART2_ARRAY"               "GIBRALTRACK_pilot"             
#> [129] "Grotenete"                      "GTN"                           
#> [131] "Gudena_network"                 "GuitarProtect_array"           
#> [133] "Haringvliet2023-2026"           "Hevring_Trout_Denmark"         
#> [135] "HinkleyFineScaleArray2025"      "HinkleyFineScaleArray2026"     
#> [137] "HR2_3D_tracking_eel_reservoir"  "IBASS"                         
#> [139] "ICOD_receiver_array"            "IG_II_Fish_Pass"               
#> [141] "IG_Waves"                       "Iller_VPS"                     
#> [143] "IMR_OWF"                        "Inforbiomares"                 
#> [145] "Inner_Foyle"                    "IOA"                           
#> [147] "Jersey_Coastal"                 "JJ_Belwind"                    
#> [149] "JSATS-PalmaBay-2019"            "Kattegat_Islands"              
#> [151] "KBTN"                           "KERG"                          
#> [153] "KiBiAN"                         "kornwerderzand"                
#> [155] "Lake_Anundsjo_VPS"              "LamTre20_21"                   
#> [157] "LamYorOus18-20"                 "lauwersmeer"                   
#> [159] "LBSSM"                          "leopold"                       
#> [161] "LESPUR"                         "life4fish"                     
#> [163] "lifewatch"                      "Lifewatch_additional_stations" 
#> [165] "Lifewatch_performance_test"     "Limfjord"                      
#> [167] "LionFishMED"                    "LSTSTJ_MPA"                    
#> [169] "MacFish"                        "Mangar-Keban"                  
#> [171] "Mapping_Algarve_Sharks"         "Marble_rainbow_trout"          
#> [173] "mare_wind_finescale"            "MariagerFjord_network"         
#> [175] "MBA_Massmo"                     "MBA_Wavehub"                   
#> [177] "MBA_Whitsand"                   "Mecklenburg_fish_movements"    
#> [179] "mepnsw_network"                 "MERMOZ_ARRAY"                  
#> [181] "MI_ClewBay_Achill_network"      "MIGRATOEBRE"                   
#> [183] "MMERMAID"                       "MOBEIA"                        
#> [185] "Mobula_IMAR"                    "MOPP"                          
#> [187] "MorayFirth"                     "MOVE_CCMAR_NETWORK"            
#> [189] "mrc_vliz"                       "NARVAEEL"                      
#> [191] "NETFISH_ARRAY"                  "no_info"                       
#> [193] "none"                           "Noordzeekanaal"                
#> [195] "North_sea_wrecks"               "Northern_Norfolk_Broads"       
#> [197] "NTNU-Gaulosen"                  "OP-Test"                       
#> [199] "Orbetello_lagoon_array"         "Orstedcod"                     
#> [201] "OTN_UPLOAD"                     "OTN-Hemnfjorden"               
#> [203] "OTN-Skjerstadfjorden"           "OTN-Tosenfjorden"              
#> [205] "Outer_Foyle"                    "paintedcomber"                 
#> [207] "pc4c"                           "PelFish"                       
#> [209] "PhD_Barbara_Koeck"              "PhD_Jeremy_Pastor"             
#> [211] "PhD_Marrocco"                   "PhD_Nolan"                     
#> [213] "PhD_Parcerisas"                 "PhysFish"                      
#> [215] "porbeagle_tracking_network"     "PrePARED"                      
#> [217] "PTN_ATLAZUL"                    "PTN_MEROSW2021"                
#> [219] "PTN_MIGRACORV"                  "PTN_PROTECT2012"               
#> [221] "PTN_PROTECT2013"                "PTN-MARSW"                     
#> [223] "PTN-Silver-eel-Mondego"         "PureWind_fish_detectors"       
#> [225] "RAJIBAL-COFIB"                  "RATJADA"                       
#> [227] "RBVV2"                          "RECCRU_array"                  
#> [229] "Reelease"                       "RESBIO"                        
#> [231] "ResMed"                         "river_severn_array"            
#> [233] "River_Usk"                      "RNP"                           
#> [235] "rt2020_zeeschelde"              "RTT"                           
#> [237] "Running_eel"                    "saeftinghe"                    
#> [239] "Salmo_Migration_NSIC"           "Salmon_Eastern_Greenland"      
#> [241] "SAMARCH"                        "SARTELARAM"                    
#> [243] "SARTELTG"                       "SARTELZINGARO"                 
#> [245] "SCHUFI"                         "Scytrack"                      
#> [247] "SeaMonitor"                     "SEAMONITOR_ARRAY"              
#> [249] "SEM_array"                      "SEMP"                          
#> [251] "severn_multi_species_network"   "SGB"                           
#> [253] "Shark_Levant_tracking"          "SIARC_ARRAY"                   
#> [255] "Siganid_East_Med"               "Siganid_Gulf_Aqaba"            
#> [257] "Skagerrak-NorthSea-array"       "SkagNor"                       
#> [259] "Skye"                           "SMAFBI"                        
#> [261] "SmartBay_array"                 "SMLA"                          
#> [263] "SMOLTRACK-I-Engeland"           "SMOLTRACK-II-Engeland"         
#> [265] "SMUOG"                          "SPAWNSEIS"                     
#> [267] "SPICARA_network"                "SPIDER_GNB_array"              
#> [269] "SrivAqab"                       "SrivEMed"                      
#> [271] "ST08SWE"                        "STRAITS_GIBRALTAR_ARRAY"       
#> [273] "STRAITS_TSTN"                   "Sturgeon_reintroduction_array" 
#> [275] "sturgeonSK"                     "STURNETGEBZE_ARRAY"            
#> [277] "SU.MO.ELASMO.Adriatic"          "SUBSEA_S3"                     
#> [279] "Sudle_IMPULS"                   "Sudle_INNOV"                   
#> [281] "super_smolts_array"             "SUPERSAT"                      
#> [283] "SVALBARD_NICE_ARRAY"            "SVNL-FISH-WATCH"               
#> [285] "SW_Oude_Ijssel"                 "SWIMWAY_2021"                  
#> [287] "Swimway_vechte"                 "Swiss_AcTel"                   
#> [289] "SWRL_array"                     "TelePomiMer_array"             
#> [291] "TelMarsw"                       "TeRi"                          
#> [293] "testvr2ar"                      "thornton"                      
#> [295] "TRACE_network"                  "Trout_movement_Skye_2021-2023" 
#> [297] "TurkishMEDTrack"                "TurkishTunaTrack"              
#> [299] "UseIT_BlueCrab_Tracking_array"  "UtS"                           
#> [301] "V2LBEIAR"                       "V2LCASP"                       
#> [303] "V2LCHASES"                      "V2LFALK"                       
#> [305] "V2LGOL"                         "V2LIMFSTP"                     
#> [307] "V2LLIMS"                        "V2LNR"                         
#> [309] "V2LSMQUB"                       "V2LWATCH"                      
#> [311] "VFM_BP"                         "VFM_Braviken"                  
#> [313] "VFM_DSTL"                       "VFM_GoB"                       
#> [315] "VFM_Hjalmaren"                  "VFM_Malaren"                   
#> [317] "VFM_RG"                         "VFM_Siljan"                    
#> [319] "VFM_Vattern"                    "VFM_WCC"                       
#> [321] "VFMLNU_Blekinge"                "VFMLNU_Osby_network"           
#> [323] "VLIZ_SANDEEL"                   "VMLSMMI"                       
#> [325] "VMLSOCBS"                       "VVV"                           
#> [327] "Walloneel"                      "WCTP_array"                    
#> [329] "Winde_Tjeukemeer"               "ws1"                           
#> [331] "ws2"                            "ws3"                           
#> [333] "Z001"                           "zeeschelde"                    
#> [335] "ZRM_network"                   
```
