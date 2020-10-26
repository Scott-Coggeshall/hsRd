create_consort_dot <- function(n_screened, n_ineligible, n_enrolled, n_declined,
                               n_randomized, n_randomized_group1, n_randomized_group2,
                               n_active_group1, n_active_group2,
                               n_lost_group1, n_lost_group2,
                               n_withdrew_group1, n_withdrew_group2,
                               n_analyzed_group1, n_analyzed_group2){


  consort_dot_path <- system.file(file.path("dot", "consort.dot"), package = "hsRd")

  consort_dot <- readChar(consort_dot_path, file.info(consort_dot_path)$size)

  consort_dot <- sub("n_screened", n_screened, consort_dot)

  consort_dot <- sub("n_ineligible", n_ineligible, consort_dot)

  consort_dot <- sub("n_enrolled", n_enrolled, consort_dot)

  consort_dot <- sub("n_randomized", n_randomized, consort_dot)

  consort_dot <- sub("n_randomized(?!_group1)", n_randomized_group1, consort_dot, perl = T)

  consort_dot <- sub("n_randomzied(?!_group2)", n_randomized_group2, consort_dot, perl = T)

  consort_dot <- sub("n_active_group1", n_active_group1, consort_dot)

  consort_dot <- sub("n_active_group2", n_active_group2, consort_dot)

  consort_dot <- sub("n_withdrew_group1", n_withdrew_group1, consort_dot)

  consort_dot <- sub("n_withdrew_group2", n_withdrew_group2, consort_dot)

  consort_dot <- sub("n_analyzed_group1", n_analyzed_group1, consort_dot)

  consort_dot <- sub("n_analyzed_group2", n_analyzed_group2, consort_dot)



}
