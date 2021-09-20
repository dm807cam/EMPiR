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
  
  return(data)
}

#' Smooth function
#' @param data Sample data from get_prob() function
#' @export
smooth_prob <- function(data) {
  
  r <- rasterFromXYZ(data)
  r <- disaggregate(r,3)
  r <- focal(r, w= matrix(1,3,3), mean, pad=T)
  
  data <- as.data.frame(as.matrix(flip(r,2))) %>% 
    tibble::rowid_to_column("y")
  
  # Remove X from column names
  colnames(data) <- c("y",paste(1:(ncol(data)-1)))
  
  # From wide to long format
  data <- pivot_longer(data, 
                       -y, 
                       names_to = 'x', 
                       values_to ='z')
  
  data$x <- as.numeric(data$x)
  
  data$smooth <- TRUE
  
  return(data)
}

#' Flip function
#' 
#' Flip sample horizontally or vertically
#' @param data Sample data from get_prob() function
#' @param flip_dir Flip horizontally 'h' or vertically 'v'
#' @export
flip_prob <- function(data, 
                      flip_dir=c('h','v')) {
  
  if(flip_dir == 'h') {
    flip_dir = 'y'
  }
  
  if(flip_dir == 'v') {
    flip_dir = 'x'
  }
  
  rasterFromXYZ(data) -> r
  
  data <- as.data.frame(as.matrix(flip(r,flip_dir))) %>% 
    tibble::rowid_to_column("y")
  
  # Remove X from column names
  colnames(data) <- c("y",paste(1:(ncol(data)-1)))
  
  # From wide to long format
  data <- pivot_longer(data, 
                       -y, 
                       names_to = 'x', 
                       values_to ='z')
  
  data$x <- as.numeric(data$x)
  
  return(data)
}

#' Subset rectangle
#' Unfortunately R does not yet provide an option to manually subset ggplots by mouse select.
#' We thus define two points between which a subset rectangle will be created.
#' Input points are on a relative scale 0-100 rather than on an absolute
#' scale to make it easier for the operator to select the desired area.
#' 
#' @param data Sample data from get_prob() function
#' @export
subset_rect <- function(data, x1, x2, y1, y2) {
  
  if(x2 > 100 | x1 > 100 | y2 > 100 | y1 > 100 |
     x2 < 0 | x1 < 0 | y2 < 0 | y1 < 0 ) {
    stop('Locators supplied have a wrong dimension.')
  }
  
  rescale <- function(x) (x-min(x))/(max(x) - min(x)) * 100
  
  data <- data %>% 
    mutate(x_rescaled = x,
           y_rescaled = y) %>% 
    mutate(across(x_rescaled:y_rescaled, rescale)) %>% 
    mutate(x = x,
           y = y,
           z = z)
  
  p1 <- data %>% 
    dplyr::select(x_rescaled,y_rescaled,z) %>% 
    ggplot(aes(x_rescaled,y_rescaled)) +
    geom_raster(aes(fill = z)) +
    theme_empir() +
    labs(fill='counts') +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_fill_gradientn(colors = colr,
                         values = c(0,0.1,0.2,0.4,0.6,0.7,0.8,1), 
                         na.value = "black") +
    geom_rect(aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2), fill=NA, colour="red", size=1) 
  
  print(p1)
  
  data <- data %>% 
    filter(x_rescaled >= x1 & 
             x_rescaled <= x2 &
             y_rescaled >= y1 &
             y_rescaled <= y2) %>% 
    dplyr::select(-y_rescaled, -x_rescaled) %>% 
    mutate(x = x - min(x),
           y = y - min(y),
           z = z)
  
  return(data)
}

#' Subset line
#' 
#' @param data Sample data from get_prob() function
#' @export
subset_line <- function(data, x1, x2, y1, y2) {
  
  if(x2 > 100 | x1 > 100 | y2 > 100 | y1 > 100 |
     x2 < 0 | x1 < 0 | y2 < 0 | y1 < 0 ) {
    stop('Locators supplied have a wrong dimension.')
  }
  
  rescale <- function(x) (x-min(x))/(max(x) - min(x)) * 100
  
  data <- data %>% 
    mutate(x_rescaled = x,
           y_rescaled = y) %>% 
    mutate(across(x_rescaled:y_rescaled, rescale)) %>% 
    mutate(x = x,
           y = y,
           z = z)
  
  p1 <- data %>% 
    dplyr::select(x_rescaled,y_rescaled,z) %>% 
    ggplot(aes(x_rescaled,y_rescaled)) +
    geom_raster(aes(fill = z)) +
    theme_empir() +
    labs(fill='counts') +
    coord_fixed() +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_fill_gradientn(colors = colr,
                         values = c(0,0.1,0.2,0.4,0.6,0.7,0.8,1), 
                         na.value = "black") +
    annotate("segment", x = x1, xend = x2, y = y1, yend = y2, colour="red", size=1) 
  
  print(p1)
  
  rescaled_data <- data %>% 
    dplyr::select(x_rescaled,y_rescaled,z) %>% 
    mutate(x = x_rescaled,
           y = y_rescaled,
           z = z)
  
  r <- rasterFromXYZ(rescaled_data)
  lines <- spLines(rbind(c(x1,y1), c(x2,y2)))
  rline <- as.data.frame(raster::extract(r, lines)[[1]])
  
  data <- rline %>% 
    mutate(n = 1:length(z))
  
  return(data)
  
}
