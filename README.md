
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Instalando o pacote

Como o pacote está apenas no github para baixar o pacote é necessário
usar a função abaixo

``` r
devtools::install_github("BaruqueRodrigues/getfipedata")
```

# Usando o pacote

O primeiro passo para utilizar é carregar o pacote.

``` r
library(getfipedata)
```

Em seguida pegamos o código do ano a ser consultado, possível pela
função abaixo

``` r
ano_modelos <- getfipedata::pega_cod_ano()

ano_modelos
#> # A tibble: 264 × 2
#>    codigo mes             
#>     <int> <chr>           
#>  1    292 "dezembro/2022 "
#>  2    291 "novembro/2022 "
#>  3    290 "outubro/2022 " 
#>  4    289 "setembro/2022 "
#>  5    288 "agosto/2022 "  
#>  6    287 "julho/2022 "   
#>  7    286 "junho/2022 "   
#>  8    285 "maio/2022 "    
#>  9    284 "abril/2022 "   
#> 10    283 "março/2022 "   
#> # … with 254 more rows
```

Use o código do mes desejado.

O passo seguinte é pegar o código das marcas dos carros. A partir do
código das marcas podemos construir o dataset dos modelos

``` r
marcas_carros <- pega_marcas()
marcas_carros
#> # A tibble: 92 × 2
#>    marca        cod_marca
#>    <chr>        <chr>    
#>  1 Acura        1        
#>  2 Agrale       2        
#>  3 Alfa Romeo   3        
#>  4 AM Gen       4        
#>  5 Asia Motors  5        
#>  6 ASTON MARTIN 189      
#>  7 Audi         6        
#>  8 Baby         207      
#>  9 BMW          7        
#> 10 BRM          8        
#> # … with 82 more rows
```

Agora usamos a função consulta modelos para indicar os modelos das
marcas que desejamos. Aqui vamos pegar todos os modelos da BMW
disponíveis na tabela fipe.

``` r
df_modelos <- consulta_modelos(7)
#> Joining, by = c("cod_modelo", "cod_marca")

df_modelos
#> # A tibble: 1,183 × 6
#>    modelo                          cod_modelo cod_marca desc_m…¹ cod_m…² ano_m…³
#>    <chr>                                <int>     <dbl> <chr>    <chr>   <chr>  
#>  1 116iA 1.6 TB 16V 136cv 5p             6146         7 2015 Ga… 2015-1  2015   
#>  2 116iA 1.6 TB 16V 136cv 5p             6146         7 2014 Ga… 2014-1  2014   
#>  3 116iA 1.6 TB 16V 136cv 5p             6146         7 2013 Ga… 2013-1  2013   
#>  4 116iA 1.6 TB 16V 136cv 5p             6146         7 2012 Ga… 2012-1  2012   
#>  5 118i M Sport 1.5 TB 12V Aut. 5p       9955         7 32000 G… 32000-1 32000  
#>  6 118i M Sport 1.5 TB 12V Aut. 5p       9955         7 2023 Ga… 2023-1  2023   
#>  7 118i Sport 1.5 TB 12V Aut. 5p         8946         7 32000 G… 32000-1 32000  
#>  8 118i Sport 1.5 TB 12V Aut. 5p         8946         7 2023 Ga… 2023-1  2023   
#>  9 118i Sport 1.5 TB 12V Aut. 5p         8946         7 2022 Ga… 2022-1  2022   
#> 10 118i Sport 1.5 TB 12V Aut. 5p         8946         7 2021 Ga… 2021-1  2021   
#> # … with 1,173 more rows, and abbreviated variable names ¹​desc_motor,
#> #   ²​cod_motor, ³​ano_modelo
```

A partir do dataset com os modelos de carros inserimos na função pega
tabela fipe, ele irá retornar o dataset abaixo.

``` r
tabela_fipe_bmw <- pega_tabela_fipe(df_modelos %>% 
                                      dplyr::slice(1:10))

tabela_fipe_bmw %>% 
  dplyr::glimpse()
#> Rows: 10
#> Columns: 11
#> $ valor             <chr> "R$ 84.480,00", "R$ 77.828,00", "R$ 72.620,00", "R$ …
#> $ marca             <chr> "BMW", "BMW", "BMW", "BMW", "BMW", "BMW", "BMW", "BM…
#> $ modelo            <chr> "116iA 1.6 TB 16V 136cv 5p", "116iA 1.6 TB 16V 136cv…
#> $ ano_modelo        <int> 2015, 2014, 2013, 2012, 32000, 2023, 32000, 2023, 20…
#> $ combustivel       <chr> "Gasolina", "Gasolina", "Gasolina", "Gasolina", "Gas…
#> $ codigo_fipe       <chr> "009171-5", "009171-5", "009171-5", "009171-5", "009…
#> $ mes_referencia    <chr> "dezembro de 2022 ", "dezembro de 2022 ", "dezembro …
#> $ autenticacao      <chr> "cb8vbz51gb2vt", "8rvj6bhv25rl", "6sslrg5mz5nc", "51…
#> $ tipo_veiculo      <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
#> $ sigla_combustivel <chr> "G", "G", "G", "G", "G", "G", "G", "G", "G", "G"
#> $ data_consulta     <chr> "quinta-feira, 8 de dezembro de 2022 20:34", "quinta…
```
