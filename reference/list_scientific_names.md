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
#>  [87] "Lampetra fluviatilis"           "Leuciscus cephalus"            
#>  [89] "Leuciscus idus"                 "Lichia amia"                   
#>  [91] "Limanda limanda"                "Lithognathus mormyrus"         
#>  [93] "Liza aurata"                    "Liza ramada"                   
#>  [95] "Lota lota"                      "Lutjanus analis"               
#>  [97] "Lutjanus apodus"                "Lutjanus mahogoni"             
#>  [99] "Lutjanus synagris"              "Maja brachydactyla"            
#> [101] "Melanogrammus aeglefinus"       "Merlangius merlangus"          
#> [103] "Merluccius merluccius"          "Microstomus kitt"              
#> [105] "Mola mola"                      "Mugil"                         
#> [107] "Mullus surmuletus"              "Muraena helena"                
#> [109] "Mustelus"                       "Mustelus asterias"             
#> [111] "Mustelus mustelus"              "Mycteroperca bonaci"           
#> [113] "Mycteroperca rubra"             "Myliobatis aquila"             
#> [115] "Myoxocephalus scorpius"         "Oblada melanurus"              
#> [117] "Octopus vulgaris"               "Ocyurus chrysurus"             
#> [119] "Oncorhynchus mykiss"            "Osmerus eperlanus"             
#> [121] "Pagellus bogaraveo"             "Pagellus erythrinus"           
#> [123] "Pagrus pagrus"                  "Palinurus elephas"             
#> [125] "Parablennius gattorugine"       "Perca fluviatilis"             
#> [127] "Petromyzon marinus"             "Plastic"                       
#> [129] "Platichthys flesus"             "Pleuronectes platessa"         
#> [131] "Pollachius pollachius"          "Pollachius virens"             
#> [133] "Pomadasys incisus"              "Pomatomus saltatrix"           
#> [135] "Prionace glauca"                "Pseudocaranx dentex"           
#> [137] "Pterois miles"                  "Pteroplatytrygon violacea"     
#> [139] "Raja asterias"                  "Raja brachyura"                
#> [141] "Raja clavata"                   "Raja microocellata"            
#> [143] "Raja montagui"                  "Raja polystigma"               
#> [145] "Raja radula"                    "Raja undulata"                 
#> [147] "Range tag"                      "range test"                    
#> [149] "Range test"                     "Reference Tag D-2LP13"         
#> [151] "Reference Tag D-2LP9L"          "Rhinobatos rhinobatos"         
#> [153] "Rostroraja alba"                "Rutilus rutilus"               
#> [155] "Salmo salar"                    "Salmo salar/Salmo trutta"      
#> [157] "Salmo t. trutta"                "Salmo trutta"                  
#> [159] "Salmo trutta trutta"            "Salvelinus alpinus"            
#> [161] "Sander lucioperca"              "Sarpa salpa"                   
#> [163] "Scarus guacamaia"               "Scarus taeniopterus"           
#> [165] "Scarus vetula"                  "Sciaena umbra"                 
#> [167] "Scomber japonicus"              "Scomber scombrus"              
#> [169] "Scophthalmus maximus"           "Scorpaena notata"              
#> [171] "Scorpaena porcus"               "Scorpaena scrofa"              
#> [173] "Scyliorhinus canicula"          "Scyliorhinus stellaris"        
#> [175] "Scyllarides latus"              "Sensor tag"                    
#> [177] "Sepia officinalis"              "Seriola dumerili"              
#> [179] "Seriola rivoliana"              "Serranidae"                    
#> [181] "Serranus atricauda"             "Serranus cabrilla"             
#> [183] "Serranus scriba"                "Silurus glanis"                
#> [185] "Solea senegalensis"             "Solea solea"                   
#> [187] "Somniosus microcephalus"        "Sparisoma"                     
#> [189] "Sparisoma cretense"             "Sparisoma rubripinne"          
#> [191] "Sparisoma viride"               "Sparus aurata"                 
#> [193] "Sphyraena barracuda"            "Sphyraena viridensis"          
#> [195] "Spicara smaris"                 "Spondyliosoma cantharus"       
#> [197] "Squalius cephalus"              "Squalus acanthias"             
#> [199] "Symphodus bailloni"             "Symphodus melops"              
#> [201] "Symphodus ocellatus"            "Symphodus rostratus"           
#> [203] "Symphodus tinca"                "Sync tag"                      
#> [205] "Synctag R-HP16"                 "Tetrapturus belone"            
#> [207] "Thunnus thynnus"                "Thymallus thymallus"           
#> [209] "Tinca tinca"                    "Torpedo (Torpedo)"             
#> [211] "Torpedo marmorata"              "Torpedo torpedo"               
#> [213] "Trachurus trachurus"            "Umbrina cirrosa"               
#> [215] "Vimba vimba"                    "Xyrichtys novacula"            
```
