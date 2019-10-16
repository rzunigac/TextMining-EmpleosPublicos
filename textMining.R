library(dplyr)
library(magrittr)

# Paso 1 cargar los datos los mejor posible 
#   (agregue una columna id para identificar cada documento.)
#   (No eliminé tildes y eso, en caso de que se use algo que los necesite, propio del español)
# Paso 2 pre procesar: 
#  a) eliminar lo que no sea necesario, parentesis (), guiones -, barras / , saltos de linea, etc.
#  b) mayusculas, minusculas, tildes?
# Paso 3 generar un vector con los datos que nos interesan. Yo juntaría cargo y objetivo.
# Paso 4

source("funciones.R", encoding="utf-8")

datos_empleos <- cargar_csv_as_tibble()

df_corpus <- datos_empleos %>%
  #filter(doc_id < 20) %>%
  mutate(text = paste(Cargo, 
                      if_else(is.na(Objetivo_del_cargo), "", Objetivo_del_cargo),
                      Area_de_trabajo,
                      sep = " "
                      )
         ) %>%
  select(doc_id, text) %>%
  as.data.frame()

corpus <- tm::Corpus(tm::DataframeSource(df_corpus))
#tm::inspect(corpus[1:2])
#NLP::meta(corpus[[1]], "id")

dtm <- CrearMatrizDocumentos(corpus, type='TermDocument', weight='Tf')




