#' baixa os dados da tabela fipe
#'
#' @param dataset_com_modelos dataset importando os modelos usar a fun consulta_modelos()
#'
#' @return
#' @export
#'
#' @examples

pega_tabela_fipe<- function(dataset_com_modelos){

  tabela_fipe <- function(cod_marca,
                          cod_modelo,
                          ano_modelo,
                          ...){
    url <-
      "https://veiculos.fipe.org.br/api/veiculos//ConsultarValorComTodosParametros"

    # payload <-
    #   "codigoTabelaReferencia=1&codigoMarca=21&codigoModelo=437&codigoTipoVeiculo=1&anoModelo=1987&codigoTipoCombustivel=1&tipoVeiculo=carro&modeloCodigoExterno=&tipoConsulta=tradicional"

    payload <- paste0("codigoTabelaReferencia=",
                      pega_cod_ano() %>%
                        dplyr::slice(1) %>%
                        dplyr::pull(codigo),
                      "&codigoMarca=",
                      cod_marca,
                      "&codigoModelo=",
                      cod_modelo,
                      "&codigoTipoVeiculo=1&anoModelo=",
                      ano_modelo,
                      "&codigoTipoCombustivel=1&tipoVeiculo=carro&modeloCodigoExterno=&tipoConsulta=tradicional"
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
          referer = 'https://veiculos.fipe.org.br/'
        ),
        httr::content_type("application/x-www-form-urlencoded"),
        httr::accept("application/json, text/javascript, */*; q=0.01"),
        httr::set_cookies(`ASP.NET_SessionId` = "v5jlch5rapx3dj3kxx1anuh2", `ROUTEID` = ".5"),
        encode = encode
      )

    httr::content(response ) %>%
      tibble::enframe() %>%
      tidyr::pivot_wider(names_from = "name",
                         values_from = "value") %>%
      tidyr::unnest_longer(everything()) %>%
      janitor::clean_names()

  }


  purrr::pmap_dfr(dataset_com_modelos, tabela_fipe)

}


