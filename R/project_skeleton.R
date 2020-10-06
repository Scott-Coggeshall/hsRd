project_skeleton <- function(project_path, init_packages = c("drake", "tidyverse"), init_git = TRUE, init_renv = TRUE, init_report = NULL){

  # don't overwrite existing directory
  if(dir.exists(project_name)) stop("This directory already exists!")

  # creating top level folder
  dir.create(project_path)

  # git init
  system2(command = "git", args = c("init", project_path))

  # create gitignore
  cat(".drake", file = file.path(project_path, ".gitignore"))


  # set up R and data folders
  dir.create(file.path(project_path, "R"))

  dir.create(file.path(project_path, "data"))

  dir.create(file.path(project_path, "reports"))

  # add packages to packages.R and
  # source them in main.R
  cat(paste0("library('", init_packages, "')", collapse = "\n"),
      file = file.path(project_path, "R", "packages.R"))

  cat("source('R/packages.R')", file = file.path(project_path, "main.R"))

  # initiate renv

  renv::scaffold(project_path)


  # initializing report

  if(!is.null(init_report)) file.copy(from = system.file(paste("rmarkdown/templates", init_report, sep = "/"), "skeleton.rmd", package = "hsRd"), to = file.path(project_path, "reports"))

  # make the initial commit
  system2(command = "git", args = c( "-C", project_path, "add", "."))
  system2(command = "git", args = c("-C", project_path, "commit","-am", '"init commit"'))

}
