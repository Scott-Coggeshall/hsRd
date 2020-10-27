build_consort_table <- function(status_data){

  n_screened <- nrow(status_data[status_data$stage == "screening" & status_data$action == "screened", ])

  n_ineligible <- nrow(status_data[status_data$stage == "screening" & status_data$action == "ineligible", ])

  n_enrolled <- nrow(status_data[status_data$stage == "enrollment" & status_data$action == "enrolled", ])

  n_declined <- nrow(status_data[status_data$stage == "enrollment" & status_data$action == "declined", ])

  n_randomized <- nrow(status_data[status_data$stage == "randomization", ])

  n_group1 <- nrow(status_data[status_data$stage == "randomization" & status_data$action == 0, ])

  n_group2 <- nrow(status_data[status_data$stage == "randomization" & status_data$action == 1, ])

  group1_ids <- status_data[status_data$stage == "randomization" & status_data$action == 0, "id"]

  group2_ids <- status_data[status_data$stage == "randomization" & status_data$action == 1, "id"]

  status_data_group1 <- status_data[status_data$id %in% group1_ids, ]

  status_data_group2 <- status_data[status_data$id %in% group2_ids, ]

  n_followup_group1 <- nrow(status_data_group1[status_data_group1$stage == "followup" & status_data_group1$action == "begin" , ])

  n_withdrew_group1 <- nrow(status_data_group1[status_data_group1$stage == "followup" & status_data_group1$action == "withdrew" , ])

  n_lost_group1 <- nrow(status_data_group1[status_data_group1$stage == "followup" & status_data_group1$action == "lost" , ])

  n_completed_group1 <- nrow(status_data_group1[status_data_group1$stage == "followup" & status_data_group1$action == "end" , ])

  n_active_group1 <- n_followup_group1 - (n_withdrew_group1 + n_lost_group1 + n_completed_group1)

  n_followup_group2 <- nrow(status_data_group2[status_data_group2$stage == "followup" & status_data_group2$action == "begin" , ])

  n_withdrew_group2 <- nrow(status_data_group2[status_data_group2$stage == "followup" & status_data_group2$action == "withdrew" , ])

  n_lost_group2 <- nrow(status_data_group2[status_data_group2$stage == "followup" & status_data_group2$action == "lost" , ])

  n_completed_group2 <- nrow(status_data_group2[status_data_group2$stage == "followup" & status_data_group2$action == "end" , ])

  n_active_group2 <- n_followup_group2 - (n_withdrew_group2 + n_lost_group2 + n_completed_group2)

  n_analyzed_group1 <- nrow(status_data_group1[status_data_group1$stage == "analysis" & status_data_group1$action == "analyzed", ])

   n_analyzed_group2 <- nrow(status_data_group2[status_data_group2$stage == "analysis" & status_data_group2$action == "analyzed",])

  out <- data.frame(status = c("Screened", "Ineligible", "Enrolled", "Declined",
                               "Randomized", "Group 1", "Group 2",
                               "Active Followup, Group 1", "Active Followup, Group 2",
                               "Withdrew, Group 1", "Withdrew, Group 2",
                               "Lost to Followup, Group 1", "Lost to Followup, Group 2",
                               "Completed, Group 1", "Completed, Group 2",
                               "Analyzed, Group 1", "Analyzed, Group 2"))

  out$n <- c(n_screened, n_ineligible, n_enrolled, n_declined, n_randomized,
             n_group1, n_group2, n_active_group1, n_active_group2, n_withdrew_group1,
             n_withdrew_group2, n_lost_group1, n_lost_group2,
             n_completed_group1, n_completed_group2,
             n_analyzed_group1, n_analyzed_group2)

  out


}
