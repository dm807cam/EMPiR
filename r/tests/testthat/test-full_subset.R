path <- system.file("extdata", package = "EMPiR")

get_prob(data_path = path,
         data_name = 'Sample_Mg.txt') %>% 
  cut_prob('quant', 0.065) %>% 
  smooth_prob() %>% 
  image_prob(legend_name = 'Sample (counts)',
             scale_position = 'bottom_left',
             beam_size=6) %>% 
  subset_rect(55,99,1,55) %>% 
  subset_line(55,55,1,99) %>% 
  plot_subline()