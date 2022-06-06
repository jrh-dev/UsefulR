#' Attempts to set working directory to the location where the script
#'  containing the function call is saved.
#'
#' @description Attempts to set working directory to the location where 
#'  the script containing the function call is saved.
#'
#' @importFrom rstudioapi getActiveDocumentContext
#' @importFrom glue glue
#'
#' @param quietly when `FALSE` the outcome and working directory are
#'  printed.
#'
#' @export
set_dir <- function(quietly = FALSE){
    
    cur = getwd()
    
    try(setwd(dirname(parent.frame(2)$ofile)), silent = TRUE)
    
    try(setwd(dirname(rstudioapi::getActiveDocumentContext()$path)), silent = TRUE)
    
    set = getwd() == cur
    
    if (set & !quietly) {
        msg = glue::glue("Working dir unchanged @ {getwd()}")
    } else {
        msg = glue::glue("Working dir changed @ {getwd()}")
    }
    
    return(if(quietly) invisible() else print(msg)) 
}