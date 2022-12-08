#' pega ano dos modelos dos carros da tabela fipe
#'
#' @param modelo modelo do carro
#' @param codigo_marca codigo_marca
#'
#' @return
#' @export
#'
#' @examples

pega_ano_modelo <- function(modelo, codigo_marca){

  fun_ano_modelo <- function(c_modelo = modelo,
                             c_codigo_marca = codigo_marca){
    url <-
      "https://veiculos.fipe.org.br/api/veiculos//ConsultarAnoModelo"

    # payload <-
    #   "codigoTipoVeiculo=1&codigoTabelaReferencia=292&codigoModelo=773&codigoMarca=22&ano=&codigoTipoCombustivel=&anoModelo=&modeloCodigoExterno="

    payload <- paste0("codigoTipoVeiculo=1",
                      "&codigoTabelaReferencia=",
                      pega_cod_ano() %>%
                        dplyr::slice(1) %>%
                        dplyr::pull(codigo),
                      "&codigoModelo=",
                      c_modelo,
                      "&codigoMarca=",
                      c_codigo_marca,
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

    ano_modelo <- httr::content(response, simplifyDataFrame = TRUE)

    ano_modelo %>%
      janitor::clean_names() %>%
      dplyr::mutate(cod_modelo = c_modelo,
             cod_marca = c_codigo_marca,
             ) %>%
      dplyr::rename(
        desc_motor = label,
        cod_motor = value
      ) %>%
      dplyr::mutate(
        ano_modelo = str_remove(cod_motor, "-.")
      )

  }

  purrr::map2_dfr(modelo, codigo_marca,
                  ~fun_ano_modelo(c_modelo = .x,
                                  c_codigo_marca = .y))

}

