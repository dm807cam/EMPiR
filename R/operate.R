#' Threshold filter
#' 
#' Remove all data points below a fixed or a quantile threshold.
#' This function is helpful to remove noise around sample edges.
#' Please refer to the vignette for more details.
#' @param data Sample data from get_prob() function
#' @param type Fixed or quantile threshold.
#' @param cut_threshold Defined threshold. Must be numeric.
#' @export
cut_prob <- function(data, 
                     type=c('fixed', 
                            'quant'), 
                     cut_threshold) {
  
  match.arg(type)
  
  if(missing(cut_threshold)) {
    stop("Please provide a threshold value.")
  }
  
  if(type == 'quant') {
    data <- data %>% 
      dplyr::select(x,y,z) %>% 
      mutate(z = replace(z, z < quantile(filter(data,z > 0)$z, prob = cut_threshold), 0))
  }
  
  if(type == 'fixed') {
    data <- data %>% 
      dplyr::select(x,y,z) %>% 
      mutate(z = replace(z, z < cut_threshold, 0))
  }
  
  # Sort data frame XYZ and make all columns numeric
  data <- data %>% 
    relocate(x,y,z) %>% 
    mutate(across(.cols = everything(), as.numeric))
  
  return(data)
}


#' Smooth function
#' 
#' @param data Sample data from get_prob() function
#' @param fac Smoothing factor.
#' @export
smooth_prob <- function(data, fac) {
  
  if(missing(fac)) {
    warning("No smoothing factor specififed. Standard factor of 3 used.")
    fac = 3
  }
  
  # Convert data frame to raster and smooth raster
  r <- rasterFromXYZ(data)
  r <- disaggregate(r,fac)
  r <- focal(r, w = matrix(1,fac,fac), mean, pad = T)
  
  # Convert raster back to data frame
  data <- as.data.frame(as.matrix(flip(r,2))) %>% 
    tibble::rowid_to_column("y")
  
  # Remove non-numerical from column names
  colnames(data) <- c("y",paste(seq_len(ncol(data)-1)))
  
  # From wide to long format
  data <- pivot_longer(data, 
                       -y, 
                       names_to = 'x', 
                       values_to ='z')
  
  # Sort data frame XYZ and make all columns numeric
  data <- data %>% 
    relocate(x,y,z) %>% 
    mutate(across(.cols = everything(), as.numeric))
  
  # Add column to data frame specifying smoothing factor
  data$smooth <- fac
  
  return(data)
}


#' Flip function
#' 
#' Flip sample horizontally or vertically
#' @param data Sample data from get_prob() function
#' @param flip_dir Flip horizontally 'h' or vertically 'v'
#' @export
flip_prob <- function(data, flip_dir=c('h','v')) {
  
  match.arg(flip_dir)
  
  if(flip_dir == 'h') {
    flip_dir = 'y'
  }
  
  if(flip_dir == 'v') {
    flip_dir = 'x'
  }
  
  # Convert data frame to raster and flip
  r <- rasterFromXYZ(data)
  r <- flip(r,flip_dir)
  
  # Convert data frame to raster and smooth raster
  data <- as.data.frame(as.matrix(r)) %>% 
    tibble::rowid_to_column("y")
  
  # Remove non-numerical from column names
  colnames(data) <- c("y",paste(seq_len(ncol(data))))
  
  # From wide to long format
  data <- pivot_longer(data, 
                       -y, 
                       names_to = 'x', 
                       values_to ='z')
  
  # Sort data frame XYZ and make all columns numeric
  data <- data %>% 
    relocate(x,y,z) %>% 
    mutate(across(.cols = everything(), as.numeric))
  
  return(data)
}


#' Subset rectangle
#' 
#' Unfortunately R does not yet provide an option to manually subset ggplots by mouse select.
#' This function allows the user to define two points between which a subset rectangle will be created.
#' Input points are on a relative scale 0-100 rather than on an absolute
#' scale to make it easier to select the desired area.
#' @param data Sample data from get_prob() function
#' @export
subset_rect <- function(data, x1, x2, y1, y2) {
  
  if(x2 > 100 | x1 > 100 | y2 > 100 | y1 > 100 |
     x2 < 0 | x1 < 0 | y2 < 0 | y1 < 0 ) {
    stop('Locators supplied have a wrong dimension.')
  }
  
  # Rescale function
  rescale <- function(x) (x-min(x))/(max(x) - min(x)) * 100
  
  # Add rescaled X and Y columns to data frame
  data <- data %>% 
    mutate(x_rescaled = x,
           y_rescaled = y) %>% 
    mutate(across(x_rescaled:y_rescaled, rescale)) %>% 
    mutate(x = x,
           y = y,
           z = z)
  
  # Plot rescaled data 
  p1 <- data %>% 
    dplyr::select(x_rescaled,y_rescaled,z) %>% 
    ggplot(aes(x_rescaled,y_rescaled)) +
    geom_raster(aes(fill = z)) +
    theme_empir() +
    labs(fill='counts') +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_fill_gradientn(colors = contrast,
                         na.value = "black") +
    geom_rect(aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2), fill=NA, colour="red", size=1) 
  
  print(p1)
  
  # Subset data frame and export
  data <- data %>% 
    filter(x_rescaled >= x1 & 
             x_rescaled <= x2 &
             y_rescaled >= y1 &
             y_rescaled <= y2) %>% 
    dplyr::select(-y_rescaled, -x_rescaled) %>% 
    mutate(x = x - min(x),
           y = y - min(y),
           z = z) %>% 
    mutate(across(.cols = everything(), as.numeric))
  
  return(data)
}


#' Subset line
#' 
#' Unfortunately R does not yet provide an option to manually subset ggplots by mouse select.
#' This function allows the user to define two points between which a subset line will be created.
#' Input points are on a relative scale 0-100 rather than on an absolute
#' scale to make it easier to select the desired area.
#' @param data Sample data from get_prob() function
#' @export
subset_line <- function(data, x1, x2, y1, y2) {
  
  if(x2 > 100 | x1 > 100 | y2 > 100 | y1 > 100 |
     x2 < 0 | x1 < 0 | y2 < 0 | y1 < 0 ) {
    stop('Locators supplied have a wrong dimension.')
  }
  
  # Rescale function
  rescale <- function(x) (x-min(x))/(max(x) - min(x)) * 100
  
  # Add rescaled X and Y columns to data frame
  data <- data %>% 
    mutate(x_rescaled = x,
           y_rescaled = y) %>% 
    mutate(across(x_rescaled:y_rescaled, rescale)) %>% 
    mutate(x = x,
           y = y,
           z = z)
  
  # Plot rescaled data 
  p1 <- data %>% 
    dplyr::select(x_rescaled,y_rescaled,z) %>% 
    ggplot(aes(x_rescaled,y_rescaled)) +
    geom_raster(aes(fill = z)) +
    theme_empir() +
    labs(fill='counts') +
    coord_fixed() +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_fill_gradientn(colors = contrast,
                         na.value = "black") +
    annotate("segment", x = x1, xend = x2, y = y1, yend = y2, colour="red", size=1) 
  
  print(p1)
  
  # Create rescaled data frame
  rescaled_data <- data %>% 
    dplyr::select(x_rescaled,y_rescaled,z) %>% 
    mutate(x = x_rescaled,
           y = y_rescaled,
           z = z) %>% 
    mutate(across(.cols = everything(), as.numeric))
  
  # Convert data frame to raster and define spatial line
  r <- rasterFromXYZ(rescaled_data)
  lines <- spLines(rbind(c(x1,y1), c(x2,y2)))
  rline <- as.data.frame(raster::extract(r, lines)[[1]])
  
  # Add point ID to data frame
  data <- rline %>% 
    mutate(n = seq_len(length(z)))
  
  return(data)
}
