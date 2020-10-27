#' @export
run_participant <- function(id, site){

  screened <- Sys.Date() + sample(0:20, 1)

  ineligible <- rbinom(1, 1, prob = .1)

  if(ineligible == 1){

    return(rbind(
      data.frame(id = id, site = site, stage = "screening", action = "screened", date = screened),
      data.frame(id = id, site = site, stage = "screening", action = "ineligible", date = screened)
      ))

  }

  enrolled <- screened

  declined <- rbinom(1, 1, .2)

  declined_date <- enrolled + sample(0:2, 1)
  if(declined == 1){

    return(rbind(
      data.frame(id = id, site = site, stage = "screening", action = "screened", date = screened),
      data.frame(id = id, site = site, stage = "enrollment", action = "enrolled", date = enrolled ),
      data.frame(id = id, site = site, stage = "enrollment", action = "declined", date = declined_date)
    ))


  }

  randomized <- enrolled + sample(0:3, 1)

  randomization <- rbinom(1, 1, .5)

  lost_to_followup <- rbinom(1, 1, .2)


  if(lost_to_followup == 1){

    lost_date <- randomized + sample(c(30, 60, 120), 1)
    return(rbind(
      data.frame(id = id, site = site, stage = "screening", action = "screened", date = screened),
      data.frame(id = id, site = site, stage = "enrollment", action = "enrolled", date = enrolled ),
      data.frame(id = id, site = site, stage = "randomization", action = randomization, date = randomized),
      data.frame(id = id, site = site, stage = "followup", action = "begin", date = randomized),
      data.frame(id = id, site = site, stage = "followup", action = "lost", date = lost_date)
    ))

  }

  return(rbind(
    data.frame(id = id, site = site, stage = "screening", action = "screened", date = screened),
    data.frame(id = id, site = site, stage = "enrollment", action = "enrolled", date = enrolled ),
    data.frame(id = id, site = site, stage = "randomization", action = randomization, date = randomized),
    data.frame(id = id, site = site, stage = "followup", action = "begin", date = randomized),
    data.frame(id = id, site = site, stage = "followup", action = "end", date = randomized + 180 + sample(0:10, 1))
  ))
}

