
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
#> # A tibble: 265 × 2
#>    codigo mes             
#>     <int> <chr>           
#>  1    293 "janeiro/2023 " 
#>  2    292 "dezembro/2022 "
#>  3    291 "novembro/2022 "
#>  4    290 "outubro/2022 " 
#>  5    289 "setembro/2022 "
#>  6    288 "agosto/2022 "  
#>  7    287 "julho/2022 "   
#>  8    286 "junho/2022 "   
#>  9    285 "maio/2022 "    
#> 10    284 "abril/2022 "   
#> # … with 255 more rows
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
df_modelos <- consulta_modelos(#Vamos indicar veículos da marca 7, ou seja BMW
                               marca = 7,
                               #Vamos indicar para que seja pego o ano mais recente.
                               cod_ano = ano_modelos %>% 
                                 dplyr::slice(1) %>% 
                                 dplyr::pull(codigo)
                               )
#> Joining, by = c("cod_modelo", "cod_marca")

df_modelos
#> # A tibble: 1,183 × 7
#>    modelo                        cod_m…¹ cod_m…² cod_ano desc_…³ cod_m…⁴ ano_m…⁵
#>    <chr>                           <int>   <dbl>   <int> <chr>   <chr>   <chr>  
#>  1 116iA 1.6 TB 16V 136cv 5p        6146       7     293 2015 G… 2015-1  2015   
#>  2 116iA 1.6 TB 16V 136cv 5p        6146       7     293 2014 G… 2014-1  2014   
#>  3 116iA 1.6 TB 16V 136cv 5p        6146       7     293 2013 G… 2013-1  2013   
#>  4 116iA 1.6 TB 16V 136cv 5p        6146       7     293 2012 G… 2012-1  2012   
#>  5 118i M Sport 1.5 TB 12V Aut.…    9955       7     293 32000 … 32000-1 32000  
#>  6 118i M Sport 1.5 TB 12V Aut.…    9955       7     293 2023 G… 2023-1  2023   
#>  7 118i Sport 1.5 TB 12V Aut. 5p    8946       7     293 32000 … 32000-1 32000  
#>  8 118i Sport 1.5 TB 12V Aut. 5p    8946       7     293 2023 G… 2023-1  2023   
#>  9 118i Sport 1.5 TB 12V Aut. 5p    8946       7     293 2022 G… 2022-1  2022   
#> 10 118i Sport 1.5 TB 12V Aut. 5p    8946       7     293 2021 G… 2021-1  2021   
#> # … with 1,173 more rows, and abbreviated variable names ¹​cod_modelo,
#> #   ²​cod_marca, ³​desc_motor, ⁴​cod_motor, ⁵​ano_modelo
```

A partir do dataset com os modelos de carros inserimos na função pega
tabela fipe, ele irá retornar o dataset abaixo.

``` r
tabela_fipe_bmw <- pega_tabela_fipe(
  # Aqui vamos selecionar dentro do dataset de modelos de carros todos o modelos
  # da família 320
  df_modelos %>%
  dplyr::filter(
    stringr::str_detect(
      modelo, 
      "320i|320iA|323Ci|323CiA|323i|323i/iA|323iA|323Ti|325i|325iA|325i/iA|328i|328ia|328i/iA"
      )
    )
)

tabela_fipe_bmw %>% 
  dplyr::arrange(modelo, ano_modelo) %>% 
  dplyr::glimpse()
#> Rows: 190
#> Columns: 11
#> $ valor             <chr> "R$ 12.723,00", "R$ 14.106,00", "R$ 16.007,00", "R$ …
#> $ marca             <chr> "BMW", "BMW", "BMW", "BMW", "BMW", "BMW", "BMW", "BM…
#> $ modelo            <chr> "320i", "320i", "320i", "320i", "320i", "320iA", "32…
#> $ ano_modelo        <int> 1991, 1992, 1993, 2006, 2007, 1991, 1992, 1993, 2001…
#> $ combustivel       <chr> "Gasolina", "Gasolina", "Gasolina", "Gasolina", "Gas…
#> $ codigo_fipe       <chr> "009038-7", "009038-7", "009038-7", "009038-7", "009…
#> $ mes_referencia    <chr> "janeiro de 2023 ", "janeiro de 2023 ", "janeiro de …
#> $ autenticacao      <chr> "g4hvsfn7n5p", "hnqjtg9xr8p", "jc0hfz7f7xp", "ztgk9c…
#> $ tipo_veiculo      <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ sigla_combustivel <chr> "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G…
#> $ data_consulta     <chr> "quarta-feira, 4 de janeiro de 2023 00:44", "quarta-…
```
