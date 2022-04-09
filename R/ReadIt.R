#' Interactively select and read multiple filetypes using default options.
#' 
#' @description Interactively select (utilising {file.choose()}) and read
#'  multiple filetypes using default options. The function reads the file
#'  and prints the function used to do so. The printed function can be
#'  used to replace the call to {ReadIt()} to be used in reproducible
#'  code.
#' 
#' @importFrom tools file_ext
#' @importFrom glue glue
#' @importFrom data.table fread
#' @importFrom openxlsx read.xlsx
#' 
#' @param ... further arguments to be passed.
#' 
#' @return a data.frame containing the data which has been read.
#' 
#' @export
ReadIt = function(...) {

    tar = file.choose()

    class(tar) = tolower(tools::file_ext(tar))

    UseMethod("ReadIt", tar)
}

ReadIt.csv = function(...) {

    constr = glue::glue('data.table::fread("{as.character(tar)}", keepLeadingZeros = TRUE)')

    print("Replace {ReadIt} call with the following code for reproducibility;")
    print(noquote(constr))

    return(eval(parse(text = constr)))

}

ReadIt.zip = function(...) {

    constr = glue::glue("data.table::fread('", 'unzip -p "{as.character(tar)}"', "', keepLeadingZeros = TRUE)")

    print("Replace {ReadIt} call with the following code for reproducibility;")
    print(noquote(constr))

    return(eval(parse(text = constr)))

}

ReadIt.rds = function(...) {

    constr = glue::glue('readRDS("{as.character(tar)}")')

    print("Replace {ReadIt} call with the following code for reproducibility;")
    print(noquote(constr))

    return(eval(parse(text = constr)))

}

ReadIt.xlsx = function(...) {

    constr = glue::glue('openxlsx::read.xlsx("{as.character(tar)}")')

    print("Replace {ReadIt} call with the following code for reproducibility;")
    print(noquote(constr))

    return(eval(parse(text = constr)))

}
