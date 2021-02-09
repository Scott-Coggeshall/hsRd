#' Create Project Skeleton Structure
#'
#' \code{project_skeleton} creates a project structure that's particularly useful for drake projects.
#'
#' @param project_path a character string containing the path where the project should be created.
#' @param init_packages a character vector containing names of packages that should be written to project's 'packages.R' file.
#' @param init_rproj a logical value indicating whether the created project should also be an Rstudio-style project. Default is \code{TRUE}.
#' @param init_git a logical value indicating whether the created project should also be tracked by git. Default is \code{TRUE}.
#' @param init_renv a logical value indicating whether the created project should use \code{renv} for package management. Default is \code{TRUE}.
#' @param init_report a character string indicating which of the report templates available in \code{hsRd} should be included in the project folder 'reports'.
#'   If \code{NULL} (the default), then no template is added.
#' @export
#' @details The folder path specified in \code{project_path} should be a path of directories ending in the name of the not-yet-existing folder that will contain
#'   the project. For instance, to create a project named \emph{my_analysis} inside the folder \emph{my_project} on the \emph{J} drive, you would specify
#'   \code{project_path = "J:/my_project/my_analysis"} in the call to \code{project_skeleton}. This function creates folders and files, so you must have write
#'   permissions within the directory that contains your project.
#' @return Returns \code{NULL} silently.
project_skeleton <- function(project_path, init_packages = c("drake", "tidyverse"), init_rproj = TRUE, init_git = TRUE, init_renv = TRUE, init_report = NULL){

  # don't overwrite existing directory
  if(dir.exists(project_path)) stop("This directory already exists!")

  # creating top level folder
  if(init_rproj){
    rstudioapi::initializeProject(project_path)
  } else{
    dir.create(project_path)
  }
  # git init
  if(init_git){
  system2(command = "git", args = c("init", shQuote(project_path)))

  # create gitignore
  cat(".drake\n.Rproj.user\n.Rhistory\n.RData\n.Ruserdata\n.DS_Store", file = file.path(project_path, ".gitignore"))

  }
  # set up R and data folders
  dir.create(file.path(project_path, "R"))

  dir.create(file.path(project_path, "data"))

  dir.create(file.path(project_path, "reports"))

  # add packages to packages.R and
  # source them in main.R
  cat(paste0("library('", init_packages, "')", collapse = "\n"),
      file = file.path(project_path, "R", "packages.R"))

  cat("source('R/packages.R')", file = file.path(project_path, "make.R"))

  # initiate renv

  if(init_renv) renv::scaffold(project_path)


  # initializing report

  if(!is.null(init_report)) file.copy(from = system.file(paste("rmarkdown/templates", init_report, "skeleton", sep = "/"), "skeleton.rmd", package = "hsRd"), to = file.path(project_path, "reports"))

  # make the initial commit
  if(init_git){
  system2(command = "git", args = c( "-C", shQuote(project_path), "add", "."))
  system2(command = "git", args = c("-C", shQuote(project_path), "commit","-am", '"init commit"'))
  }
}
