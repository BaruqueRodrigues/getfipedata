#' pega_marcas disponveis por titulo de veiculo na tabela fipe
#'
#' @param tipo_veiculo identificar o tipo de veiculo se 1, 2 ou 3
#'
#' @return
#' @export
#'
#' @examples

pega_marcas <- function(tipo_veiculo = 1){
  url <- "https://veiculos.fipe.org.br/api/veiculos//ConsultarMarcas"

  payload <- paste0("codigoTabelaReferencia=",
                    pega_cod_ano() %>%
                      dplyr::slice(1) %>%
                      dplyr::pull(codigo),
                    "&codigoTipoVeiculo=",
                    tipo_veiculo)

  encode <- "form"

  response <-
    VERB(
      "POST",
      url,
      body = payload,
      add_headers(
        authority = 'veiculos.fipe.org.br',
        accept_language = 'pt-BR,pt;q=0.9,en;q=0.8',
        origin = 'https://veiculos.fipe.org.br',
        referer = 'https://veiculos.fipe.org.br/',
        user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36'
      ),
      content_type("application/x-www-form-urlencoded"),
      accept("application/json, text/javascript, */*; q=0.01"),
      set_cookies(`ASP.NET_SessionId` = "v5jlch5rapx3dj3kxx1anuh2", `ROUTEID` = ".5"),
      encode = encode
    )

  marcas <- content(response, simplifyDataFrame = TRUE) %>%
    dplyr::tibble() %>%
    janitor::clean_names() %>%
    dplyr::rename(marca = label,
                  cod_marca = value)

  marcas
}

