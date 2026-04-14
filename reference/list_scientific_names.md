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
#> [143] "Rostroraja alba"                "Rutilus rutilus"               
#> [145] "Salmo salar"                    "Salmo salar/Salmo trutta"      
#> [147] "Salmo t. trutta"                "Salmo trutta"                  
#> [149] "Salmo trutta trutta"            "Salvelinus alpinus"            
#> [151] "Sander lucioperca"              "Sarpa salpa"                   
#> [153] "Scarus guacamaia"               "Scarus taeniopterus"           
#> [155] "Scarus vetula"                  "Sciaena umbra"                 
#> [157] "Scomber scombrus"               "Scophthalmus maximus"          
#> [159] "Scorpaena notata"               "Scorpaena porcus"              
#> [161] "Scorpaena scrofa"               "Scyliorhinus canicula"         
#> [163] "Scyliorhinus stellaris"         "Scyllarides latus"             
#> [165] "Sensor tag"                     "Sepia officinalis"             
#> [167] "Seriola dumerili"               "Seriola rivoliana"             
#> [169] "Serranidae"                     "Serranus atricauda"            
#> [171] "Serranus cabrilla"              "Serranus scriba"               
#> [173] "Silurus glanis"                 "Solea senegalensis"            
#> [175] "Solea solea"                    "Somniosus microcephalus"       
#> [177] "Sparisoma"                      "Sparisoma cretense"            
#> [179] "Sparisoma rubripinne"           "Sparisoma viride"              
#> [181] "Sparus aurata"                  "Sphyraena barracuda"           
#> [183] "Sphyraena viridensis"           "Spicara smaris"                
#> [185] "Spondyliosoma cantharus"        "Squalius cephalus"             
#> [187] "Squalus acanthias"              "Symphodus bailloni"            
#> [189] "Symphodus melops"               "Symphodus ocellatus"           
#> [191] "Symphodus rostratus"            "Symphodus tinca"               
#> [193] "Sync tag"                       "Synctag R-HP16"                
#> [195] "Tetrapturus belone"             "Thunnus thynnus"               
#> [197] "Thymallus thymallus"            "Tinca tinca"                   
#> [199] "Torpedo (Torpedo)"              "Torpedo marmorata"             
#> [201] "Torpedo torpedo"                "Trachurus trachurus"           
#> [203] "Umbrina cirrosa"                "Vimba vimba"                   
#> [205] "Xyrichtys novacula"            
```
