Archivo textMining.R

En este archivo se procesa los datos entregados y se generan los modelos, a continuación se describe el proceso realizado.

1) Limpieza de los datos
En primer lugar se limpia el archivo CSV, se crea la función cargar_csv_as_tibble(), en la que se modifican algunos nombres de columnas que presentan errores de codificación. Adempas se utiliza la función corregir_textos() para la corrección de los textos de cada columna.

La función corregir_textos() identifica y "marca" errores comunes de codificación de caracteres asociados a vocales con tilde, la letra ñ y non-breaking space, luego se eliminan todos los caracteres no ascii de los textos, finalmente se regeneran los caracteres marcados inicialmente (vocales con tilde, ñ y non-breaking space).

2) Creación del Corpus
Con el dataframe generado en el paso 1) se genera el corpus de documentos. Para esto se concatenan los campos Cargo, Objetivo del Cargo y Area de Trabajo. Se eliminan los registros NA. Con el dataframe resultante se genera un objeto del tipo corpus.

3) Procesados del corpus y creación de matriz de documentos
Se utiliza la función CrearMatriz, se realiza los siguientes pasos:
  - Se eliminan URLs mediante expresiones regulares.
- Se eliminan numeros mediante tm::removeNumbers.
- Se eliminan elementos de puntuación.
- Se eliminan stopwords del idioma español.
- Se eliminan meses (enero, febrero, etc.) a partir de una lista csv.
- Se eliminan regiones, provincias y comunas a partir de una lista csv.
- Se realiza el steming de los terminos

Finalmente se genera la matriz.

4) Creación del Modelo LDA
Para este modelo, en el paso anterior se genera una matrz de Docmentos/Terminos con pesos TF. Y se genera un modelo LDA con el método de Gibbs, utilizando los mismos parametros utsados en clases.
Inicialmente se crea un modelo con 30 tópicos, el cual entrega resultados deficientes segun las pruebas realizadas. Luego se crea un módelo con 100 tópicos el cual funciona mejor para algunas busquedas y pero para otras sigue entregando resultados poco útiles.

Debido al alto tiempo que tarda la generación de los modelos no fue posible experimentar con otras cantidades de tópicos.


Archivo modeloLDA.R

El modelo generado es probado con algunas búsquedas. 
Se utilizan 2 funciones:
  1) buscar_topico(): a partir de un modelo LDA y un string de busqueda dado, procesa el string tal como se procesó el corpus original, para obtener las palabras que debieran buscarse en el modelo (filtradas y con stemming). Luego se obtiene la probabilidad de cada tópico para cada uno de los terminos buscados. Se suman las probabilidades de cada termino por cada uno de los tópicos, obteniendo una lista de topicos para la busqueda completa. Finalmente se retorna el topico con el valor más alto.

2) documentos_por_topico(): Dado el modelo y el topico, se retorna los IDs de los 10 documentos principales asociados a dicho tópico.

Finalmente se utiliza la función tm::inspect() para filtrar el corpus a partir de los id obtenidos. 