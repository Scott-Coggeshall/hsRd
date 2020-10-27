#' @export
create_consort_dot <- function(consort_table){


  consort_dot_path <- system.file(file.path("dot", "consort.dot"), package = "hsRd")

  consort_dot <- readChar(consort_dot_path, file.info(consort_dot_path)$size)

  consort_dot <- sub("n_screened", consort_table[1, 2], consort_dot)

  consort_dot <- sub("n_ineligible", consort_table[2, 2], consort_dot)

  consort_dot <- sub("n_enrolled", consort_table[3, 2], consort_dot)

  consort_dot <- sub("n_declined", consort_table[4, 2], consort_dot, fixed = TRUE)

  consort_dot <- sub("n_randomized", consort_table[5, 2], consort_dot, fixed = TRUE)

  consort_dot <- sub("n_randomized_group1", consort_table[6, 2], consort_dot, fixed = T)

  consort_dot <- sub("n_randomized_group2", consort_table[7, 2], consort_dot, fixed = T)

  consort_dot <- sub("n_active_group1", consort_table[8, 2], consort_dot, fixed = T)

  consort_dot <- sub("n_active_group2", consort_table[9, 2], consort_dot, fixed = T)

  consort_dot <- sub("n_withdrew_group1", consort_table[10, 2], consort_dot, fixed = T)

  consort_dot <- sub("n_withdrew_group2", consort_table[11, 2], consort_dot, fixed = T)

  consort_dot <- sub("n_lost_group1", consort_table[12,2], consort_dot, fixed = T)

  consort_dot <- sub("n_lost_group2", consort_table[13, 2], consort_dot, fixed = T)

  consort_dot <- sub("n_completed_group1", consort_table[14, 2], consort_dot, fixed = T)

  consort_dot <- sub("n_completed_group2", consort_table[15, 2], consort_dot, fixed = T)

  consort_dot <- sub("n_analyzed_group1", consort_table[16, 2], consort_dot, fixed = T)

  consort_dot <- sub("n_analyzed_group2", consort_table[17, 2], consort_dot, fixed = T)

  consort_dot

}
