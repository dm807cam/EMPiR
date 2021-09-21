path <- system.file("extdata", package = "EMPiR")

get_prob(data_path = path,
         data_name = 'Sample_Mg.txt') %>% 
  cut_prob('fixed', 100) %>% 
  image_prob(legend_name = 'Sample (counts)')
