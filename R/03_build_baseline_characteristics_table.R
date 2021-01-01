#' @export
#' @importFrom magrittr %>%
# takes data that looks like baseline.csv
#baseline <- read_csv("hsRd/data/baseline.csv")

# can make just an overall cohort table or split out into cohorts by treatment/site/etc...
# returns a list with a dataframe and a flextable object
make_baseline_characteristics_table <- function(data, vars = NULL, cohorts.col = NULL,
                                                cohorts.levels = NULL, col.names = NULL, var.names = NULL,
                                                title = "Table 3") {

  overall <- CreateTableOne(vars = vars,
                            data = data,
                            test = FALSE)
  overall_print <- print(overall, format = "p", printToggle = F)
  table1 <- data.frame(Var = dimnames(overall_print )[[1]],
                       Overall = unname(overall_print [, 1]),
                       stringsAsFactors = FALSE)

  # loop through each cohort and cbind to overall table1
  if(length(cohorts.levels) > 0) {

    # create separate table ones for each cohort and cbind to overall table
    for (i in 1:length(cohorts.levels)) {

      current_cohort <- data[data[[cohorts.col]] == cohorts.levels[i], ]
      table_current <- CreateTableOne(vars = vars,
                                      data = current_cohort,
                                      test = FALSE)
      table_current_print <- print(table_current, format = "p", printToggle = F)

      table1[[cohorts.levels[i]]] <- unname(table_current_print[, 1])
    }
  }

  # 3. Custom formatting

  # renaming columns
  table1 <- table1 %>%
    rename(" " = Var,
           `All Randomized` = Overall)
  if (length(col.names) > 0) {
    colnames(table1)[3:ncol(table1)] <- col.names
  }

  # renaming rows
  var_rows <- str_detect(table1$` `, "[()]") %>% which()
  if (length(var.names) > 0) {
    table1[[1]][var_rows] <- paste0(var.names, " ", str_extract(table1[[1]][var_rows], "\\(.*"))
  }

  # indent variable levels
  `%notin%` <- Negate(`%in%`)
  var_level_rows <- 1:nrow(table1) %notin% c(1, var_rows) %>% which()
  table1[var_level_rows, 1] <- paste0("    ", table1[var_level_rows, 1])

  flex_table <- flextable(table1) %>%
    width(j = 1, width = 2) %>%
    width(j = 2:ncol(table1), width = rep(1.2, ncol(table1) - 1)) %>%
    align(j = 1, align = "left") %>%
    align(j = 2:ncol(table1), align = "right", part = "all") %>%
    bold(i = c(1,var_rows), j = 1) %>%
    add_header_lines(title) %>%
    fontsize(size = 11, part = "all") %>%
    bold(part = "header", i = 2)

  l_table <- list(df = table1, flex_table = flex_table)
  return(l_table)
}

# two versions, one with just overall, another with stratification/cohort columns
# tb1 <- make_baseline_characteristics_table(data = baseline,
#                                            vars = c("Gender", "Age", "Race", "Rurality"),
#                                            var.names = c("Gender", "Age", "Race", "Rurality"),
#                                            title = "Table 3: Baseline Characteristics of Randomized Participants")
# tb2 <- make_baseline_characteristics_table(data = baseline,
#                                     vars = c("Gender", "Age", "Race", "Rurality"),
#                                     var.names = c("Gender", "Age", "Race", "Rurality"),
#                                     cohorts.col = "site",
#                                     cohorts.levels = c("site1", "site2"),
#                                     col.names = c("Site 1", "Site 2"))
