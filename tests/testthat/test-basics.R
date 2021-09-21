path <- system.file("extdata", package = "EMPiR")

get_prob(data_path = path,
         data_name = 'Sample_Mg.txt') %>% 
  cut_prob('quant', 0.065) %>% 
  smooth_prob() %>% 
  image_prob(legend_name = 'Sample (counts)',
             scale_position = 'bottom_left',
             beam_size=6)
