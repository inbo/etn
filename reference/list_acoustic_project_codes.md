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
#>  [19] "2024-2031_Northsea_Ecowende"    "2025_IJmuidenRotterdam_array"  
#>  [21] "2025_langsdammen_array"         "2025_Nederrijn_Lek_array"      
#>  [23] "2025-2026_RijnWest_array"       "2025-28_NorthSeaNL_MONS_array" 
#>  [25] "2026_PhD_Visser_network"        "Aberdeen"                      
#>  [27] "albert"                         "Albertkanaal_VPS_Ham"          
#>  [29] "Albertkanaal_VPS_Hasselt"       "Apelafico"                     
#>  [31] "ARAISOLA02"                     "ARAISOLA03"                    
#>  [33] "Ars"                            "Artevigo"                      
#>  [35] "ASMOP1"                         "ASMOP2"                        
#>  [37] "AZO"                            "BALANCE"                       
#>  [39] "Baltic_Sturgeon_Restoration"    "BECORV"                        
#>  [41] "BlueCrab2022Algarve"            "BOATS_network"                 
#>  [43] "Bodden_Pike"                    "BOOGMR"                        
#>  [45] "BOOPAP"                         "BOOPIRATA"                     
#>  [47] "BOORAMA"                        "BOOSBI"                        
#>  [49] "bpns"                           "Brasem_IJM/MM"                 
#>  [51] "BristolChannelArray"            "BSTN"                          
#>  [53] "BTN"                            "BTN_LOST_ARRAY"                
#>  [55] "BTN-DeepWater-IMEDEA"           "BTN-IMEDEA"                    
#>  [57] "CANAPE"                         "Carlingford"                   
#>  [59] "CESB_network"                   "CMAX_Hebrides"                 
#>  [61] "COD_OG_DK_2023"                 "COD_OWF"                       
#>  [63] "Cod-connectivity"               "CODEVCO_fish_detectors"        
#>  [65] "COLAGANG"                       "CONNECT-MED"                   
#>  [67] "Conon"                          "COREMAR"                       
#>  [69] "CORYTRACK"                      "cpodnetwork"                   
#>  [71] "Crab_behavior_aquaculture_Norw" "Csapidus_Southern_France"      
#>  [73] "CTN"                            "DAbecasis_PhD"                 
#>  [75] "DAERA_Elasmobranch_Network"     "DAK"                           
#>  [77] "Danish_southeastern_strait"     "Danish_Straits"                
#>  [79] "Danube_Sturgeons"               "DEHINC.HABI.GUACETO"           
#>  [81] "Delfzijl"                       "demer"                         
#>  [83] "Deveron"                        "dijle"                         
#>  [85] "Dijle_VPS"                      "DSM"                           
#>  [87] "DTU-Skjern"                     "DuskMaro"                      
#>  [89] "EBAMAR_array"                   "Eel_migration_Test_2023"       
#>  [91] "Eel-source-to-sea"              "eemskanaal_I"                  
#>  [93] "eemskanaal_II"                  "eemskanaal_III"                
#>  [95] "EMFish_test"                    "EMMN"                          
#>  [97] "ESGL"                           "ETN_network_project_group_1"   
#>  [99] "ETN_network_project_group_2"    "ETN_network_project_group_3"   
#> [101] "ETN_network_project_group_4"    "ETN_network_project_group_5"   
#> [103] "ETN_network_project_group_6"    "ETN_network_project_group_7"   
#> [105] "ETN_network_project_group_8"    "ETN_network_project_group_9"   
#> [107] "EUTN"                           "FarmTrack"                     
#> [109] "Finescale_Helgoland"            "Fish_Mig_Wad_Sea"              
#> [111] "FISHINTEL"                      "FISHOWF"                       
#> [113] "FISHOWF+"                       "FISP"                          
#> [115] "Foyle_Catchment"                "Friesland"                     
#> [117] "GEPESCART2_ARRAY"               "GIBRALTAR_STRAITS_COASTAL"     
#> [119] "GIBRALTAR_STRAITS_CURTAIN"      "GIBRALTRACK_pilot"             
#> [121] "Grotenete"                      "GTN"                           
#> [123] "Gudena_network"                 "GuitarProject_array"           
#> [125] "Haringvliet2023-2026"           "Hevring_Trout_Denmark"         
#> [127] "HinkleyFineScaleArray2025"      "HinkleyFineScaleArray2026"     
#> [129] "HR2_3D_tracking_eel_reservoir"  "IBASS"                         
#> [131] "ICOD_receiver_array"            "IG_II_Fish_Pass"               
#> [133] "IG_Waves"                       "Iller_VPS"                     
#> [135] "IMR_OWF"                        "Inforbiomares"                 
#> [137] "Inner_Foyle"                    "IOA"                           
#> [139] "Jersey_Coastal"                 "JJ_Belwind"                    
#> [141] "JSATS-PalmaBay-2019"            "Kattegat_Islands"              
#> [143] "KBTN"                           "KERG"                          
#> [145] "KiBiAN"                         "kornwerderzand"                
#> [147] "Lake_Anundsjo_VPS"              "LamTre20/21"                   
#> [149] "LamYorOus18-20"                 "lauwersmeer"                   
#> [151] "LBSSM"                          "leopold"                       
#> [153] "LESPUR"                         "life4fish"                     
#> [155] "lifewatch"                      "Limfjord"                      
#> [157] "LionFishMED"                    "LSTSTJ_MPA"                    
#> [159] "MacFish"                        "Mangar-Keban"                  
#> [161] "Mapping_Algarve_Sharks"         "Marble_rainbow_trout"          
#> [163] "MariagerFjord_network"          "MBA_Massmo"                    
#> [165] "MBA_Wavehub"                    "MBA_Whitsand"                  
#> [167] "Mecklenburg_fish_movements"     "mepnsw_network"                
#> [169] "MERMOZ_ARRAY"                   "MI_ClewBay_Achill_network"     
#> [171] "MIGRATOEBRE"                    "MMERMAID"                      
#> [173] "MOBEIA"                         "Mobula_IMAR"                   
#> [175] "MOPP"                           "MorayFirth"                    
#> [177] "MOVE_CCMAR_NETWORK"             "mrc_vliz"                      
#> [179] "NARVAEEL"                       "NETFISH_ARRAY"                 
#> [181] "no_info"                        "none"                          
#> [183] "Noordzeekanaal"                 "North_sea_wrecks"              
#> [185] "Northern_Norfolk_Broads"        "NTNU-Gaulosen"                 
#> [187] "OP-Test"                        "Orbetello_lagoon_array"        
#> [189] "Orstedcod"                      "OTN_UPLOAD"                    
#> [191] "OTN-Hemnfjorden"                "OTN-Skjerstadfjorden"          
#> [193] "OTN-Tosenfjorden"               "Outer_Foyle"                   
#> [195] "paintedcomber"                  "pc4c"                          
#> [197] "PelFish"                        "PhD_Barbara_Koeck"             
#> [199] "PhD_Jeremy_Pastor"              "PhD_Marrocco"                  
#> [201] "PhD_Nolan"                      "PhD_Parcerisas"                
#> [203] "PhysFish"                       "porbeagle_tracking_network"    
#> [205] "PrePARED"                       "PTN-MARSW"                     
#> [207] "PTN-Silver-eel-Mondego"         "PTN/ATLAZUL"                   
#> [209] "PTN/MEROSW2021"                 "PTN/MIGRACORV"                 
#> [211] "PTN/PROTECT2012"                "PTN/PROTECT2013"               
#> [213] "PureWind_fish_detectors"        "RAJIBAL-COFIB"                 
#> [215] "RATJADA"                        "RBVV2"                         
#> [217] "RECCRU_array"                   "Reelease"                      
#> [219] "RESBIO"                         "ResMed"                        
#> [221] "River_Usk"                      "RNP"                           
#> [223] "rt2020_zeeschelde"              "RTT"                           
#> [225] "Running_eel"                    "saeftinghe"                    
#> [227] "Salmo_Migration_NSIC"           "Salmon_Eastern_Greenland"      
#> [229] "SAMARCH"                        "SARTELARAM"                    
#> [231] "SARTELTG"                       "SARTELZINGARO"                 
#> [233] "SCHUFI"                         "Scytrack"                      
#> [235] "SeaMonitor"                     "SEAMONITOR_ARRAY"              
#> [237] "SEM_array"                      "SEMP"                          
#> [239] "SGB"                            "Shark_Levant_tracking"         
#> [241] "SIARC_ARRAY"                    "Siganid_East_Med"              
#> [243] "Siganid_Gulf_Aqaba"             "Skagerrak-NorthSea-array"      
#> [245] "SkagNor"                        "Skye"                          
#> [247] "SMAFBI"                         "SmartBay_array"                
#> [249] "SMLA"                           "SMOLTRACK-I-Engeland"          
#> [251] "SMOLTRACK-II-Engeland"          "SMUOG"                         
#> [253] "SPAWNSEIS"                      "SPICARA_network"               
#> [255] "SPIDER_GNB_array"               "SrivAqab"                      
#> [257] "SrivEMed"                       "ST08SWE"                       
#> [259] "STRAITS_GIBRALTAR_ARRAY"        "STRAITS_TSTN"                  
#> [261] "Sturgeon_reintroduction_array"  "sturgeonSK"                    
#> [263] "SU.MO.ELASMO.Adriatic"          "Sudle_IMPULS"                  
#> [265] "Sudle_INNOV"                    "SUPERSAT"                      
#> [267] "SVNL-FISH-WATCH"                "SW_Oude_Ijssel"                
#> [269] "SWIMWAY_2021"                   "Swimway_vechte"                
#> [271] "Swiss_AcTel"                    "SWRL_array"                    
#> [273] "TelePomiMer_array"              "TelMarsw"                      
#> [275] "TeRi"                           "testvr2ar"                     
#> [277] "thornton"                       "TRACE_network"                 
#> [279] "Trout_movement_Skye_2021-2023"  "TurkishMEDTrack"               
#> [281] "TurkishTunaTrack"               "UseIT_BlueCrab_Tracking_array" 
#> [283] "UtS"                            "V2LBEIAR"                      
#> [285] "V2LCASP"                        "V2LCHASES"                     
#> [287] "V2LFALK"                        "V2LGOL"                        
#> [289] "V2LIMFSTP"                      "V2LLIMS"                       
#> [291] "V2LNR"                          "V2LSMQUB"                      
#> [293] "V2LWATCH"                       "VFM_BP"                        
#> [295] "VFM_Braviken"                   "VFM_DSTL"                      
#> [297] "VFM_GoB"                        "VFM_Hjalmaren"                 
#> [299] "VFM_Malaren"                    "VFM_RG"                        
#> [301] "VFM_Siljan"                     "VFM_Vattern"                   
#> [303] "VFM_WCC"                        "VFMLNU_Blekinge"               
#> [305] "VFMLNU_Osby_network"            "VMLSMMI"                       
#> [307] "VMLSOCBS"                       "VVV"                           
#> [309] "Walloneel"                      "WCTP_array"                    
#> [311] "Winde_Tjeukemeer"               "ws1"                           
#> [313] "ws2"                            "ws3"                           
#> [315] "Z001"                           "zeeschelde"                    
#> [317] "ZRM_network"                   
```
