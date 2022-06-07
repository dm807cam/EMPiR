path <- system.file("extdata", package = "EMPiR")

# Import standards
get_std(data_path = path,
        data_string = c('VG-2', 'Dolomite')) %>% 
  check_std() %>% 
  cal_std(cal = c('VG-2' = 4.05, 
                  'Dolomite' = 13.29))

