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
    
    dirs <- c("config", "data", "logs", "R", "src", "tests")
    
    message("Creating dir structure...\n\n")
    
    lapply(dirs, function(x) {
        dir.create(file.path(parent, x))
        return(invisible())
        })
    
    message("Creating standard files...\n\n")
    
    files <- c("README.md", "run.R", ".gitignore", glue::glue("{name}.Rproj"))
    
    lapply(files, function(x) {
        file.create(file.path(parent, x))
        return(invisible())
        })
    
    message("Applying default configurations...\n\n")
    
    conf_rproj <- glue::glue(
        "Version: 1.0\n\n",
        "RestoreWorkspace: Default\n",
        "SaveWorkspace: Default\n",
        "AlwaysSaveHistory: Default\n\n",
        "EnableCodeIndexing: Yes\n",
        "UseSpacesForTab: Yes\n",
        "NumSpacesForTab: 4\n",
        "Encoding: UTF-8\n\n",
        "RnwWeave: Knitr\n",
        "LaTeX: pdfLaTeX"
    )
    
    writeLines(conf_rproj, glue::glue("{parent}/{name}.Rproj"))
    
    conf_gitig <- glue::glue(
        "# History files\n",
        ".Rhistory\n\n",
        "# Session Data files\n",
        ".RData\n\n",
        "# User-specific files\n",
        ".Ruserdata\n\n",
        "# RStudio files\n",
        ".Rproj.user\n\n",
        "# Project dirs\n",
        "data/**",
        "logs/**"
    )
    
    writeLines(conf_gitig, glue::glue("{parent}/.gitignore"))
    
    message("Initializing GIT...\n\n")
    if (use_git) try(system(glue::glue('git init "{parent}"')))
    
    message("Initializing renv...\n\n")
    if (use_renv) try({options(renv.consent = TRUE); renv::init(parent)})
    
    message(glue::glue("\n\nProject {name} created at {parent}/{name}"))
    
    return(invisible())
}
