plot_randomization <- function(randomization_data){



  p_dat <- randomization_data %>% arrange(date) %>% # order by date
    group_by( date) %>% summarize(n = n()) %>% # calculate number people randomized each date
    mutate(n_total = cumsum(n)) # get cumulative sum up to that date

  p <- ggplot(data = p_dat, aes(x = date, y = n_total)) + geom_point() +
    geom_line() + theme(axis.text.x = element_text(vjust = .5, angle = .45)) +
    labs(y = "Total Randomized", x = "Date")

  p


}
