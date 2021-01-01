#' @export
#' @importFrom magrittr %>%
# uses data that looks like enrollment.csv
# convert site to factor and make it an ordered factor if you care about order of output
# convert date to datetime

make_recruit_retain_table <- function(df_enrollment, df_randomization, df_followup) {

  df <- tibble(Site = levels(df_enrollment$site))

  screened <- df_enrollment %>%
    filter(stage == "screening" & action == "screened") %>%
    group_by(site) %>%
    summarise(`Screened (N)` = n(), .groups = "drop") %>%
    rename(Site = site)
  ineligible <- df_enrollment %>%
    filter(stage == "screening" & action == "ineligible") %>%
    group_by(site) %>%
    summarise(ineligible = n(), .groups = "drop") %>%
    rename(Site = site)
  temp1 <- inner_join(screened, ineligible, by = "Site") %>%
    mutate(`Eligible (N)` = `Screened (N)` - ineligible) %>%
    dplyr::select(-ineligible)

  enrolled <- df_enrollment %>% # keep most recent enrollment status
    filter(stage == "enrollment") %>%
    group_by(id) %>%
    arrange(desc(date)) %>%
    filter(row_number() == 1) %>%
    ungroup() %>%
    group_by(site) %>%
    summarise(`Enrolled (N)` = n(), .groups = "drop") %>%
    rename(Site = site)
  temp2 <- inner_join(temp1, enrolled, by = "Site")

  randomized <- df_randomization %>%
    group_by(site) %>%
    summarise(`Randomized (N)` = n(), .groups = "drop") %>%
    rename(Site = site)
  temp3 <- inner_join(temp2, randomized, by = "Site")

  date_1st_rand <- df_randomization %>%
    group_by(site) %>%
    arrange(date) %>%
    slice(1) %>%
    dplyr::select(site, date) %>%
    rename(Site = site, `Date of First Randomization` = date)
  temp4 <- inner_join(temp3, date_1st_rand, by = "Site")

  followup_wide <- df_followup %>%
    dplyr::select(-stage) %>%
    pivot_wider(id_cols = c(id, site), names_from = action, values_from = date)
  active <- followup_wide %>%
    filter(!is.na(begin) & (is.na(end) & is.na(lost))) %>%
    group_by(site) %>%
    summarise(Active = n(), .groups = "drop") %>%
    rename(Site = site)
  complete <- followup_wide %>%
    filter(!is.na(begin) & !is.na(end)) %>%
    group_by(site) %>%
    summarise(`Follow-Up Complete` = n(), .groups = "drop") %>%
    rename(Site = site)
  lost <- followup_wide %>%
    filter(!is.na(begin) & !is.na(lost)) %>%
    group_by(site) %>%
    summarise(`Lost to Follow-Up` = n(), .groups = "drop") %>%
    rename(Site = site)
  table <- inner_join(temp4, active, by = "Site") %>%
    inner_join(complete, active, by = "Site") %>%
    inner_join(lost, active, by = "Site")

  table_header_refs <- data.frame(col_keys = colnames(table),
                                   top = c(colnames(table)[1:6], rep("Randomization Patient Status", 3)),
                                   bottom = colnames(table))
  flex_table <- flextable(table) %>%
    set_header_df(mapping = table_header_refs, key = "col_keys") %>%
    merge_h(part = "header") %>%
    merge_v(part = "header") %>%
    theme_booktabs() %>%
    fix_border_issues() %>%
    add_header_lines("Table 1: Recruitment and Retention") %>%
    align(part = "header", i = 1, align = "center")

  l_table <- list(df = table, flex_table = flex_table)
  return(l_table)
}

# # example
# df_enrollment <- enrollment %>%
#   mutate(site = factor(site),
#          date = as.Date(date))
# make_recruit_retain_table(pats_screened, pats_randomized)
