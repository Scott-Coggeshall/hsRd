dsmb_plan <- drake_plan(


  enrollment_data = read.csv(file_in("data/enrollment.csv")), #replace with your source data

  randomization_data = read.csv(file_in("data/randomization.csv")),

  followup_data = read.csv(file_in("data/followup.csv")),

  baseline_data = read.csv(file_in("data/baseline.csv")),

  status_data = rbind(enrollment_data, randomization_data, followup_data),

  consort_table = build_consort_table(status_data),

  consort_dot = create_consort_dot(consort_table),

  randomization_figure = plot_randomization(randomization_data),

  baseline_table = build_baseline_characteristics_table(baseline_data),

  dsmb_report = rmarkdown::render(input = knitr_in("reports/dsmb_report.rmd"),
                                  output_file = file_out("dsmb_report.docx"),
                                  output_dir = ".")











)
