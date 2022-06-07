path <- system.file("extdata", package = "EMPiR")

get_prob(data_path = path,
         data_name = 'Sample_Mg.txt') %>% 
  dens_prob()
