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
#>   [7] "Aetomylaeus bovinus"            "Alosa alosa"                   
#>   [9] "Alosa fallax"                   "Amblyraja radiata"             
#>  [11] "Anarhichas lupus"               "Anguilla anguilla"             
#>  [13] "Anguilla rostrata"              "Argyrosomus regius"            
#>  [15] "Aspius aspius"                  "Balistes capriscus"            
#>  [17] "Barbus barbus"                  "Belone belone"                 
#>  [19] "Blicca bjoerkna"                "Built-in"                      
#>  [21] "Callinectes sapidus"            "Cancer pagurus"                
#>  [23] "Caranx bartholomaei"            "Caranx crysos"                 
#>  [25] "Caranx latus"                   "Caranx ruber"                  
#>  [27] "Castor fiber"                   "Cephalopholis cruentata"       
#>  [29] "Cephalopholis fulva"            "Cetorhinus maximus"            
#>  [31] "Chelidonichthys cuculus"        "Chelon labrosus"               
#>  [33] "Chelon ramada"                  "Chelon saliens"                
#>  [35] "Chondrostoma nasus"             "Chromis chromis"               
#>  [37] "Clupea harengus"                "Conger conger"                 
#>  [39] "Coregonus lavaretus"            "Coregonus lavaretus oxyrinchus"
#>  [41] "Coregonus oxyrinchus"           "Coris julis"                   
#>  [43] "Coryphaena hippurus"            "Cyclopterus lumpus"            
#>  [45] "Cyprinus carpio"                "Dactylopterus volitans"        
#>  [47] "Dasyatis pastinaca"             "Dentex dentex"                 
#>  [49] "Dicentrarchus labrax"           "Diplodus cervinus"             
#>  [51] "Diplodus puntazzo"              "Diplodus sargus"               
#>  [53] "Diplodus vulgaris"              "Dipturus intermedius"          
#>  [55] "Epinephelus costae"             "Epinephelus guttatus"          
#>  [57] "Epinephelus marginatus"         "Epinephelus striatus"          
#>  [59] "Eriocheir sinensis"             "Eriphia verrucosa"             
#>  [61] "Esox lucius"                    "Gadus morhua"                  
#>  [63] "Galeorhinus galeus"             "Glaucostegus cemiculus"        
#>  [65] "Gobius cruentatus"              "Gymnura altavela"              
#>  [67] "Haemulon"                       "Haemulon carbonarium"          
#>  [69] "Haemulon parra"                 "Haemulon plumierii"            
#>  [71] "Haemulon sciurus"               "Hexanchus griseus"             
#>  [73] "Holocentrus"                    "Homarus gammarus"              
#>  [75] "Homo sapiens sapiens"           "Isurus oxyrinchus"             
#>  [77] "Labrus bergylta"                "Labrus mixtus"                 
#>  [79] "Lachnolaimus maximus"           "Lamna nasus"                   
#>  [81] "Lampetra fluviatilis"           "Leuciscus idus"                
#>  [83] "Lichia amia"                    "Limanda limanda"               
#>  [85] "Lithognathus mormyrus"          "Liza aurata"                   
#>  [87] "Liza ramada"                    "Lota lota"                     
#>  [89] "Lutjanus analis"                "Lutjanus apodus"               
#>  [91] "Lutjanus mahogoni"              "Lutjanus synagris"             
#>  [93] "Maja brachydactyla"             "Melanogrammus aeglefinus"      
#>  [95] "Merlangius merlangus"           "Merluccius merluccius"         
#>  [97] "Microstomus kitt"               "Mola mola"                     
#>  [99] "Mugil"                          "Mullus surmuletus"             
#> [101] "Muraena helena"                 "Mustelus"                      
#> [103] "Mustelus asterias"              "Mustelus mustelus"             
#> [105] "Mycteroperca bonaci"            "Mycteroperca rubra"            
#> [107] "Myliobatis aquila"              "Myoxocephalus scorpius"        
#> [109] "Oblada melanurus"               "Octopus vulgaris"              
#> [111] "Ocyurus chrysurus"              "Oncorhynchus mykiss"           
#> [113] "Osmerus eperlanus"              "Pagellus bogaraveo"            
#> [115] "Pagellus erythrinus"            "Pagrus pagrus"                 
#> [117] "Palinurus elephas"              "Parablennius gattorugine"      
#> [119] "Perca fluviatilis"              "Petromyzon marinus"            
#> [121] "Plastic"                        "Platichthys flesus"            
#> [123] "Pleuronectes platessa"          "Pollachius pollachius"         
#> [125] "Pollachius virens"              "Pomadasys incisus"             
#> [127] "Pomatomus saltatrix"            "Prionace glauca"               
#> [129] "Pseudocaranx dentex"            "Pteroplatytrygon violacea"     
#> [131] "Raja asterias"                  "Raja brachyura"                
#> [133] "Raja clavata"                   "Raja montagui"                 
#> [135] "Raja polystigma"                "Raja radula"                   
#> [137] "Raja undulata"                  "Range tag"                     
#> [139] "range test"                     "Range test"                    
#> [141] "Reference Tag D-2LP13"          "Reference Tag D-2LP9L"         
#> [143] "Rhinobatos rhinobatos"          "Rostroraja alba"               
#> [145] "Rutilus rutilus"                "Salmo salar"                   
#> [147] "Salmo salar/Salmo trutta"       "Salmo t. trutta"               
#> [149] "Salmo trutta"                   "Salmo trutta trutta"           
#> [151] "Salvelinus alpinus"             "Sander lucioperca"             
#> [153] "Sarpa salpa"                    "Scarus guacamaia"              
#> [155] "Scarus taeniopterus"            "Scarus vetula"                 
#> [157] "Sciaena umbra"                  "Scomber scombrus"              
#> [159] "Scophthalmus maximus"           "Scorpaena notata"              
#> [161] "Scorpaena porcus"               "Scorpaena scrofa"              
#> [163] "Scyliorhinus canicula"          "Scyliorhinus stellaris"        
#> [165] "Scyllarides latus"              "Sensor tag"                    
#> [167] "Sepia officinalis"              "Seriola dumerili"              
#> [169] "Seriola rivoliana"              "Serranidae"                    
#> [171] "Serranus atricauda"             "Serranus cabrilla"             
#> [173] "Serranus scriba"                "Silurus glanis"                
#> [175] "Solea senegalensis"             "Solea solea"                   
#> [177] "Somniosus microcephalus"        "Sparisoma"                     
#> [179] "Sparisoma cretense"             "Sparisoma rubripinne"          
#> [181] "Sparisoma viride"               "Sparus aurata"                 
#> [183] "Sphyraena barracuda"            "Sphyraena viridensis"          
#> [185] "Spicara smaris"                 "Spondyliosoma cantharus"       
#> [187] "Squalius cephalus"              "Squalus acanthias"             
#> [189] "Symphodus bailloni"             "Symphodus melops"              
#> [191] "Symphodus ocellatus"            "Symphodus rostratus"           
#> [193] "Symphodus tinca"                "Sync tag"                      
#> [195] "Synctag R-HP16"                 "Tetrapturus belone"            
#> [197] "Thunnus thynnus"                "Thymallus thymallus"           
#> [199] "Tinca tinca"                    "Torpedo (Torpedo)"             
#> [201] "Torpedo marmorata"              "Torpedo torpedo"               
#> [203] "Trachurus trachurus"            "Umbrina cirrosa"               
#> [205] "Vimba vimba"                    "Xyrichtys novacula"            
```
