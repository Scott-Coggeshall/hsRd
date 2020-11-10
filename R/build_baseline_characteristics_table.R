#' @export
build_baseline_characteristics_table <- function(data, vars = NULL, cohorts = 1,
                                                col.names = NULL, var.names = NULL,
                                                title = "Table 3") {

  if(is.null(vars)){

    vars <- names(data)[!(names(data) %in% c("id", "site"))]

  }

  if(is.null(var.names)){

    var.names <- vars


  }
  overall <- CreateTableOne(vars = vars,
                            data = data,
                            test = FALSE)
  overall_print <- print(overall, format = "p", printToggle = F)
  table1 <- data.frame(Var = dimnames(overall_print )[[1]],
                       Overall = unname(overall_print [, 1]),
                       stringsAsFactors = FALSE)

  # loop through each cohort and cbind to overall table1
  if(length(cohorts) > 1) {
    for (i in 1:length(cohorts)) {

      current_cohort <- data[data[[cohorts[i]]] == 1, ]
      table_current <- CreateTableOne(vars = vars,
                                      data = current_cohort,
                                      test = FALSE)
      table_current_print <- print(table_current, format = "p", printToggle = F)

      table1[[cohorts[i]]] <- unname(table_current_print[, 1])
    }
  }

  # 3. Custom formatting

  # renaming columns
  table1 <- table1 %>%
    rename(" " = Var,
           `All Randomized` = Overall)
  if (ncol(table1) > 2) {colnames(table1)[3:ncol(table1)] <- col.names}

  # renaming rows
  var_rows <- str_detect(table1$` `, "[()]") %>% which()
  table1[[1]][var_rows] <- paste0(var.names, " ", str_extract(table1[[1]][var_rows], "\\(.*"))

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
  return(flex_table)
}
