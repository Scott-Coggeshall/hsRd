#' @export
#' @importFrom magrittr %>%
make_non_serious_AE_table <- function(df_adverse_event, df_randomization,
                                      title = "Non-Serious AEs") {

  df <- tibble(body_system = c("Overall", unique(df_adverse_event$body_system)))
  n_patients <- df_adverse_event %>%
    distinct(id, body_system) %>%
    group_by(body_system) %>%
    summarise(`N` = n(), .groups = "drop")
  n_patients <- rbind(n_patients, c("Overall", sum(n_patients$`N`)))

  tot_rand <- df_randomization %>% nrow()
  df2 <- inner_join(df, n_patients, by = "body_system") %>%
    mutate(`N` = as.integer(`N`),
           `%` = (`N` / tot_rand * 100) %>% round(1))

  n_events <- df_adverse_event %>%
    group_by(body_system) %>%
    summarise(`n` = n(), .groups = "drop")
  n_events <- rbind(n_events, c("Overall", sum(n_events$`n`)))
  df3 <- inner_join(df2, n_events, by = "body_system") %>%
    rename(`Body System` = body_system)

  part_string <- paste0("Participants (N = ", tot_rand, ")")
  table_header_refs <- data.frame(col_keys = colnames(df3),
                                  top = c(colnames(df3)[1],
                                          rep(part_string, 2),
                                          rep("Events", 1)),
                                  bottom = colnames(df3))
  flex_table <- flextable(df3) %>%
    set_header_df(mapping = table_header_refs, key = "col_keys") %>%
    merge_h(part = "header") %>%
    merge_v(part = "header") %>%
    theme_booktabs() %>%
    fix_border_issues() %>%
    add_header_lines(title) %>%
    align(part = "header", i = 1, align = "center") %>%
    width(j = 2:3, width = c(1,1)) %>%
    align(j = 4, align = "right", part = "all") %>%
    footnote(i = 3, j = 2:4,
             value = as_paragraph(c("Number of participants with at least one non-serious AE (participant may have multiple non serious AEs)",
                                    "% of total number of participants randomized.",
                                    "Number of non-serious AE events")),
             ref_symbols = c("*", "+", "^"),
             part = "header")

  l_ouput <- list(df = df3, flex_table = flex_table)
  return(l_output)
}
