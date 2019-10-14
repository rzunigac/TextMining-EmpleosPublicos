corregir_textos <- function(string){
  
  # Esta función corrige los errores principales de codificación de caracteres para la Ñ y las vocales con tilde.
  # Elimina todos los caracteres no ascii, con excepción de la Ñ y las vocales con tilde.
  # Para eso primero marcamos las letras especiales simbolos ascii ej: Ñ -> #Ñ$ 
  # luego convertimos de utf-8 a ascii y de vuelta a UTF-8, para eliminar caracteres.
  # finalemnte reconvertimos los caracteres especiales ej: #Ñ$ -> Ñ. 
  
  #####
  # PRIMERA PARTE: Homologamos vocales con tilde y sin tilde y la letra Ñ.
  #####
  Encoding(string) <- "UTF-8"
  
  string <- stringr::str_replace_all(string, "Ã\u0091|Ñ", "#N$")
  string <- stringr::str_replace_all(string, "Ã±|ñ", "#n$")
  
  string <- stringr::str_replace_all(string, "Ã\u0081|Á", "#A$")
  string <- stringr::str_replace_all(string, "Ã\u0089|É", "#E$")
  string <- stringr::str_replace_all(string, "Ã\u008d|Í", "#I$")
  string <- stringr::str_replace_all(string, "Ã\u0093|Ó", "#O$")
  string <- stringr::str_replace_all(string, "Ã\u009a|Ú", "#U$")
  
  string <- stringr::str_replace_all(string, "Ã¡|á", "#a$")
  string <- stringr::str_replace_all(string, "Ã©|é", "#e$")
  string <- stringr::str_replace_all(string, "Ã³|ó", "#o$")
  string <- stringr::str_replace_all(string, "Ãº|ú", "#u$")
  
  #La letra i con tilde queda al final porque el caracter que lo acompaña no lo pudimos filtrar aparte.
  string <- stringr::str_replace_all(string, "Ã|í", "#i$")
  
  # Se cambia el Non-breaking space por un espacio normal
  string <- stringr::str_replace_all(string, "\u00A0", " ")
  
  #####
  # SEGUNDA PARTE: Eliminamos caracteres no ascii
  #####
  string <- iconv(string, "utf-8", "ascii", sub="")
  string <- iconv(string, "ascii", "utf-8", sub="")

  #####
  # TERCERA PARTE: VOLVEMOS A GENERAR LAS VOCALES CON TILDE Y LA Ñ
  #####
  string <- stringr::str_replace_all(string, "#N\\$", "Ñ")
  string <- stringr::str_replace_all(string, "#n\\$", "ñ")

  string <- stringr::str_replace_all(string, "#A\\$", "Á")
  string <- stringr::str_replace_all(string, "#E\\$", "É")
  string <- stringr::str_replace_all(string, "#I\\$", "Í")
  string <- stringr::str_replace_all(string, "#O\\$", "Ó")
  string <- stringr::str_replace_all(string, "#U\\$", "Ú")

  string <- stringr::str_replace_all(string, "#a\\$", "á")
  string <- stringr::str_replace_all(string, "#e\\$", "é")
  string <- stringr::str_replace_all(string, "#i\\$", "í")
  string <- stringr::str_replace_all(string, "#o\\$", "ó")
  string <- stringr::str_replace_all(string, "#u\\$", "ú")
  
  # Si hay varios espacios se colapsan en uno solo
  string <- stringr::str_replace_all(string, "\\s+", " ")
  # Se eliminan datos basura encontrados en 13 registros
  string <- stringr::str_replace_all(string, "\\(function \\(\\) \\{.+\\}\\)\\(\\);", "")
  
  return(string)
}

cargar_csv_as_tibble <- function(file = 'df_EmpleoPublico.csv'){
  
  datos <- readr::read_csv(file)
  # Esto dice "Warning: 15 parsing failures." filo, no son tantos ¿?
  
  d <- datos %>%
    ## Filtros para hacer pruebas con menos datos
    #filter(grepl('Auxiliar de Servicios Generales', Cargo)) %>%
    #filter(grepl('COMPIN', Cargo)) %>%
    #filter(grepl('Profesional Evaluaci', Cargo)) %>%
    #filter(grepl('function', `Objetivo del Cargo`)) %>%
    ## Renombramos columnas que vamos a usar
    tibble::rownames_to_column("doc_id") %>%
    #filter(DOC_ID == 9) %>%
    rename(Institucion_Entidad = `InstituciÃ³n / Entidad`) %>%
    rename(Numero_de_vacantes = `NÂº de Vacantes`) %>%
    rename(Objetivo_del_cargo = `Objetivo del Cargo`) %>%
    rename(Region = `RegiÃ³n`) %>%
    rename(Tipo_de_vacante = `Tipo de Vacante`) %>%
    rename(Area_de_trabajo = `Ãrea de Trabajo`) %>%
    ## Limpiamos columnas con texto
    mutate(Cargo = corregir_textos(Cargo)) %>%
    mutate(Ciudad = corregir_textos(Ciudad)) %>%
    mutate(Institucion_Entidad = corregir_textos(Institucion_Entidad)) %>%
    mutate(Ministerio = corregir_textos(Ministerio)) %>%
    mutate(Objetivo_del_cargo = corregir_textos(Objetivo_del_cargo)) %>%
    mutate(Region = corregir_textos(Region)) %>%
    mutate(Tipo_de_vacante = corregir_textos(Tipo_de_vacante)) %>%
    mutate(Area_de_trabajo = corregir_textos(Area_de_trabajo)) %>%
    ## Eliminamos columnas que estan vacias
    select_if(~sum(!is.na(.)) > 0)
  
  return(d)
}








