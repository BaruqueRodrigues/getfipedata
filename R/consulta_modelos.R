#' consulta os modelos disponiveis por marca da tabela fipe
#'
#' @param marca código da marca importada pela fun pega_marcas
#'
#' @return
#' @export
#'
#' @examples
#'
consulta_modelos <- function(marca){
  future::plan(future::multisession,workers = parallel::detectCores())
  funcao_pega_modelos<- function(marca_declarada = 22){



    url <- "https://veiculos.fipe.org.br/api/veiculos//ConsultarModelos"

    # payload <-
    #   "codigoTipoVeiculo=1&codigoTabelaReferencia=292&codigoModelo=&codigoMarca=22&ano=&codigoTipoCombustivel=&anoModelo=&modeloCodigoExterno="

    payload <- paste0("codigoTipoVeiculo=1&codigoTabelaReferencia=",
                      pega_cod_ano() %>%
                        dplyr::slice(1) %>%
                        dplyr::pull(codigo),
                      "&codigoModelo=&codigoMarca=",
                      marca_declarada,
                      "&ano=&codigoTipoCombustivel=&anoModelo=&modeloCodigoExterno="
    )

    encode <- "form"

    response <-
      httr::VERB(
        "POST",
        url,
        body = payload,
        httr::add_headers(
          authority = 'veiculos.fipe.org.br',
          accept_language = 'pt-BR,pt;q=0.9,en;q=0.8',
          origin = 'https://veiculos.fipe.org.br',
          referer = 'https://veiculos.fipe.org.br/',

          user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36'
        ),
        httr::content_type("application/x-www-form-urlencoded"),
        httr::accept("application/json, text/javascript, */*; q=0.01"),
        httr::set_cookies(`ASP.NET_SessionId` = "v5jlch5rapx3dj3kxx1anuh2", `ROUTEID` = ".5"),
        encode = encode
      )

    df_veiculos <- httr::content(response, simplifyDataFrame = TRUE) %>%
      purrr::pluck(1) %>%
      dplyr::tibble() %>%
      dplyr::mutate(cod_marca = marca_declarada) %>%
      dplyr::tibble() %>%
      janitor::clean_names() %>%
      dplyr::rename(modelo = label,
             cod_modelo = value)

    df_veiculos
  }

  df_veic<- furrr::future_map_dfr(marca, ~funcao_pega_modelos(
                  marca_declarada = .x
  ))


  df_veic %>%
    janitor::clean_names() %>%
    dplyr::left_join(pega_ano_modelo(modelo = df_veic$cod_modelo,
                              codigo_marca = df_veic$cod_marca))
}




