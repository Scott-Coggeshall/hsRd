dsmb_plan <- drake_plan(

  dsmb_data = read.csv(file_in("data/dsmb.csv")), #replace with your source data

  enrollment_summary = summarize_enrollment(dsmb_data),

  adverse_event_summary = summarize_adverse_event(dsmb_data),

  dsmb_report = rmarkdown::render(input = knitr_in(file.path("reports", "skeleton.rmd")),
                                  output = file_out(file.path("reports", "dsmb_report")))











)
