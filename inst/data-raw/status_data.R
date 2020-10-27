set.seed(3232)

# simulating two site trial with 150 participants
n <- 150
site <- sample(c("site1", "site2"), n, replace = T)


status_data_list <- lapply(1:n, function(x) run_participant(id = x,
                                                            site = site[x]))

status_data <- Reduce("rbind", status_data_list)


enrollment_data <- status_data[status_data$stage == "enrollment" | status_data$stage == "screening", ]

randomization_data <- status_data[status_data$stage == 'randomization', ]

followup_data <- status_data[status_data$stage == "followup",]



write.csv(enrollment_data, "data/enrollment.csv", row.names = FALSE)
write.csv(randomization_data, "data/randomization.csv", row.names = FALSE)
write.csv(followup_data, "data/followup.csv", row.names = FALSE)
