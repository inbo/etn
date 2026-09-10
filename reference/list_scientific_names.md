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
#>  [87] "Leuciscus idus"                 "Lichia amia"                   
#>  [89] "Limanda limanda"                "Lithognathus mormyrus"         
#>  [91] "Liza aurata"                    "Liza ramada"                   
#>  [93] "Lota lota"                      "Lutjanus analis"               
#>  [95] "Lutjanus apodus"                "Lutjanus mahogoni"             
#>  [97] "Lutjanus synagris"              "Maja brachydactyla"            
#>  [99] "Melanogrammus aeglefinus"       "Merlangius merlangus"          
#> [101] "Merluccius merluccius"          "Microstomus kitt"              
#> [103] "Mola mola"                      "Mugil"                         
#> [105] "Mullus surmuletus"              "Muraena helena"                
#> [107] "Mustelus"                       "Mustelus asterias"             
#> [109] "Mustelus mustelus"              "Mycteroperca bonaci"           
#> [111] "Mycteroperca rubra"             "Myliobatis aquila"             
#> [113] "Myoxocephalus scorpius"         "Oblada melanurus"              
#> [115] "Octopus vulgaris"               "Ocyurus chrysurus"             
#> [117] "Oncorhynchus mykiss"            "Osmerus eperlanus"             
#> [119] "Pagellus bogaraveo"             "Pagellus erythrinus"           
#> [121] "Pagrus pagrus"                  "Palinurus elephas"             
#> [123] "Parablennius gattorugine"       "Perca fluviatilis"             
#> [125] "Petromyzon marinus"             "Plastic"                       
#> [127] "Platichthys flesus"             "Pleuronectes platessa"         
#> [129] "Pollachius pollachius"          "Pollachius virens"             
#> [131] "Pomadasys incisus"              "Pomatomus saltatrix"           
#> [133] "Prionace glauca"                "Pseudocaranx dentex"           
#> [135] "Pterois miles"                  "Pteroplatytrygon violacea"     
#> [137] "Raja asterias"                  "Raja brachyura"                
#> [139] "Raja clavata"                   "Raja microocellata"            
#> [141] "Raja montagui"                  "Raja polystigma"               
#> [143] "Raja radula"                    "Raja undulata"                 
#> [145] "Range tag"                      "range test"                    
#> [147] "Range test"                     "Reference Tag D-2LP13"         
#> [149] "Reference Tag D-2LP9L"          "Rhinobatos rhinobatos"         
#> [151] "Rostroraja alba"                "Rutilus rutilus"               
#> [153] "Salmo salar"                    "Salmo salar/Salmo trutta"      
#> [155] "Salmo t. trutta"                "Salmo trutta"                  
#> [157] "Salmo trutta trutta"            "Salvelinus alpinus"            
#> [159] "Sander lucioperca"              "Sarpa salpa"                   
#> [161] "Scarus guacamaia"               "Scarus taeniopterus"           
#> [163] "Scarus vetula"                  "Sciaena umbra"                 
#> [165] "Scomber japonicus"              "Scomber scombrus"              
#> [167] "Scophthalmus maximus"           "Scorpaena notata"              
#> [169] "Scorpaena porcus"               "Scorpaena scrofa"              
#> [171] "Scyliorhinus canicula"          "Scyliorhinus stellaris"        
#> [173] "Scyllarides latus"              "Sensor tag"                    
#> [175] "Sepia officinalis"              "Seriola dumerili"              
#> [177] "Seriola rivoliana"              "Serranidae"                    
#> [179] "Serranus atricauda"             "Serranus cabrilla"             
#> [181] "Serranus scriba"                "Silurus glanis"                
#> [183] "Solea senegalensis"             "Solea solea"                   
#> [185] "Somniosus microcephalus"        "Sparisoma"                     
#> [187] "Sparisoma cretense"             "Sparisoma rubripinne"          
#> [189] "Sparisoma viride"               "Sparus aurata"                 
#> [191] "Sphyraena barracuda"            "Sphyraena viridensis"          
#> [193] "Spicara smaris"                 "Spondyliosoma cantharus"       
#> [195] "Squalius cephalus"              "Squalus acanthias"             
#> [197] "Symphodus bailloni"             "Symphodus melops"              
#> [199] "Symphodus ocellatus"            "Symphodus rostratus"           
#> [201] "Symphodus tinca"                "Sync tag"                      
#> [203] "Synctag R-HP16"                 "Tetrapturus belone"            
#> [205] "Thunnus thynnus"                "Thymallus thymallus"           
#> [207] "Tinca tinca"                    "Torpedo (Torpedo)"             
#> [209] "Torpedo marmorata"              "Torpedo torpedo"               
#> [211] "Trachurus trachurus"            "Umbrina cirrosa"               
#> [213] "Vimba vimba"                    "Xyrichtys novacula"            
```
