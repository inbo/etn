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
#>  [47] "Dasyatis"                       "Dasyatis pastinaca"            
#>  [49] "Dentex dentex"                  "Dicentrarchus labrax"          
#>  [51] "Diplodus cervinus"              "Diplodus puntazzo"             
#>  [53] "Diplodus sargus"                "Diplodus vulgaris"             
#>  [55] "Dipturus intermedius"           "Epinephelus costae"            
#>  [57] "Epinephelus guttatus"           "Epinephelus marginatus"        
#>  [59] "Epinephelus striatus"           "Eriocheir sinensis"            
#>  [61] "Eriphia verrucosa"              "Esox lucius"                   
#>  [63] "Gadus morhua"                   "Galeorhinus galeus"            
#>  [65] "Glaucostegus cemiculus"         "Gobius cruentatus"             
#>  [67] "Gymnura altavela"               "Haemulon"                      
#>  [69] "Haemulon carbonarium"           "Haemulon parra"                
#>  [71] "Haemulon plumierii"             "Haemulon sciurus"              
#>  [73] "Hexanchus griseus"              "Holocentrus"                   
#>  [75] "Homarus gammarus"               "Homo sapiens sapiens"          
#>  [77] "Huso huso"                      "Isurus oxyrinchus"             
#>  [79] "Labrus bergylta"                "Labrus mixtus"                 
#>  [81] "Lachnolaimus maximus"           "Lamna nasus"                   
#>  [83] "Lampetra fluviatilis"           "Leuciscus idus"                
#>  [85] "Lichia amia"                    "Limanda limanda"               
#>  [87] "Lithognathus mormyrus"          "Liza aurata"                   
#>  [89] "Liza ramada"                    "Lota lota"                     
#>  [91] "Lutjanus analis"                "Lutjanus apodus"               
#>  [93] "Lutjanus mahogoni"              "Lutjanus synagris"             
#>  [95] "Maja brachydactyla"             "Melanogrammus aeglefinus"      
#>  [97] "Merlangius merlangus"           "Merluccius merluccius"         
#>  [99] "Microstomus kitt"               "Mola mola"                     
#> [101] "Mugil"                          "Mullus surmuletus"             
#> [103] "Muraena helena"                 "Mustelus"                      
#> [105] "Mustelus asterias"              "Mustelus mustelus"             
#> [107] "Mycteroperca bonaci"            "Mycteroperca rubra"            
#> [109] "Myliobatis aquila"              "Myoxocephalus scorpius"        
#> [111] "Oblada melanurus"               "Octopus vulgaris"              
#> [113] "Ocyurus chrysurus"              "Oncorhynchus mykiss"           
#> [115] "Osmerus eperlanus"              "Pagellus bogaraveo"            
#> [117] "Pagellus erythrinus"            "Pagrus pagrus"                 
#> [119] "Palinurus elephas"              "Parablennius gattorugine"      
#> [121] "Perca fluviatilis"              "Petromyzon marinus"            
#> [123] "Plastic"                        "Platichthys flesus"            
#> [125] "Pleuronectes platessa"          "Pollachius pollachius"         
#> [127] "Pollachius virens"              "Pomadasys incisus"             
#> [129] "Pomatomus saltatrix"            "Prionace glauca"               
#> [131] "Pseudocaranx dentex"            "Pterois miles"                 
#> [133] "Pteroplatytrygon violacea"      "Raja asterias"                 
#> [135] "Raja brachyura"                 "Raja clavata"                  
#> [137] "Raja microocellata"             "Raja montagui"                 
#> [139] "Raja polystigma"                "Raja radula"                   
#> [141] "Raja undulata"                  "Range tag"                     
#> [143] "range test"                     "Range test"                    
#> [145] "Reference Tag D-2LP13"          "Reference Tag D-2LP9L"         
#> [147] "Rhinobatos rhinobatos"          "Rostroraja alba"               
#> [149] "Rutilus rutilus"                "Salmo salar"                   
#> [151] "Salmo salar/Salmo trutta"       "Salmo t. trutta"               
#> [153] "Salmo trutta"                   "Salmo trutta trutta"           
#> [155] "Salvelinus alpinus"             "Sander lucioperca"             
#> [157] "Sarpa salpa"                    "Scarus guacamaia"              
#> [159] "Scarus taeniopterus"            "Scarus vetula"                 
#> [161] "Sciaena umbra"                  "Scomber japonicus"             
#> [163] "Scomber scombrus"               "Scophthalmus maximus"          
#> [165] "Scorpaena notata"               "Scorpaena porcus"              
#> [167] "Scorpaena scrofa"               "Scyliorhinus canicula"         
#> [169] "Scyliorhinus stellaris"         "Scyllarides latus"             
#> [171] "Sensor tag"                     "Sepia officinalis"             
#> [173] "Seriola dumerili"               "Seriola rivoliana"             
#> [175] "Serranidae"                     "Serranus atricauda"            
#> [177] "Serranus cabrilla"              "Serranus scriba"               
#> [179] "Silurus glanis"                 "Solea senegalensis"            
#> [181] "Solea solea"                    "Somniosus microcephalus"       
#> [183] "Sparisoma"                      "Sparisoma cretense"            
#> [185] "Sparisoma rubripinne"           "Sparisoma viride"              
#> [187] "Sparus aurata"                  "Sphyraena barracuda"           
#> [189] "Sphyraena viridensis"           "Spicara smaris"                
#> [191] "Spondyliosoma cantharus"        "Squalius cephalus"             
#> [193] "Squalus acanthias"              "Symphodus bailloni"            
#> [195] "Symphodus melops"               "Symphodus ocellatus"           
#> [197] "Symphodus rostratus"            "Symphodus tinca"               
#> [199] "Sync tag"                       "Synctag R-HP16"                
#> [201] "Tetrapturus belone"             "Thunnus thynnus"               
#> [203] "Thymallus thymallus"            "Tinca tinca"                   
#> [205] "Torpedo (Torpedo)"              "Torpedo marmorata"             
#> [207] "Torpedo torpedo"                "Trachurus trachurus"           
#> [209] "Umbrina cirrosa"                "Vimba vimba"                   
#> [211] "Xyrichtys novacula"            
```
