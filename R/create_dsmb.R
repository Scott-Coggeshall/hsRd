create_dsmb <- function(path, init_packages = c("drake", "hsRd", "tidyverse", "DiagrammeR", "rmarkdown", "knitr"),
                        init_renv = TRUE, init_rproj = TRUE, init_git = FALSE){


  project_skeleton(path, init_packages, init_rproj = init_rproj,
                   init_renv = init_renv, init_git = init_git)


  file.copy(from = system.file(file.path("drake_plans", "dsmb_plan.R"), package = "hsRd"),
            to = file.path(path, "R"))

  file.copy(from = system.file(file.path("drake_reports", "dsmb_report.Rmd"), package = "hsRd"),
            to = file.path(path, "reports"))






}
