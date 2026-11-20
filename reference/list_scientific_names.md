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
#>  [33] "Chelidonichthys cuculus"        "Chelidonichthys lucerna"       
#>  [35] "Chelon labrosus"                "Chelon ramada"                 
#>  [37] "Chelon saliens"                 "Chondrostoma nasus"            
#>  [39] "Chromis chromis"                "Clupea harengus"               
#>  [41] "Conger conger"                  "Coregonus lavaretus"           
#>  [43] "Coregonus lavaretus oxyrinchus" "Coregonus oxyrinchus"          
#>  [45] "Coris julis"                    "Coryphaena hippurus"           
#>  [47] "Cyclopterus lumpus"             "Cyprinus carpio"               
#>  [49] "Dactylopterus volitans"         "Dasyatis"                      
#>  [51] "Dasyatis pastinaca"             "Dentex dentex"                 
#>  [53] "Dicentrarchus labrax"           "Diplodus cervinus"             
#>  [55] "Diplodus puntazzo"              "Diplodus sargus"               
#>  [57] "Diplodus vulgaris"              "Dipturus intermedius"          
#>  [59] "Epinephelus costae"             "Epinephelus guttatus"          
#>  [61] "Epinephelus marginatus"         "Epinephelus striatus"          
#>  [63] "Eriocheir sinensis"             "Eriphia verrucosa"             
#>  [65] "Esox lucius"                    "Gadus morhua"                  
#>  [67] "Galeorhinus galeus"             "Glaucostegus cemiculus"        
#>  [69] "Gobius cruentatus"              "Gymnura altavela"              
#>  [71] "Haemulon"                       "Haemulon carbonarium"          
#>  [73] "Haemulon parra"                 "Haemulon plumierii"            
#>  [75] "Haemulon sciurus"               "Helicolenus dactylopterus"     
#>  [77] "Hexanchus griseus"              "Holocentrus"                   
#>  [79] "Homarus gammarus"               "Homo sapiens sapiens"          
#>  [81] "Huso huso"                      "Isurus oxyrinchus"             
#>  [83] "Labrus bergylta"                "Labrus mixtus"                 
#>  [85] "Lachnolaimus maximus"           "Lamna nasus"                   
#>  [87] "Lampetra fluviatilis"           "Leuciscus aspius"              
#>  [89] "Leuciscus cephalus"             "Leuciscus idus"                
#>  [91] "Lichia amia"                    "Limanda limanda"               
#>  [93] "Lithognathus mormyrus"          "Liza aurata"                   
#>  [95] "Liza ramada"                    "Lota lota"                     
#>  [97] "Lutjanus analis"                "Lutjanus apodus"               
#>  [99] "Lutjanus mahogoni"              "Lutjanus synagris"             
#> [101] "Maja brachydactyla"             "Melanogrammus aeglefinus"      
#> [103] "Merlangius merlangus"           "Merluccius merluccius"         
#> [105] "Microstomus kitt"               "Mola mola"                     
#> [107] "Mugil"                          "Mullus surmuletus"             
#> [109] "Muraena helena"                 "Mustelus"                      
#> [111] "Mustelus asterias"              "Mustelus mustelus"             
#> [113] "Mycteroperca bonaci"            "Mycteroperca rubra"            
#> [115] "Myliobatis aquila"              "Myoxocephalus scorpius"        
#> [117] "Oblada melanurus"               "Octopus vulgaris"              
#> [119] "Ocyurus chrysurus"              "Oncorhynchus mykiss"           
#> [121] "Osmerus eperlanus"              "Pagellus bogaraveo"            
#> [123] "Pagellus erythrinus"            "Pagrus pagrus"                 
#> [125] "Palinurus elephas"              "Parablennius gattorugine"      
#> [127] "Perca fluviatilis"              "Petromyzon marinus"            
#> [129] "Plastic"                        "Platichthys flesus"            
#> [131] "Pleuronectes platessa"          "Pollachius pollachius"         
#> [133] "Pollachius virens"              "Pomadasys incisus"             
#> [135] "Pomatomus saltatrix"            "Prionace glauca"               
#> [137] "Pseudocaranx dentex"            "Pterois miles"                 
#> [139] "Pteroplatytrygon violacea"      "Raja asterias"                 
#> [141] "Raja brachyura"                 "Raja clavata"                  
#> [143] "Raja microocellata"             "Raja montagui"                 
#> [145] "Raja polystigma"                "Raja radula"                   
#> [147] "Raja undulata"                  "Range tag"                     
#> [149] "range test"                     "Range test"                    
#> [151] "Reference Tag D-2LP13"          "Reference Tag D-2LP9L"         
#> [153] "Rhinobatos rhinobatos"          "Rostroraja alba"               
#> [155] "Rutilus rutilus"                "Salmo salar"                   
#> [157] "Salmo salar/Salmo trutta"       "Salmo t. trutta"               
#> [159] "Salmo trutta"                   "Salmo trutta trutta"           
#> [161] "Salvelinus alpinus"             "Sander lucioperca"             
#> [163] "Sarpa salpa"                    "Scarus guacamaia"              
#> [165] "Scarus taeniopterus"            "Scarus vetula"                 
#> [167] "Sciaena umbra"                  "Scomber japonicus"             
#> [169] "Scomber scombrus"               "Scophthalmus maximus"          
#> [171] "Scorpaena notata"               "Scorpaena porcus"              
#> [173] "Scorpaena scrofa"               "Scyliorhinus canicula"         
#> [175] "Scyliorhinus stellaris"         "Scyllarides latus"             
#> [177] "Sensor tag"                     "Sepia officinalis"             
#> [179] "Seriola dumerili"               "Seriola rivoliana"             
#> [181] "Serranidae"                     "Serranus atricauda"            
#> [183] "Serranus cabrilla"              "Serranus scriba"               
#> [185] "Silurus glanis"                 "Solea senegalensis"            
#> [187] "Solea solea"                    "Somniosus microcephalus"       
#> [189] "Sparisoma"                      "Sparisoma cretense"            
#> [191] "Sparisoma rubripinne"           "Sparisoma viride"              
#> [193] "Sparus aurata"                  "Sphyraena barracuda"           
#> [195] "Sphyraena viridensis"           "Spicara smaris"                
#> [197] "Spondyliosoma cantharus"        "Squalius cephalus"             
#> [199] "Squalus acanthias"              "Symphodus bailloni"            
#> [201] "Symphodus melops"               "Symphodus ocellatus"           
#> [203] "Symphodus rostratus"            "Symphodus tinca"               
#> [205] "Sync tag"                       "Synctag R-HP16"                
#> [207] "Tetrapturus belone"             "Thunnus thynnus"               
#> [209] "Thymallus thymallus"            "Tinca tinca"                   
#> [211] "Torpedo (Torpedo)"              "Torpedo marmorata"             
#> [213] "Torpedo torpedo"                "Trachurus trachurus"           
#> [215] "Umbrina cirrosa"                "Vimba vimba"                   
#> [217] "Xyrichtys novacula"            
```
