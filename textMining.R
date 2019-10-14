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

source("funciones.R")

datos_empleos <- cargar_csv_as_tibble()

