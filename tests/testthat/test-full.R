path <- system.file("extdata", package = "EMPiR")

# Import Background values
B <- get_bg(data_path = path,
            data_string = "Bg")

# Import standard calibration
cal <- get_std(data_path = path,
               data_string = c("VG-2", "Dolomite")) %>% 
  check_std() %>% 
  cal_std(cal = c("VG-2" = 4.05, 
                  "Dolomite" = 13.29),
          B = B,
          current=0.1004,
          dwell_time = 20,
          accumulations = 8)

# Import sample, calibrate and plot
get_prob(data_path = path,
         data_name = "Sample_Mg.txt") %>%
  image_prob(legend_name = 'Sr [wt %]',
             scale_position = 'bottom_left',
             beam_size = 6) 
