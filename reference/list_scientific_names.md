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

## Examples

``` r
list_scientific_names()
#>   [1] "Abramis brama"                  "Abramis brama Rutilus rutilus" 
#>   [3] "Acipenser"                      "Acipenser oxyrinchus"          
#>   [5] "Acipenser sturio"               "Aetomylaeus bovinus"           
#>   [7] "Alosa alosa"                    "Alosa fallax"                  
#>   [9] "Anarhichas lupus"               "Anguilla anguilla"             
#>  [11] "Anguilla rostrata"              "Argyrosomus regius"            
#>  [13] "Aspius aspius"                  "Balistes capriscus"            
#>  [15] "Barbus barbus"                  "Belone belone"                 
#>  [17] "Blicca bjoerkna"                "Built-in"                      
#>  [19] "Callinectes sapidus"            "Cancer pagurus"                
#>  [21] "Castor fiber"                   "Cetorhinus maximus"            
#>  [23] "Chelidonichthys cuculus"        "Chelon labrosus"               
#>  [25] "Chelon ramada"                  "Chelon saliens"                
#>  [27] "Chondrostoma nasus"             "Chromis chromis"               
#>  [29] "Clupea harengus"                "Conger conger"                 
#>  [31] "Coregonus lavaretus"            "Coregonus lavaretus oxyrinchus"
#>  [33] "Coregonus oxyrinchus"           "Coris julis"                   
#>  [35] "Coryphaena hippurus"            "Cyclopterus lumpus"            
#>  [37] "Cyprinus carpio"                "Dactylopterus volitans"        
#>  [39] "Dasyatis pastinaca"             "Dentex dentex"                 
#>  [41] "Dicentrarchus labrax"           "Diplodus cervinus"             
#>  [43] "Diplodus puntazzo"              "Diplodus sargus"               
#>  [45] "Diplodus vulgaris"              "Epinephelus costae"            
#>  [47] "Epinephelus marginatus"         "Eriocheir sinensis"            
#>  [49] "Eriphia verrucosa"              "Esox lucius"                   
#>  [51] "Gadus morhua"                   "Galeorhinus galeus"            
#>  [53] "Glaucostegus cemiculus"         "Gobius cruentatus"             
#>  [55] "Gymnura altavela"               "Hexanchus griseus"             
#>  [57] "Homarus gammarus"               "Homo sapiens sapiens"          
#>  [59] "Isurus oxyrinchus"              "Labrus bergylta"               
#>  [61] "Labrus mixtus"                  "Lamna nasus"                   
#>  [63] "Lampetra fluviatilis"           "Leuciscus idus"                
#>  [65] "Lichia amia"                    "Limanda limanda"               
#>  [67] "Lithognathus mormyrus"          "Liza aurata"                   
#>  [69] "Liza ramada"                    "Lota lota"                     
#>  [71] "Maja brachydactyla"             "Melanogrammus aeglefinus"      
#>  [73] "Merlangius merlangus"           "Merluccius merluccius"         
#>  [75] "Microstomus kitt"               "Mola mola"                     
#>  [77] "Mugil"                          "Mullus surmuletus"             
#>  [79] "Muraena helena"                 "Mustelus"                      
#>  [81] "Mustelus asterias"              "Mustelus mustelus"             
#>  [83] "Mycteroperca rubra"             "Myliobatis aquila"             
#>  [85] "Myoxocephalus scorpius"         "Oblada melanurus"              
#>  [87] "Octopus vulgaris"               "Oncorhynchus mykiss"           
#>  [89] "Osmerus eperlanus"              "Pagellus bogaraveo"            
#>  [91] "Pagellus erythrinus"            "Pagrus pagrus"                 
#>  [93] "Palinurus elephas"              "Parablennius gattorugine"      
#>  [95] "Perca fluviatilis"              "Petromyzon marinus"            
#>  [97] "Plastic"                        "Platichthys flesus"            
#>  [99] "Pleuronectes platessa"          "Pollachius pollachius"         
#> [101] "Pomadasys incisus"              "Pomatomus saltatrix"           
#> [103] "Prionace glauca"                "Pseudocaranx dentex"           
#> [105] "Pteroplatytrygon violacea"      "Raja asterias"                 
#> [107] "Raja brachyura"                 "Raja clavata"                  
#> [109] "Raja montagui"                  "Raja polystigma"               
#> [111] "Raja radula"                    "Raja undulata"                 
#> [113] "Range tag"                      "range test"                    
#> [115] "Range test"                     "Reference Tag D-2LP13"         
#> [117] "Reference Tag D-2LP9L"          "Rostroraja alba"               
#> [119] "Rutilus rutilus"                "Salmo salar"                   
#> [121] "Salmo salar/Salmo trutta"       "Salmo t. trutta"               
#> [123] "Salmo trutta"                   "Salmo trutta trutta"           
#> [125] "Salvelinus alpinus"             "Sander lucioperca"             
#> [127] "Sarpa salpa"                    "Sciaena umbra"                 
#> [129] "Scomber scombrus"               "Scophthalmus maximus"          
#> [131] "Scorpaena notata"               "Scorpaena porcus"              
#> [133] "Scorpaena scrofa"               "Scyliorhinus canicula"         
#> [135] "Scyliorhinus stellaris"         "Scyllarides latus"             
#> [137] "Sensor tag"                     "Sepia officinalis"             
#> [139] "Seriola dumerili"               "Seriola rivoliana"             
#> [141] "Serranus atricauda"             "Serranus cabrilla"             
#> [143] "Serranus scriba"                "Silurus glanis"                
#> [145] "Solea senegalensis"             "Solea solea"                   
#> [147] "Somniosus microcephalus"        "Sparisoma cretense"            
#> [149] "Sparus aurata"                  "Sphyraena barracuda"           
#> [151] "Sphyraena viridensis"           "Spondyliosoma cantharus"       
#> [153] "Squalius cephalus"              "Squalus acanthias"             
#> [155] "Symphodus bailloni"             "Symphodus melops"              
#> [157] "Symphodus ocellatus"            "Symphodus rostratus"           
#> [159] "Symphodus tinca"                "Sync tag"                      
#> [161] "Synctag R-HP16"                 "Tetrapturus belone"            
#> [163] "Thunnus thynnus"                "Thymallus thymallus"           
#> [165] "Tinca tinca"                    "Torpedo (Torpedo)"             
#> [167] "Torpedo marmorata"              "Torpedo torpedo"               
#> [169] "Trachurus trachurus"            "Umbrina cirrosa"               
#> [171] "Vimba vimba"                    "Xyrichtys novacula"            
```
