
#' pega o codigo dos anos da api da tabela fipe
#'
#' @return
#' @export
#'
#' @examples

pega_cod_ano <- function(){
  url <-
    "https://veiculos.fipe.org.br/api/veiculos//ConsultarTabelaDeReferencia"

  payload <- ""

  encode <- "raw"

  response <-
    httr::VERB(
      "POST",
      url,
      body = payload,
      add_headers(
        authority = 'veiculos.fipe.org.br',
        accept_language = 'pt-BR,pt;q=0.9,en;q=0.8',
        content_length = '0',
        origin = 'https://veiculos.fipe.org.br',
        referer = 'https://veiculos.fipe.org.br/',
        user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36'
      ),
      content_type("application/octet-stream"),
      accept("application/json, text/javascript, */*; q=0.01"),
      set_cookies(`ASP.NET_SessionId` = "v5jlch5rapx3dj3kxx1anuh2", `ROUTEID` = ".5"),
      encode = encode
    )

  tabela_ano <- httr::content(response, simplifyDataframe = TRUE) %>%
    tibble::enframe() %>%
    tidyr::unnest_wider(value) %>%
    dplyr::select(-1) %>%
    janitor::clean_names()

  tabela_ano
}




