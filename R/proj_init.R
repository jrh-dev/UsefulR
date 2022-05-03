#' Initialize a new project based on a standardized R framework
#' 
#' @description Initialize a new project based on a standardized R framework.
#'  Creates a project directory with structure; 
#'  
#'  ```
#'  supplied_name  
#'  ├── config
#'  ├── data
#'  ├── logs
#'  ├── R
#'  ├── src
#'  ├── tests
#'  ├── run.R
#'  ├── README.md
#'  ├── supplied_name.Rproj
#'  └── .gitignore
#'  ```
#'  
#' By default, Will also initialize the project using git & {renv}, with the 
#'  option to disable this functionality. 
#' 
#' @importFrom renv init
#' @importFrom utils data
#' @importFrom glue glue
#' @importFrom usethis use_testthat
#' 
#' @param name the name of the project.
#' @param dir the directory in which to create the project.
#' @param umask sets the umask to the specified value.
#' @param use_renv if `TRUE` initializes renv for the project.
#' @param use_git if `TRUE` initializes git for the project.
#' @param ... additional arguments.
#' 
#' @export 
proj_init <- function(name, dir, umask = "002", use_renv = TRUE, 
                      use_git = TRUE, ...) {
    
    Sys.umask(umask)
    
    parent <- glue::glue("{dir}/{name}")
    
    dir.create(parent)
    
    message("Creating dir structure...\n\n")
    dir.create(glue::glue("{parent}/config"))
    dir.create(glue::glue("{parent}/data"))
    dir.create(glue::glue("{parent}/logs"))
    dir.create(glue::glue("{parent}/R"))
    dir.create(glue::glue("{parent}/src"))
    dir.create(glue::glue("{parent}/tests"))
    
    message("Creating standard files...\n\n")
    file.create(glue::glue("{parent}/README.md"))
    file.create(glue::glue("{parent}/run.R"))
    file.create(glue::glue("{parent}/.gitignore"))
    file.create(glue::glue("{parent}/{name}.Rproj"))
    
    utils::data("default_rproj", package = "UsefulR", envir = environment())
    
    message("Applying default configurations...\n\n")
    
    Cont_rproj <- glue::glue(
        "Version: {default_rproj['Version']}\n\n",
        "RestoreWorkspace: {default_rproj['RestoreWorkspace']}\n",
        "SaveWorkspace: {default_rproj['SaveWorkspace']}\n",
        "AlwaysSaveHistory: {default_rproj['AlwaysSaveHistory']}\n\n",
        "EnableCodeIndexing: {default_rproj['EnableCodeIndexing']}\n",
        "UseSpacesForTab: {default_rproj['UseSpacesForTab']}\n",
        "NumSpacesForTab: {default_rproj['NumSpacesForTab']}\n",
        "Encoding: {default_rproj['Encoding']}\n\n",
        "RnwWeave: {default_rproj['RnwWeave']}\n",
        "LaTeX: {default_rproj['LaTeX']}",
    )
    
    writeLines(Cont_rproj, glue::glue("{parent}/{name}.Rproj"))
    
    cont_gitig <- glue::glue(
        "# History files\n",
        ".Rhistory\n\n",
        "# Session Data files\n",
        ".RData\n\n",
        "# User-specific files\n",
        ".Ruserdata\n\n",
        "# RStudio files\n",
        ".Rproj.user\n\n"
    )
    
    writeLines(cont_gitig, glue::glue("{parent}/.gitignore"))
    
    message("Initializing GIT...\n\n")
    if (use_git) try(system(glue::glue("git init {parent}")))
    
    message("Initializing renv...\n\n")
    if (use_renv) try(renv::init(glue::glue("{parent}")))
    
    message(glue::glue("\n\nProject {name} created at {parent}/{name}"))
    
    return(invisible())
}
