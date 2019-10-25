library(dplyr)
library(magrittr)

source("funciones.R", encoding="utf-8")

# 1) Limpieza de los datos
# Se genera una versión limpia de los datos, se almacena y se guarda para evitar reprocesar cada vez.
#datos_empleos <- cargar_csv_as_tibble()
#saveRDS(datos_empleos, 'df_EmpleosPublicos.RDS')

datos_empleos <- readRDS('df_EmpleosPublicos.RDS')

# 2) Creación del Corpus
df_corpus <- datos_empleos %>%
  #filter(doc_id > 0 & doc_id < 5500) %>%
  select(doc_id, Cargo, Objetivo_del_cargo, Area_de_trabajo) %>%
  filter(!rowSums(is.na(.)) >= 3) %>%
  mutate(text = paste(if_else(is.na(Cargo), "", Cargo), 
                      if_else(is.na(Objetivo_del_cargo), "", Objetivo_del_cargo),
                      if_else(is.na(Area_de_trabajo), "", Area_de_trabajo),
                      sep = " "
                      )
        ) %>%
  select(doc_id, text) %>%
  as.data.frame()

# 3) Procesados del corpus y creación de matriz de documentos
#Este corpus ya es fijo, se almacena en RDS para no estarlo computando cada vez
corpus <- tm::Corpus(tm::DataframeSource(df_corpus))
#saveRDS(corpus, 'corpus.RDS')

# Crear Matriz
dtm <- CrearMatriz(corpus, type='DocumentTerm', weight='Tf')

###########################
# 4) Creación del Modelo LDA 
###########################

burnin <- 4000
iter <- 2000
thin <- 500
seed <-list(2003,5,63,100001,765)
nstart <- 5
best <- TRUE

NumTopicos <- 100

t <- proc.time()
MatrizDatos <- as.matrix(dtm)
# Generar el modelo de topicos usando LDA con muestreo basado en m?todo de Gibbs
ldaOut <-topicmodels::LDA(dtm,k=NumTopicos,method ="Gibbs",control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))
proc.time() - t

#saveRDS(ldaOut, 'ldaOut100.RDS')





