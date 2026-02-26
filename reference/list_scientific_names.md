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
#>   [3] "Acanthurus"                     "Acipenser"                     
#>   [5] "Acipenser oxyrinchus"           "Acipenser sturio"              
#>   [7] "Aetomylaeus bovinus"            "Alosa alosa"                   
#>   [9] "Alosa fallax"                   "Anarhichas lupus"              
#>  [11] "Anguilla anguilla"              "Anguilla rostrata"             
#>  [13] "Argyrosomus regius"             "Aspius aspius"                 
#>  [15] "Balistes capriscus"             "Barbus barbus"                 
#>  [17] "Belone belone"                  "Blicca bjoerkna"               
#>  [19] "Built-in"                       "Callinectes sapidus"           
#>  [21] "Cancer pagurus"                 "Caranx bartholomaei"           
#>  [23] "Caranx crysos"                  "Caranx latus"                  
#>  [25] "Caranx ruber"                   "Castor fiber"                  
#>  [27] "Cephalopholis cruentata"        "Cephalopholis fulva"           
#>  [29] "Cetorhinus maximus"             "Chelidonichthys cuculus"       
#>  [31] "Chelon labrosus"                "Chelon ramada"                 
#>  [33] "Chelon saliens"                 "Chondrostoma nasus"            
#>  [35] "Chromis chromis"                "Clupea harengus"               
#>  [37] "Conger conger"                  "Coregonus lavaretus"           
#>  [39] "Coregonus lavaretus oxyrinchus" "Coregonus oxyrinchus"          
#>  [41] "Coris julis"                    "Coryphaena hippurus"           
#>  [43] "Cyclopterus lumpus"             "Cyprinus carpio"               
#>  [45] "Dactylopterus volitans"         "Dasyatis pastinaca"            
#>  [47] "Dentex dentex"                  "Dicentrarchus labrax"          
#>  [49] "Diplodus cervinus"              "Diplodus puntazzo"             
#>  [51] "Diplodus sargus"                "Diplodus vulgaris"             
#>  [53] "Epinephelus costae"             "Epinephelus guttatus"          
#>  [55] "Epinephelus marginatus"         "Epinephelus striatus"          
#>  [57] "Eriocheir sinensis"             "Eriphia verrucosa"             
#>  [59] "Esox lucius"                    "Gadus morhua"                  
#>  [61] "Galeorhinus galeus"             "Glaucostegus cemiculus"        
#>  [63] "Gobius cruentatus"              "Gymnura altavela"              
#>  [65] "Haemulon"                       "Haemulon carbonarium"          
#>  [67] "Haemulon parra"                 "Haemulon plumierii"            
#>  [69] "Haemulon sciurus"               "Hexanchus griseus"             
#>  [71] "Holocentrus"                    "Homarus gammarus"              
#>  [73] "Homo sapiens sapiens"           "Isurus oxyrinchus"             
#>  [75] "Labrus bergylta"                "Labrus mixtus"                 
#>  [77] "Lachnolaimus maximus"           "Lamna nasus"                   
#>  [79] "Lampetra fluviatilis"           "Leuciscus idus"                
#>  [81] "Lichia amia"                    "Limanda limanda"               
#>  [83] "Lithognathus mormyrus"          "Liza aurata"                   
#>  [85] "Liza ramada"                    "Lota lota"                     
#>  [87] "Lutjanus analis"                "Lutjanus apodus"               
#>  [89] "Lutjanus mahogoni"              "Lutjanus synagris"             
#>  [91] "Maja brachydactyla"             "Melanogrammus aeglefinus"      
#>  [93] "Merlangius merlangus"           "Merluccius merluccius"         
#>  [95] "Microstomus kitt"               "Mola mola"                     
#>  [97] "Mugil"                          "Mullus surmuletus"             
#>  [99] "Muraena helena"                 "Mustelus"                      
#> [101] "Mustelus asterias"              "Mustelus mustelus"             
#> [103] "Mycteroperca bonaci"            "Mycteroperca rubra"            
#> [105] "Myliobatis aquila"              "Myoxocephalus scorpius"        
#> [107] "Oblada melanurus"               "Octopus vulgaris"              
#> [109] "Ocyurus chrysurus"              "Oncorhynchus mykiss"           
#> [111] "Osmerus eperlanus"              "Pagellus bogaraveo"            
#> [113] "Pagellus erythrinus"            "Pagrus pagrus"                 
#> [115] "Palinurus elephas"              "Parablennius gattorugine"      
#> [117] "Perca fluviatilis"              "Petromyzon marinus"            
#> [119] "Plastic"                        "Platichthys flesus"            
#> [121] "Pleuronectes platessa"          "Pollachius pollachius"         
#> [123] "Pollachius virens"              "Pomadasys incisus"             
#> [125] "Pomatomus saltatrix"            "Prionace glauca"               
#> [127] "Pseudocaranx dentex"            "Pteroplatytrygon violacea"     
#> [129] "Raja asterias"                  "Raja brachyura"                
#> [131] "Raja clavata"                   "Raja montagui"                 
#> [133] "Raja polystigma"                "Raja radula"                   
#> [135] "Raja undulata"                  "Range tag"                     
#> [137] "range test"                     "Range test"                    
#> [139] "Reference Tag D-2LP13"          "Reference Tag D-2LP9L"         
#> [141] "Rostroraja alba"                "Rutilus rutilus"               
#> [143] "Salmo salar"                    "Salmo salar/Salmo trutta"      
#> [145] "Salmo t. trutta"                "Salmo trutta"                  
#> [147] "Salmo trutta trutta"            "Salvelinus alpinus"            
#> [149] "Sander lucioperca"              "Sarpa salpa"                   
#> [151] "Scarus guacamaia"               "Scarus taeniopterus"           
#> [153] "Scarus vetula"                  "Sciaena umbra"                 
#> [155] "Scomber scombrus"               "Scophthalmus maximus"          
#> [157] "Scorpaena notata"               "Scorpaena porcus"              
#> [159] "Scorpaena scrofa"               "Scyliorhinus canicula"         
#> [161] "Scyliorhinus stellaris"         "Scyllarides latus"             
#> [163] "Sensor tag"                     "Sepia officinalis"             
#> [165] "Seriola dumerili"               "Seriola rivoliana"             
#> [167] "Serranidae"                     "Serranus atricauda"            
#> [169] "Serranus cabrilla"              "Serranus scriba"               
#> [171] "Silurus glanis"                 "Solea senegalensis"            
#> [173] "Solea solea"                    "Somniosus microcephalus"       
#> [175] "Sparisoma"                      "Sparisoma cretense"            
#> [177] "Sparisoma rubripinne"           "Sparisoma viride"              
#> [179] "Sparus aurata"                  "Sphyraena barracuda"           
#> [181] "Sphyraena viridensis"           "Spondyliosoma cantharus"       
#> [183] "Squalius cephalus"              "Squalus acanthias"             
#> [185] "Symphodus bailloni"             "Symphodus melops"              
#> [187] "Symphodus ocellatus"            "Symphodus rostratus"           
#> [189] "Symphodus tinca"                "Sync tag"                      
#> [191] "Synctag R-HP16"                 "Tetrapturus belone"            
#> [193] "Thunnus thynnus"                "Thymallus thymallus"           
#> [195] "Tinca tinca"                    "Torpedo (Torpedo)"             
#> [197] "Torpedo marmorata"              "Torpedo torpedo"               
#> [199] "Trachurus trachurus"            "Umbrina cirrosa"               
#> [201] "Vimba vimba"                    "Xyrichtys novacula"            
```
