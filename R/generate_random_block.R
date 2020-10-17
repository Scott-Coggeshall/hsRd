

generate_random_block <- function(block_sizes){


  block_size <- sample(block_sizes, 1)


  sample(rep(c(0, 1), each = block_size/2))

}
