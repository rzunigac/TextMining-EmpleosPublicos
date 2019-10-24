library(dplyr)
library(magrittr)
#install.packages("tidytext")

source("funciones.R", encoding="utf-8")

buscar_topico <- function(ldaModel, texto = 'ingeniero eléctrico'){
  # Se construye un microcorpus de 1 solo documento y se obtiene la matriz document term
  doc_id <- c(0)
  text <- texto
  consulta <- data.frame(doc_id, text )
  corpus_consulta <- tm::Corpus(tm::DataframeSource(consulta))
  # desactivamos los warnings de la funcion crear matriz y luego los activamos denuevo
  oldw <- getOption("warn")
  options(warn = -1)
  dtm_consulta <- CrearMatriz(corpus_consulta, type='DocumentTerm', weight='Tf')
  options(warn = oldw)
  
  # Extaigo los terminos finales y los guardo en un vector ej: ingeniero -> ingenier
  terminos <- dtm_consulta$dimnames$Terms
  
  # De la matriz beta, que tiene la probabilidad de cada topico, para cada termino, filtro los terminos que estoy buscando.
  # despues agrupo por topico y sumo la probabilidad de cada palabra, y ordeno los topicos de mayor a menor.
  topics_probabilities <- tidytext::tidy(ldaModel, matrix = "beta") %>%
    filter(term %in% terminos) %>%
    group_by(topic) %>%
    summarise(total = sum(beta)) %>%
    arrange(desc(total))
  
  # retorno el mas alto
  top <- topics_probabilities %>% select(topic) %>%head(1) %>% as.integer()
  
  return(top)
}

documentos_por_topico <- function(ldaModel, topico = 1){
  documentos_id <- tidytext::tidy(ldaModel, matrix = "gamma") %>%
    filter(topic == topico) %>%
    arrange(desc(gamma)) %>%
    head(10) %>%
    pull(document)
  
  return(documentos_id)
}



ldaOut_guardado <- readRDS('ldaOut.RDS')
corpus_guardado <- readRDS('corpus.RDS')

#Funciona Mal
topico <- buscar_topico(ldaOut_guardado, 'computación')
documentos <- documentos_por_topico(ldaOut_guardado, topico)
tm::inspect(corpus_guardado[documentos])

#Funciona Mal
topico <- buscar_topico(ldaOut_guardado, 'ingeniero electrónico')
documentos <- documentos_por_topico(ldaOut_guardado, topico)
tm::inspect(corpus_guardado[documentos])

#Funciona Bien
topico <- buscar_topico(ldaOut_guardado, 'abogado')
documentos <- documentos_por_topico(ldaOut_guardado, topico)
tm::inspect(corpus_guardado[documentos])

#Funciona Bien
topico <- buscar_topico(ldaOut_guardado, 'educadora de párvulos')
documentos <- documentos_por_topico(ldaOut_guardado, topico)
tm::inspect(corpus_guardado[documentos])
