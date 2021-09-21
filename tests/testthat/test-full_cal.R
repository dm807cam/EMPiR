path <- system.file("extdata", package = "EMPiR")

# Import background data
B <- get_bg(data_path = path,
            data_string = 'Bg')

# Import standards
cal <- get_std(data_path = path,
               data_string = c('VG-2', 'Dolomite')) %>% 
  cal_std(cal = c('VG-2' = 4.05, 
                  'Dolomite' = 13.29),
          B = B)

# Import sample data
get_prob(data_path = path,
         data_name = 'Sample_Mg.txt') %>%
  cal_prob(cal,
           current = 0.1004,
           dwell_time = 20,
           accumulations = 8) %>%
  image_prob(legend_name = 'Mg [conc %]',
             scale_position = 'bottom_left',
             beam_size = 6) 
