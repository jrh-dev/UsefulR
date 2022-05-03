#' Interactively select and read multiple filetypes using default options.
#'
#' @description Interactively select (utilising {file.choose()}) and read
#'  multiple filetypes using default options. The function reads the file
#'  and prints the function used to do so. The printed function can be
#'  used to replace the call to {read_it()} to be used in reproducible
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
read_it = function(...) {

    tar = file.choose()

    class(tar) = tolower(tools::file_ext(tar))

    UseMethod("read_it", tar)
}

#' @export
.clean_path = function(x) {

    return(gsub("\\\\", "/", x))

}

#' @export
read_it.csv = function(...) {

    constr = .clean_path(glue::glue('data.table::fread("{as.character(tar)}", keepLeadingZeros = TRUE)'))

    print("Replace {read_it} call with the following code for reproducibility;")
    print(noquote(constr))

    return(eval(parse(text = constr)))

}

#' @export
read_it.zip = function(...) {

    constr = .clean_path(glue::glue("data.table::fread('", 'unzip -p "{as.character(tar)}"', "', keepLeadingZeros = TRUE)"))

    print("Replace {read_it} call with the following code for reproducibility;")
    print(noquote(constr))

    return(eval(parse(text = constr)))

}

#' @export
read_it.rds = function(...) {

    constr = .clean_path(glue::glue('readRDS("{as.character(tar)}")'))

    print("Replace {read_it} call with the following code for reproducibility;")
    print(noquote(constr))

    return(eval(parse(text = constr)))

}

#' @export
read_it.xlsx = function(...) {

    constr = .clean_path(glue::glue('openxlsx::read.xlsx("{as.character(tar)}")'))

    print("Replace {read_it} call with the following code for reproducibility;")
    print(noquote(constr))

    return(eval(parse(text = constr)))

}
