dsmb_plan <- drake_plan(


  enrollment_data = read.csv(file_in(file.path("data", "enrollment.csv"))), #replace with your source data

  randomization_data = read.csv(file_in(file.path("data", "randomization.csv"))),

  followup_data = read.csv(file_in(file.path("data", "followup.csv"))),

  status_data = rbind(enrollment_data, randomization_data, followup_data),

  consort_table = build_consort_table(status_data),

  randomization_figure = plot_randomization(randomization_data),

  adverse_event_summary = summarize_adverse_event(dsmb_data),

  dsmb_report = rmarkdown::render(input = knitr_in(file.path("reports", "skeleton.rmd")),
                                  output = file_out(file.path("reports", "dsmb_report")))











)
