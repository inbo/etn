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
#>  [29] "Albertkanaal_VPS_Hasselt"       "Allis_shad_migration_Oise_2024"
#>  [31] "Apelafico"                      "ARAISOLA02"                    
#>  [33] "ARAISOLA03"                     "Ars"                           
#>  [35] "Artevigo"                       "ASMOP1"                        
#>  [37] "ASMOP2"                         "AZO"                           
#>  [39] "BALANCE"                        "Baltic_Sturgeon_Restoration"   
#>  [41] "BECORV"                         "BIT_array"                     
#>  [43] "BlueCrab2022Algarve"            "BOATS_network"                 
#>  [45] "Bodden_Pike"                    "BOOGMR"                        
#>  [47] "BOOPAP"                         "BOOPIRATA"                     
#>  [49] "BOORAMA"                        "BOOSBI"                        
#>  [51] "bpns"                           "Brasem_IJM/MM"                 
#>  [53] "BristolChannelArray"            "BSTN"                          
#>  [55] "BTN"                            "BTN_LOST_ARRAY"                
#>  [57] "BTN-DeepWater-IMEDEA"           "BTN-IMEDEA"                    
#>  [59] "CANAPE"                         "Carlingford"                   
#>  [61] "CESB_network"                   "CMAX_Hebrides"                 
#>  [63] "COD_OG_DK_2023"                 "COD_OWF"                       
#>  [65] "Cod-connectivity"               "CODEVCO_fish_detectors"        
#>  [67] "COLAGANG"                       "CONNECT-MED"                   
#>  [69] "Conon"                          "COREMAR"                       
#>  [71] "CORYTRACK"                      "cpodnetwork"                   
#>  [73] "Crab_behavior_aquaculture_Norw" "Csapidus_Southern_France"      
#>  [75] "CTN"                            "DAbecasis_PhD"                 
#>  [77] "DAERA_Elasmobranch_Network"     "DAK"                           
#>  [79] "Danish_southeastern_strait"     "Danish_Straits"                
#>  [81] "Danube_Sturgeons"               "DEHINC.HABI.GUACETO"           
#>  [83] "Delfzijl"                       "demer"                         
#>  [85] "Deveron"                        "dijle"                         
#>  [87] "Dijle_VPS"                      "DSM"                           
#>  [89] "DTU-Skjern"                     "DuskMaro"                      
#>  [91] "EBAMAR_array"                   "Eel_migration_Test_2023"       
#>  [93] "Eel-source-to-sea"              "eemskanaal_I"                  
#>  [95] "eemskanaal_II"                  "eemskanaal_III"                
#>  [97] "EMFish_test"                    "EMMN"                          
#>  [99] "ESGL"                           "ETN_network_project_group_1"   
#> [101] "ETN_network_project_group_2"    "ETN_network_project_group_3"   
#> [103] "ETN_network_project_group_4"    "ETN_network_project_group_5"   
#> [105] "ETN_network_project_group_6"    "ETN_network_project_group_7"   
#> [107] "ETN_network_project_group_8"    "ETN_network_project_group_9"   
#> [109] "EUTN"                           "FarmTrack"                     
#> [111] "Finescale_Helgoland"            "Fish_Mig_Wad_Sea"              
#> [113] "FISHINTEL"                      "FISHOWF"                       
#> [115] "FISHOWF+"                       "FISP"                          
#> [117] "Foyle_Catchment"                "Friesland"                     
#> [119] "GEPESCART2_ARRAY"               "GIBRALTAR_STRAITS_COASTAL"     
#> [121] "GIBRALTAR_STRAITS_CURTAIN"      "GIBRALTRACK_pilot"             
#> [123] "Grotenete"                      "GTN"                           
#> [125] "Gudena_network"                 "GuitarProject_array"           
#> [127] "Haringvliet2023-2026"           "Hevring_Trout_Denmark"         
#> [129] "HinkleyFineScaleArray2025"      "HinkleyFineScaleArray2026"     
#> [131] "HR2_3D_tracking_eel_reservoir"  "IBASS"                         
#> [133] "ICOD_receiver_array"            "IG_II_Fish_Pass"               
#> [135] "IG_Waves"                       "Iller_VPS"                     
#> [137] "IMR_OWF"                        "Inforbiomares"                 
#> [139] "Inner_Foyle"                    "IOA"                           
#> [141] "Jersey_Coastal"                 "JJ_Belwind"                    
#> [143] "JSATS-PalmaBay-2019"            "Kattegat_Islands"              
#> [145] "KBTN"                           "KERG"                          
#> [147] "KiBiAN"                         "kornwerderzand"                
#> [149] "Lake_Anundsjo_VPS"              "LamTre20/21"                   
#> [151] "LamYorOus18-20"                 "lauwersmeer"                   
#> [153] "LBSSM"                          "leopold"                       
#> [155] "LESPUR"                         "life4fish"                     
#> [157] "lifewatch"                      "Limfjord"                      
#> [159] "LionFishMED"                    "LSTSTJ_MPA"                    
#> [161] "MacFish"                        "Mangar-Keban"                  
#> [163] "Mapping_Algarve_Sharks"         "Marble_rainbow_trout"          
#> [165] "MariagerFjord_network"          "MBA_Massmo"                    
#> [167] "MBA_Wavehub"                    "MBA_Whitsand"                  
#> [169] "Mecklenburg_fish_movements"     "mepnsw_network"                
#> [171] "MERMOZ_ARRAY"                   "MI_ClewBay_Achill_network"     
#> [173] "MIGRATOEBRE"                    "MMERMAID"                      
#> [175] "MOBEIA"                         "Mobula_IMAR"                   
#> [177] "MOPP"                           "MorayFirth"                    
#> [179] "MOVE_CCMAR_NETWORK"             "mrc_vliz"                      
#> [181] "NARVAEEL"                       "NETFISH_ARRAY"                 
#> [183] "no_info"                        "none"                          
#> [185] "Noordzeekanaal"                 "North_sea_wrecks"              
#> [187] "Northern_Norfolk_Broads"        "NTNU-Gaulosen"                 
#> [189] "OP-Test"                        "Orbetello_lagoon_array"        
#> [191] "Orstedcod"                      "OTN_UPLOAD"                    
#> [193] "OTN-Hemnfjorden"                "OTN-Skjerstadfjorden"          
#> [195] "OTN-Tosenfjorden"               "Outer_Foyle"                   
#> [197] "paintedcomber"                  "pc4c"                          
#> [199] "PelFish"                        "PhD_Barbara_Koeck"             
#> [201] "PhD_Jeremy_Pastor"              "PhD_Marrocco"                  
#> [203] "PhD_Nolan"                      "PhD_Parcerisas"                
#> [205] "PhysFish"                       "porbeagle_tracking_network"    
#> [207] "PrePARED"                       "PTN-MARSW"                     
#> [209] "PTN-Silver-eel-Mondego"         "PTN/ATLAZUL"                   
#> [211] "PTN/MEROSW2021"                 "PTN/MIGRACORV"                 
#> [213] "PTN/PROTECT2012"                "PTN/PROTECT2013"               
#> [215] "PureWind_fish_detectors"        "RAJIBAL-COFIB"                 
#> [217] "RATJADA"                        "RBVV2"                         
#> [219] "RECCRU_array"                   "Reelease"                      
#> [221] "RESBIO"                         "ResMed"                        
#> [223] "River_Usk"                      "RNP"                           
#> [225] "rt2020_zeeschelde"              "RTT"                           
#> [227] "Running_eel"                    "saeftinghe"                    
#> [229] "Salmo_Migration_NSIC"           "Salmon_Eastern_Greenland"      
#> [231] "SAMARCH"                        "SARTELARAM"                    
#> [233] "SARTELTG"                       "SARTELZINGARO"                 
#> [235] "SCHUFI"                         "Scytrack"                      
#> [237] "SeaMonitor"                     "SEAMONITOR_ARRAY"              
#> [239] "SEM_array"                      "SEMP"                          
#> [241] "SGB"                            "Shark_Levant_tracking"         
#> [243] "SIARC_ARRAY"                    "Siganid_East_Med"              
#> [245] "Siganid_Gulf_Aqaba"             "Skagerrak-NorthSea-array"      
#> [247] "SkagNor"                        "Skye"                          
#> [249] "SMAFBI"                         "SmartBay_array"                
#> [251] "SMLA"                           "SMOLTRACK-I-Engeland"          
#> [253] "SMOLTRACK-II-Engeland"          "SMUOG"                         
#> [255] "SPAWNSEIS"                      "SPICARA_network"               
#> [257] "SPIDER_GNB_array"               "SrivAqab"                      
#> [259] "SrivEMed"                       "ST08SWE"                       
#> [261] "STRAITS_GIBRALTAR_ARRAY"        "STRAITS_TSTN"                  
#> [263] "Sturgeon_reintroduction_array"  "sturgeonSK"                    
#> [265] "SU.MO.ELASMO.Adriatic"          "Sudle_IMPULS"                  
#> [267] "Sudle_INNOV"                    "super_smolts_array"            
#> [269] "SUPERSAT"                       "SVNL-FISH-WATCH"               
#> [271] "SW_Oude_Ijssel"                 "SWIMWAY_2021"                  
#> [273] "Swimway_vechte"                 "Swiss_AcTel"                   
#> [275] "SWRL_array"                     "TelePomiMer_array"             
#> [277] "TelMarsw"                       "TeRi"                          
#> [279] "testvr2ar"                      "thornton"                      
#> [281] "TRACE_network"                  "Trout_movement_Skye_2021-2023" 
#> [283] "TurkishMEDTrack"                "TurkishTunaTrack"              
#> [285] "UseIT_BlueCrab_Tracking_array"  "UtS"                           
#> [287] "V2LBEIAR"                       "V2LCASP"                       
#> [289] "V2LCHASES"                      "V2LFALK"                       
#> [291] "V2LGOL"                         "V2LIMFSTP"                     
#> [293] "V2LLIMS"                        "V2LNR"                         
#> [295] "V2LSMQUB"                       "V2LWATCH"                      
#> [297] "VFM_BP"                         "VFM_Braviken"                  
#> [299] "VFM_DSTL"                       "VFM_GoB"                       
#> [301] "VFM_Hjalmaren"                  "VFM_Malaren"                   
#> [303] "VFM_RG"                         "VFM_Siljan"                    
#> [305] "VFM_Vattern"                    "VFM_WCC"                       
#> [307] "VFMLNU_Blekinge"                "VFMLNU_Osby_network"           
#> [309] "VMLSMMI"                        "VMLSOCBS"                      
#> [311] "VVV"                            "Walloneel"                     
#> [313] "WCTP_array"                     "Winde_Tjeukemeer"              
#> [315] "ws1"                            "ws2"                           
#> [317] "ws3"                            "Z001"                          
#> [319] "zeeschelde"                     "ZRM_network"                   
```
