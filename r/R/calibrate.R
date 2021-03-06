#' Prepare calibration data
#' 
#' This function calculates the calibration parameters A and B.
#' Please refer to the vignette for more details.
#' @param data standard file import from get_std() function
#' @param B B parameter from get_bg() function. If B is not supplied, it will be estimated by the function.
#' @param cal known element concentrations for standards
#' @keywords calibrate
#' @export
cal_std <- function(data,
                    B,
                    cal) {
  
  data_cal <- data.frame(cal) %>% 
    rownames_to_column("std") %>% 
    rename("std" = 1,
           "cal" = 2)
  
  data <- data %>% 
    group_by(std) %>% 
    summarise(counts = mean(counts, na.rm=T))
  
  data <- inner_join(data, data_cal, by="std")
  
  lm_data <- lm(cal ~ counts, data = data)
  A <- as.numeric(coef(lm_data)[2])
  
  if(!(missing(B))) {
    B <- B
  } else {
    B <- as.numeric(coef(lm_data)[1])
  }
  
  return(c(A,B))
}

#' Calibrate sample
#' 
#' This function helps to calibrate a sample using the output of the cal_std() function
#' @param data Sample data from get_prob() function
#' @param cal Calibration data from cal_std() function
#' @param current EMP current in µA used during the measurement session
#' @param dwell_time Spot dwell time
#' @param accumulations Number of accumulations
#' @export
cal_prob <- function(data, 
                     cal,
                     current,
                     dwell_time,
                     accumulations) {
  
  It <- current*dwell_time*accumulations
  
  data$z <- cal[2]/It + cal[1] * data$z
  return(data)
}
