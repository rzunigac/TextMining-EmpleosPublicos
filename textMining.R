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

#datos_empleos <- cargar_csv_as_tibble()
#saveRDS(datos_empleos, 'df_EmpleosPublicos.RDS')

datos_empleos <- readRDS('df_EmpleosPublicos.RDS')

df_corpus <- datos_empleos %>%
  #filter(doc_id > 0 & doc_id < 5500) %>%
  mutate(text = paste(Cargo, 
                      if_else(is.na(Objetivo_del_cargo), "", Objetivo_del_cargo),
                      Area_de_trabajo,
                      sep = " "
                      )
         ) %>%
  select(doc_id, text) %>%
  as.data.frame()

#Este corpus ya es fijo, se podría almacenar en RDS para no estarlo computando cada vez
corpus <- tm::Corpus(tm::DataframeSource(df_corpus))

#tm::inspect(corpus[30149])
#tm::inspect(tm::tm_map(corpus[30149], tm::removePunctuation))
#tm::inspect(corpus[1:2])
#NLP::meta(corpus[[2]], "text")

# Crear Matriz
dtm <- CrearMatriz(corpus, type='DocumentTerm', weight='Tf')

#dtm[,30149]
#tm::inspect(dtm[,30149])
#tm::inspect(corpus[38611])
#View(dtm$dimnames$Terms)

###########################
### LDA 
###########################

#rm(list = c('datos_empleos', 'df_corpus', 'corpus'))

burnin <- 4000
iter <- 2000
thin <- 500
seed <-list(2003,5,63,100001,765)
nstart <- 5
best <- TRUE

NumTopicos <- 20

t <- proc.time()
MatrizDatos <- as.matrix(dtm)
# Generar el modelo de topicos usando LDA con muestreo basado en m?todo de Gibbs
ldaOut <-topicmodels::LDA(dtm,k=NumTopicos,method ="Gibbs",control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))
proc.time() - t

#rm(list = c('ldaOut'))

#obtengo el numero del termino
term[1] <- match(c('gestion'),ldaOut@terms)
term[2] <- match(c('control'),ldaOut@terms)
term[3] <- match(c('institucional'),ldaOut@terms)

ldaOut@gamma[c(7,3,8),] %>% colSums()
topicmodels::topics(ldaOut, 10)[,c(7,3,8)]


topicos <- topicmodels::topics(ldaOut, 10)
terminos <- topicmodels::terms(ldaOut, 10)

View(ldaOut@terms)
View(topicos)
View(terminos)

View(ldaOut@gamma)

rowTotals <- apply(dtm , 1, sum)
View(rowTotals)






