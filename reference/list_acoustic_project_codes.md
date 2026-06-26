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
#>  [43] "Blueconnect"                    "BlueCrab2022Algarve"           
#>  [45] "BOATS_network"                  "Bodden_Pike"                   
#>  [47] "BOOGMR"                         "BOOPAP"                        
#>  [49] "BOOPIRATA"                      "BOORAMA"                       
#>  [51] "BOOSBI"                         "bpns"                          
#>  [53] "Brasem_IJM_MM"                  "BristolChannelArray"           
#>  [55] "BSTN"                           "BTN"                           
#>  [57] "BTN_LOST_ARRAY"                 "BTN-DeepWater-IMEDEA"          
#>  [59] "BTN-IMEDEA"                     "CANAPE"                        
#>  [61] "Carlingford"                    "CESB_network"                  
#>  [63] "CMAX_Hebrides"                  "COD_OG_DK_2023"                
#>  [65] "COD_OWF"                        "Cod-connectivity"              
#>  [67] "CODEVCO_fish_detectors"         "COLAGANG"                      
#>  [69] "CONNECT-MED"                    "Conon"                         
#>  [71] "COREMAR"                        "CORYTRACK"                     
#>  [73] "cpodnetwork"                    "Crab_behavior_aquaculture_Norw"
#>  [75] "Csapidus_Southern_France"       "CTN"                           
#>  [77] "DAbecasis_PhD"                  "DAERA_Elasmobranch_Network"    
#>  [79] "DAK"                            "Danish_southeastern_strait"    
#>  [81] "Danish_Straits"                 "Danube_Sturgeons"              
#>  [83] "DEHINC.HABI.GUACETO"            "Delfzijl"                      
#>  [85] "demer"                          "Deveron"                       
#>  [87] "dijle"                          "Dijle_VPS"                     
#>  [89] "DSM"                            "DTU-Skjern"                    
#>  [91] "DuskMaro"                       "EBAMAR_array"                  
#>  [93] "Eel_HighRhine_26-29_array"      "Eel_migration_Test_2023"       
#>  [95] "Eel-source-to-sea"              "eemskanaal_I"                  
#>  [97] "eemskanaal_II"                  "eemskanaal_III"                
#>  [99] "EMFish_test"                    "EMMN"                          
#> [101] "ESGL"                           "ETN_network_project_group_1"   
#> [103] "ETN_network_project_group_2"    "ETN_network_project_group_3"   
#> [105] "ETN_network_project_group_4"    "ETN_network_project_group_5"   
#> [107] "ETN_network_project_group_6"    "ETN_network_project_group_7"   
#> [109] "ETN_network_project_group_8"    "ETN_network_project_group_9"   
#> [111] "EUTN"                           "FarmTrack_network"             
#> [113] "Finescale_Helgoland"            "Fish_Mig_Wad_Sea"              
#> [115] "FISHINTEL"                      "FISHOWF"                       
#> [117] "FISHOWF+"                       "FISP"                          
#> [119] "Foyle_Catchment"                "Friesland"                     
#> [121] "GEPESCART2_ARRAY"               "GIBRALTRACK_pilot"             
#> [123] "Grotenete"                      "GTN"                           
#> [125] "Gudena_network"                 "GuitarProtect_array"           
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
#> [149] "Lake_Anundsjo_VPS"              "LamTre20_21"                   
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
#> [207] "PrePARED"                       "PTN_ATLAZUL"                   
#> [209] "PTN_MEROSW2021"                 "PTN_MIGRACORV"                 
#> [211] "PTN_PROTECT2012"                "PTN_PROTECT2013"               
#> [213] "PTN-MARSW"                      "PTN-Silver-eel-Mondego"        
#> [215] "PureWind_fish_detectors"        "RAJIBAL-COFIB"                 
#> [217] "RATJADA"                        "RBVV2"                         
#> [219] "RECCRU_array"                   "Reelease"                      
#> [221] "RESBIO"                         "ResMed"                        
#> [223] "river_severn_array"             "River_Usk"                     
#> [225] "RNP"                            "rt2020_zeeschelde"             
#> [227] "RTT"                            "Running_eel"                   
#> [229] "saeftinghe"                     "Salmo_Migration_NSIC"          
#> [231] "Salmon_Eastern_Greenland"       "SAMARCH"                       
#> [233] "SARTELARAM"                     "SARTELTG"                      
#> [235] "SARTELZINGARO"                  "SCHUFI"                        
#> [237] "Scytrack"                       "SeaMonitor"                    
#> [239] "SEAMONITOR_ARRAY"               "SEM_array"                     
#> [241] "SEMP"                           "SGB"                           
#> [243] "Shark_Levant_tracking"          "SIARC_ARRAY"                   
#> [245] "Siganid_East_Med"               "Siganid_Gulf_Aqaba"            
#> [247] "Skagerrak-NorthSea-array"       "SkagNor"                       
#> [249] "Skye"                           "SMAFBI"                        
#> [251] "SmartBay_array"                 "SMLA"                          
#> [253] "SMOLTRACK-I-Engeland"           "SMOLTRACK-II-Engeland"         
#> [255] "SMUOG"                          "SPAWNSEIS"                     
#> [257] "SPICARA_network"                "SPIDER_GNB_array"              
#> [259] "SrivAqab"                       "SrivEMed"                      
#> [261] "ST08SWE"                        "STRAITS_GIBRALTAR_ARRAY"       
#> [263] "STRAITS_TSTN"                   "Sturgeon_reintroduction_array" 
#> [265] "sturgeonSK"                     "STURNETGEBZE_ARRAY"            
#> [267] "SU.MO.ELASMO.Adriatic"          "Sudle_IMPULS"                  
#> [269] "Sudle_INNOV"                    "super_smolts_array"            
#> [271] "SUPERSAT"                       "SVNL-FISH-WATCH"               
#> [273] "SW_Oude_Ijssel"                 "SWIMWAY_2021"                  
#> [275] "Swimway_vechte"                 "Swiss_AcTel"                   
#> [277] "SWRL_array"                     "TelePomiMer_array"             
#> [279] "TelMarsw"                       "TeRi"                          
#> [281] "testvr2ar"                      "thornton"                      
#> [283] "TRACE_network"                  "Trout_movement_Skye_2021-2023" 
#> [285] "TurkishMEDTrack"                "TurkishTunaTrack"              
#> [287] "UseIT_BlueCrab_Tracking_array"  "UtS"                           
#> [289] "V2LBEIAR"                       "V2LCASP"                       
#> [291] "V2LCHASES"                      "V2LFALK"                       
#> [293] "V2LGOL"                         "V2LIMFSTP"                     
#> [295] "V2LLIMS"                        "V2LNR"                         
#> [297] "V2LSMQUB"                       "V2LWATCH"                      
#> [299] "VFM_BP"                         "VFM_Braviken"                  
#> [301] "VFM_DSTL"                       "VFM_GoB"                       
#> [303] "VFM_Hjalmaren"                  "VFM_Malaren"                   
#> [305] "VFM_RG"                         "VFM_Siljan"                    
#> [307] "VFM_Vattern"                    "VFM_WCC"                       
#> [309] "VFMLNU_Blekinge"                "VFMLNU_Osby_network"           
#> [311] "VMLSMMI"                        "VMLSOCBS"                      
#> [313] "VVV"                            "Walloneel"                     
#> [315] "WCTP_array"                     "Winde_Tjeukemeer"              
#> [317] "ws1"                            "ws2"                           
#> [319] "ws3"                            "Z001"                          
#> [321] "zeeschelde"                     "ZRM_network"                   
```
