# List all available scientific names

List all available scientific names

## Usage

``` r
list_scientific_names(connection)
```

## Arguments

- connection:

  **\[deprecated\]** A connection to the ETN database. This argument is
  no longer used. You will be prompted for credentials instead.

## Value

A vector of all unique `scientific_name` present in
`common.animal_release`.

## See also

Other list functions:
[`list_acoustic_project_codes()`](https://inbo.github.io/etn/reference/list_acoustic_project_codes.md),
[`list_acoustic_tag_ids()`](https://inbo.github.io/etn/reference/list_acoustic_tag_ids.md),
[`list_animal_ids()`](https://inbo.github.io/etn/reference/list_animal_ids.md),
[`list_animal_project_codes()`](https://inbo.github.io/etn/reference/list_animal_project_codes.md),
[`list_cpod_project_codes()`](https://inbo.github.io/etn/reference/list_cpod_project_codes.md),
[`list_deployment_ids()`](https://inbo.github.io/etn/reference/list_deployment_ids.md),
[`list_receiver_ids()`](https://inbo.github.io/etn/reference/list_receiver_ids.md),
[`list_station_names()`](https://inbo.github.io/etn/reference/list_station_names.md),
[`list_tag_serial_numbers()`](https://inbo.github.io/etn/reference/list_tag_serial_numbers.md),
[`list_values()`](https://inbo.github.io/etn/reference/list_values.md)

## Examples

``` r
list_scientific_names()
#>   [1] "Abramis brama"                  "Abramis brama Rutilus rutilus" 
#>   [3] "Acanthurus"                     "Acipenser"                     
#>   [5] "Acipenser oxyrinchus"           "Acipenser sturio"              
#>   [7] "Aetomylaeus bovinus"            "Alosa agone"                   
#>   [9] "Alosa alosa"                    "Alosa fallax"                  
#>  [11] "Amblyraja radiata"              "Anarhichas lupus"              
#>  [13] "Anguilla anguilla"              "Anguilla rostrata"             
#>  [15] "Argyrosomus regius"             "Aspius aspius"                 
#>  [17] "Balistes capriscus"             "Barbus barbus"                 
#>  [19] "Belone belone"                  "Blicca bjoerkna"               
#>  [21] "Brosme brosme"                  "Built-in"                      
#>  [23] "Callinectes sapidus"            "Cancer pagurus"                
#>  [25] "Caranx bartholomaei"            "Caranx crysos"                 
#>  [27] "Caranx latus"                   "Caranx ruber"                  
#>  [29] "Castor fiber"                   "Cephalopholis cruentata"       
#>  [31] "Cephalopholis fulva"            "Cetorhinus maximus"            
#>  [33] "Chelidonichthys cuculus"        "Chelon labrosus"               
#>  [35] "Chelon ramada"                  "Chelon saliens"                
#>  [37] "Chondrostoma nasus"             "Chromis chromis"               
#>  [39] "Clupea harengus"                "Conger conger"                 
#>  [41] "Coregonus lavaretus"            "Coregonus lavaretus oxyrinchus"
#>  [43] "Coregonus oxyrinchus"           "Coris julis"                   
#>  [45] "Coryphaena hippurus"            "Cyclopterus lumpus"            
#>  [47] "Cyprinus carpio"                "Dactylopterus volitans"        
#>  [49] "Dasyatis"                       "Dasyatis pastinaca"            
#>  [51] "Dentex dentex"                  "Dicentrarchus labrax"          
#>  [53] "Diplodus cervinus"              "Diplodus puntazzo"             
#>  [55] "Diplodus sargus"                "Diplodus vulgaris"             
#>  [57] "Dipturus intermedius"           "Epinephelus costae"            
#>  [59] "Epinephelus guttatus"           "Epinephelus marginatus"        
#>  [61] "Epinephelus striatus"           "Eriocheir sinensis"            
#>  [63] "Eriphia verrucosa"              "Esox lucius"                   
#>  [65] "Gadus morhua"                   "Galeorhinus galeus"            
#>  [67] "Glaucostegus cemiculus"         "Gobius cruentatus"             
#>  [69] "Gymnura altavela"               "Haemulon"                      
#>  [71] "Haemulon carbonarium"           "Haemulon parra"                
#>  [73] "Haemulon plumierii"             "Haemulon sciurus"              
#>  [75] "Helicolenus dactylopterus"      "Hexanchus griseus"             
#>  [77] "Holocentrus"                    "Homarus gammarus"              
#>  [79] "Homo sapiens sapiens"           "Huso huso"                     
#>  [81] "Isurus oxyrinchus"              "Labrus bergylta"               
#>  [83] "Labrus mixtus"                  "Lachnolaimus maximus"          
#>  [85] "Lamna nasus"                    "Lampetra fluviatilis"          
#>  [87] "Leuciscus cephalus"             "Leuciscus idus"                
#>  [89] "Lichia amia"                    "Limanda limanda"               
#>  [91] "Lithognathus mormyrus"          "Liza aurata"                   
#>  [93] "Liza ramada"                    "Lota lota"                     
#>  [95] "Lutjanus analis"                "Lutjanus apodus"               
#>  [97] "Lutjanus mahogoni"              "Lutjanus synagris"             
#>  [99] "Maja brachydactyla"             "Melanogrammus aeglefinus"      
#> [101] "Merlangius merlangus"           "Merluccius merluccius"         
#> [103] "Microstomus kitt"               "Mola mola"                     
#> [105] "Mugil"                          "Mullus surmuletus"             
#> [107] "Muraena helena"                 "Mustelus"                      
#> [109] "Mustelus asterias"              "Mustelus mustelus"             
#> [111] "Mycteroperca bonaci"            "Mycteroperca rubra"            
#> [113] "Myliobatis aquila"              "Myoxocephalus scorpius"        
#> [115] "Oblada melanurus"               "Octopus vulgaris"              
#> [117] "Ocyurus chrysurus"              "Oncorhynchus mykiss"           
#> [119] "Osmerus eperlanus"              "Pagellus bogaraveo"            
#> [121] "Pagellus erythrinus"            "Pagrus pagrus"                 
#> [123] "Palinurus elephas"              "Parablennius gattorugine"      
#> [125] "Perca fluviatilis"              "Petromyzon marinus"            
#> [127] "Plastic"                        "Platichthys flesus"            
#> [129] "Pleuronectes platessa"          "Pollachius pollachius"         
#> [131] "Pollachius virens"              "Pomadasys incisus"             
#> [133] "Pomatomus saltatrix"            "Prionace glauca"               
#> [135] "Pseudocaranx dentex"            "Pterois miles"                 
#> [137] "Pteroplatytrygon violacea"      "Raja asterias"                 
#> [139] "Raja brachyura"                 "Raja clavata"                  
#> [141] "Raja microocellata"             "Raja montagui"                 
#> [143] "Raja polystigma"                "Raja radula"                   
#> [145] "Raja undulata"                  "Range tag"                     
#> [147] "range test"                     "Range test"                    
#> [149] "Reference Tag D-2LP13"          "Reference Tag D-2LP9L"         
#> [151] "Rhinobatos rhinobatos"          "Rostroraja alba"               
#> [153] "Rutilus rutilus"                "Salmo salar"                   
#> [155] "Salmo salar/Salmo trutta"       "Salmo t. trutta"               
#> [157] "Salmo trutta"                   "Salmo trutta trutta"           
#> [159] "Salvelinus alpinus"             "Sander lucioperca"             
#> [161] "Sarpa salpa"                    "Scarus guacamaia"              
#> [163] "Scarus taeniopterus"            "Scarus vetula"                 
#> [165] "Sciaena umbra"                  "Scomber japonicus"             
#> [167] "Scomber scombrus"               "Scophthalmus maximus"          
#> [169] "Scorpaena notata"               "Scorpaena porcus"              
#> [171] "Scorpaena scrofa"               "Scyliorhinus canicula"         
#> [173] "Scyliorhinus stellaris"         "Scyllarides latus"             
#> [175] "Sensor tag"                     "Sepia officinalis"             
#> [177] "Seriola dumerili"               "Seriola rivoliana"             
#> [179] "Serranidae"                     "Serranus atricauda"            
#> [181] "Serranus cabrilla"              "Serranus scriba"               
#> [183] "Silurus glanis"                 "Solea senegalensis"            
#> [185] "Solea solea"                    "Somniosus microcephalus"       
#> [187] "Sparisoma"                      "Sparisoma cretense"            
#> [189] "Sparisoma rubripinne"           "Sparisoma viride"              
#> [191] "Sparus aurata"                  "Sphyraena barracuda"           
#> [193] "Sphyraena viridensis"           "Spicara smaris"                
#> [195] "Spondyliosoma cantharus"        "Squalius cephalus"             
#> [197] "Squalus acanthias"              "Symphodus bailloni"            
#> [199] "Symphodus melops"               "Symphodus ocellatus"           
#> [201] "Symphodus rostratus"            "Symphodus tinca"               
#> [203] "Sync tag"                       "Synctag R-HP16"                
#> [205] "Tetrapturus belone"             "Thunnus thynnus"               
#> [207] "Thymallus thymallus"            "Tinca tinca"                   
#> [209] "Torpedo (Torpedo)"              "Torpedo marmorata"             
#> [211] "Torpedo torpedo"                "Trachurus trachurus"           
#> [213] "Umbrina cirrosa"                "Vimba vimba"                   
#> [215] "Xyrichtys novacula"            
```
