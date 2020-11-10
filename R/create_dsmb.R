#' @export
create_dsmb <- function(path, init_packages = c("drake", "hsRd", "tidyverse", "DiagrammeR", "rmarkdown", "knitr",
                                                "flextable", "tableone", "webshot"),
                        init_renv = FALSE, init_rproj = TRUE, init_git = FALSE){


  project_skeleton(path, init_packages, init_rproj = init_rproj,
                   init_renv = init_renv, init_git = init_git)


  file.copy(from = system.file(file.path("drake_plans", "dsmb_plan.R"), package = "hsRd"),
            to = file.path(path, "R"))

  file.copy(from = system.file(file.path("drake_reports", "dsmb_report.Rmd"), package = "hsRd"),
            to = file.path(path, "reports"))

  file.copy(from = system.file(file.path("data", "enrollment.csv"), package = "hsRd"),
            to = file.path(path, "data"))

  file.copy(from = system.file(file.path("data", "randomization.csv"), package = "hsRd"),
            to = file.path(path, "data"))

  file.copy(from = system.file(file.path("data", "followup.csv"), package = "hsRd"),
            to = file.path(path, "data"))

  file.copy(from = system.file(file.path("data", "baseline.csv"), package = "hsRd"),
            to = file.path(path, "data"))

  file.copy(from = system.file(file.path("data", "adverse_event.csv"), package = "hsRd"),
            to = file.path(path, "data"))

  file.copy(from = system.file(file.path("data", "severe_adverse_event.csv"), package = "hsRd"),
            to = file.path(path, "data"))

  file.copy(from = system.file(file.path("rmarkdown", "reference_docs", "dsmb_reference.docx"), package = "hsRd"),
            to = file.path(path, "reports"))





}
