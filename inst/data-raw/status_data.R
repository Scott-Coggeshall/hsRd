set.seed(3232)

# simulating two site trial with 150 participants
n <- 300
site <- sample(c("site1", "site2"), n, replace = T)


status_data_list <- lapply(1:n, function(x) run_participant(id = x,
                                                            site = site[x]))

status_data <- Reduce("rbind", status_data_list)


enrollment_data <- status_data[status_data$stage == "enrollment" | status_data$stage == "screening", ]

randomization_data <- status_data[status_data$stage == 'randomization', ]

followup_data <- status_data[status_data$stage == "followup",]

# create demographics data among those randomized

n_randomized <- nrow(randomization_data)
baseline_data <- data.frame(id = randomization_data$id,
                              site = randomization_data$site,

                              Gender      = sample(c("M", "F", NA), size = n_randomized,
                                               prob = c(0.9, 0.05, 0.05), replace = T),
                              Age         = sample(18:85, size = n_randomized, replace = T),
                              Race        = sample(c("White", "Black", "Asian", NA),
                                               size = n_randomized,
                                               prob = c(0.7, 0.2, .05, .05), replace = T),
                              Rurality    = sample(c("U", "R", NA), size = n_randomized,
                                               prob = c(0.7, 0.2, 0.1), replace = T))

# extract adverse events

adverse_event <- followup_data[followup_data$action == "adverse_event", ]
severe_adverse_event <- followup_data[followup_data$action == "severe_adverse_event", ]



adverse_event$type <- NA
adverse_event$body_system <- sample(c("Cardiovascular", "Dermatological", "Gastrointestinal",
                                      "Hematological", "Metabolic", "Musculoskeletal",
                                      "Neurological", "Psychological", "Pulmonary/Respiratory",
                                      "Renal/Urologic", "Hepatobiliary", "Other"), size = nrow(adverse_event),
                                    replace = TRUE)
severe_adverse_event$type <- sample(c("MS: no hospitalization", "MS: requiring hospitalization",
                                      "Medical/surgical intervention required", "Long term disability",
                                      "Life threatening", "Death", "Congenital anomaly", "Other"),
                                    size = nrow(severe_adverse_event), replace = TRUE)

severe_adverse_event$study_related <- rbinom(n = nrow(severe_adverse_event), size = 1, prob = .1)



write.csv(enrollment_data, "data/enrollment.csv", row.names = FALSE)
write.csv(randomization_data, "data/randomization.csv", row.names = FALSE)
write.csv(followup_data, "data/followup.csv", row.names = FALSE)
write.csv(baseline_data, "data/baseline.csv", row.names = FALSE)
write.csv(adverse_event, "data/adverse_event.csv", row.names = FALSE)
write.csv(severe_adverse_event, "data/severe_adverse_event.csv", row.names = FALSE)
