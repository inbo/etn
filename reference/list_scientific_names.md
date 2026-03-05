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
#>  [53] "Dipturus intermedius"           "Epinephelus costae"            
#>  [55] "Epinephelus guttatus"           "Epinephelus marginatus"        
#>  [57] "Epinephelus striatus"           "Eriocheir sinensis"            
#>  [59] "Eriphia verrucosa"              "Esox lucius"                   
#>  [61] "Gadus morhua"                   "Galeorhinus galeus"            
#>  [63] "Glaucostegus cemiculus"         "Gobius cruentatus"             
#>  [65] "Gymnura altavela"               "Haemulon"                      
#>  [67] "Haemulon carbonarium"           "Haemulon parra"                
#>  [69] "Haemulon plumierii"             "Haemulon sciurus"              
#>  [71] "Hexanchus griseus"              "Holocentrus"                   
#>  [73] "Homarus gammarus"               "Homo sapiens sapiens"          
#>  [75] "Isurus oxyrinchus"              "Labrus bergylta"               
#>  [77] "Labrus mixtus"                  "Lachnolaimus maximus"          
#>  [79] "Lamna nasus"                    "Lampetra fluviatilis"          
#>  [81] "Leuciscus idus"                 "Lichia amia"                   
#>  [83] "Limanda limanda"                "Lithognathus mormyrus"         
#>  [85] "Liza aurata"                    "Liza ramada"                   
#>  [87] "Lota lota"                      "Lutjanus analis"               
#>  [89] "Lutjanus apodus"                "Lutjanus mahogoni"             
#>  [91] "Lutjanus synagris"              "Maja brachydactyla"            
#>  [93] "Melanogrammus aeglefinus"       "Merlangius merlangus"          
#>  [95] "Merluccius merluccius"          "Microstomus kitt"              
#>  [97] "Mola mola"                      "Mugil"                         
#>  [99] "Mullus surmuletus"              "Muraena helena"                
#> [101] "Mustelus"                       "Mustelus asterias"             
#> [103] "Mustelus mustelus"              "Mycteroperca bonaci"           
#> [105] "Mycteroperca rubra"             "Myliobatis aquila"             
#> [107] "Myoxocephalus scorpius"         "Oblada melanurus"              
#> [109] "Octopus vulgaris"               "Ocyurus chrysurus"             
#> [111] "Oncorhynchus mykiss"            "Osmerus eperlanus"             
#> [113] "Pagellus bogaraveo"             "Pagellus erythrinus"           
#> [115] "Pagrus pagrus"                  "Palinurus elephas"             
#> [117] "Parablennius gattorugine"       "Perca fluviatilis"             
#> [119] "Petromyzon marinus"             "Plastic"                       
#> [121] "Platichthys flesus"             "Pleuronectes platessa"         
#> [123] "Pollachius pollachius"          "Pollachius virens"             
#> [125] "Pomadasys incisus"              "Pomatomus saltatrix"           
#> [127] "Prionace glauca"                "Pseudocaranx dentex"           
#> [129] "Pteroplatytrygon violacea"      "Raja asterias"                 
#> [131] "Raja brachyura"                 "Raja clavata"                  
#> [133] "Raja montagui"                  "Raja polystigma"               
#> [135] "Raja radula"                    "Raja undulata"                 
#> [137] "Range tag"                      "range test"                    
#> [139] "Range test"                     "Reference Tag D-2LP13"         
#> [141] "Reference Tag D-2LP9L"          "Rostroraja alba"               
#> [143] "Rutilus rutilus"                "Salmo salar"                   
#> [145] "Salmo salar/Salmo trutta"       "Salmo t. trutta"               
#> [147] "Salmo trutta"                   "Salmo trutta trutta"           
#> [149] "Salvelinus alpinus"             "Sander lucioperca"             
#> [151] "Sarpa salpa"                    "Scarus guacamaia"              
#> [153] "Scarus taeniopterus"            "Scarus vetula"                 
#> [155] "Sciaena umbra"                  "Scomber scombrus"              
#> [157] "Scophthalmus maximus"           "Scorpaena notata"              
#> [159] "Scorpaena porcus"               "Scorpaena scrofa"              
#> [161] "Scyliorhinus canicula"          "Scyliorhinus stellaris"        
#> [163] "Scyllarides latus"              "Sensor tag"                    
#> [165] "Sepia officinalis"              "Seriola dumerili"              
#> [167] "Seriola rivoliana"              "Serranidae"                    
#> [169] "Serranus atricauda"             "Serranus cabrilla"             
#> [171] "Serranus scriba"                "Silurus glanis"                
#> [173] "Solea senegalensis"             "Solea solea"                   
#> [175] "Somniosus microcephalus"        "Sparisoma"                     
#> [177] "Sparisoma cretense"             "Sparisoma rubripinne"          
#> [179] "Sparisoma viride"               "Sparus aurata"                 
#> [181] "Sphyraena barracuda"            "Sphyraena viridensis"          
#> [183] "Spondyliosoma cantharus"        "Squalius cephalus"             
#> [185] "Squalus acanthias"              "Symphodus bailloni"            
#> [187] "Symphodus melops"               "Symphodus ocellatus"           
#> [189] "Symphodus rostratus"            "Symphodus tinca"               
#> [191] "Sync tag"                       "Synctag R-HP16"                
#> [193] "Tetrapturus belone"             "Thunnus thynnus"               
#> [195] "Thymallus thymallus"            "Tinca tinca"                   
#> [197] "Torpedo (Torpedo)"              "Torpedo marmorata"             
#> [199] "Torpedo torpedo"                "Trachurus trachurus"           
#> [201] "Umbrina cirrosa"                "Vimba vimba"                   
#> [203] "Xyrichtys novacula"            
```
