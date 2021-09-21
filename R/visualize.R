#' Check standards
#' 
#' This function visualizes the standard files to help identify measurement session drifts. 
#' @param data standard file import from get_std() function
#' @export
check_std <- function(data){
  
  check_data <- data %>% 
    group_by(filename) %>% 
    mutate(std_id = cur_group_id()) %>% 
    group_by(std) %>% 
    mutate(std_id = as.factor((std_id-min(std_id))/(max(std_id)-min(std_id))+1))
  
  p1 <- ggplot(check_data, aes(std_id, counts, colour=std_id)) +
    geom_jitter(width=0.3, alpha=0.5)+
    geom_boxplot(width=0.2, alpha=0.5, fill="grey70") +
    facet_wrap(~std, scales = "free_y") +
    theme_black() +
    theme(axis.title.x = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          legend.position = 'none',
          title = element_text(size=8, colour="red")) +
    scale_colour_manual(values = c("red", "blue")) +
    scale_y_continuous(expand = c(0.2,0.2))
  
  print(p1)
  return(data)
}


#' Plot raster
#' 
#' Main plot function.
#' @param data Sample data from get_prob() function
#' @param legend_name Legend title. Useful to indicate sample name, element and units
#' @param palette Select color palette 
#' @param scale_position Position of the scale bar
#' @param beam_size Size of the beam used to calculate true size from pixel 
#' @importFrom dplyr select
#' @export
image_prob <- function(data, 
                       legend_name,
                       palette,
                       scale_position = c('top_left', 
                                          'top_right', 
                                          'bottom_left', 
                                          'bottom_right', 
                                          'none'),
                       beam_size) {
  
  if(missing(palette)) {palette = contrast}
  
  if(missing(scale_position)) {scale_position = 'none'}

  if(scale_position == 'none') {
    warning('No scale bar can be plotted.')
    
    p1 <- data %>% 
      select(x,y,z) %>% 
      ggplot(aes(x, y)) +
      geom_raster(aes(fill = z)) +
      theme_empir() +
      coord_fixed() +
      labs(fill=legend_name) +
      scale_x_continuous(expand = c(0, 0)) +
      scale_y_continuous(expand = c(0, 0)) +
      scale_fill_gradientn(colors = palette, na.value = "black")
  }
  
  if(!(scale_position == 'none')) {
    
    if(missing(beam_size)) {
      stop('Please specify beam size.')
    }
    
    if(scale_position == 'top_left'){
      sbar_y <- max(data$y)*0.95
      sbar_x_max <- max(data$x)*0.4
      sbar_x_min <- max(data$x)*0.1
      sbar_bg_xmax <- max(data$x)*0.42
      sbar_bg_xmin <- max(data$x)*0.08
      sbar_bg_ymax <- max(data$y)*0.97
      sbar_bg_ymin <- max(data$y)*0.9
      if('smooth' %in% colnames(data)) {
        sbar_text <- round((beam_size * (sbar_x_max-sbar_x_min)) / 3,0)
      } else {
        sbar_text <- round(beam_size*(sbar_x_max-sbar_x_min),0)
      }
      sbar_text_pos <- max(data$y)*0.92
    }
    
    if(scale_position == 'top_right'){
      sbar_y <- max(data$y)*0.95
      sbar_x_max <- max(data$x)*0.9
      sbar_x_min <- max(data$x)*0.6
      sbar_bg_xmax <- max(data$x)*0.92
      sbar_bg_xmin <- max(data$x)*0.58
      sbar_bg_ymax <- max(data$y)*0.97
      sbar_bg_ymin <- max(data$y)*0.9
      if('smooth' %in% colnames(data)) {
        sbar_text <- round((beam_size * (sbar_x_max-sbar_x_min)) / 3,0)
      } else {
        sbar_text <- round(beam_size*(sbar_x_max-sbar_x_min),0)
      }
      sbar_text_pos <- max(data$y)*0.92
    }
    
    if(scale_position == 'bottom_left'){
      sbar_y <- max(data$y)*0.05
      sbar_x_max <- max(data$x)*0.4
      sbar_x_min <- max(data$x)*0.1
      sbar_bg_xmax <- max(data$x)*0.42
      sbar_bg_xmin <- max(data$x)*0.08
      sbar_bg_ymax <- max(data$y)*0.1
      sbar_bg_ymin <- max(data$y)*0.03
      if('smooth' %in% colnames(data)) {
        sbar_text <- round((beam_size * (sbar_x_max-sbar_x_min)) / 3,0)
      } else {
        sbar_text <- round(beam_size*(sbar_x_max-sbar_x_min),0)
      }
      sbar_text_pos <- max(data$y)*0.08
    }
    
    if(scale_position == 'bottom_right'){
      sbar_y <- max(data$y)*0.05
      sbar_x_max <- max(data$x)*0.9
      sbar_x_min <- max(data$x)*0.6
      sbar_bg_xmax <- max(data$x)*0.92
      sbar_bg_xmin <- max(data$x)*0.58
      sbar_bg_ymax <- max(data$y)*0.1
      sbar_bg_ymin <- max(data$y)*0.03
      if('smooth' %in% colnames(data)) {
        sbar_text <- round((beam_size * (sbar_x_max-sbar_x_min)) / 3,0)
      } else {
        sbar_text <- round(beam_size*(sbar_x_max-sbar_x_min),0)
      }
      sbar_text_pos <- max(data$y)*0.08
    }
    
    p1 <- data %>% 
      select(x,y,z) %>% 
      ggplot(aes(x, y)) +
      geom_raster(aes(fill = z)) +
      theme_empir() +
      coord_fixed() +
      labs(fill=legend_name) +
      scale_x_continuous(expand = c(0, 0)) +
      scale_y_continuous(expand = c(0, 0)) +
      scale_fill_gradientn(colors = palette, na.value = "black") +
      annotate("rect", xmin=sbar_bg_xmin, xmax=sbar_bg_xmax, ymin=sbar_bg_ymin, ymax=sbar_bg_ymax, fill = "black", alpha=0.8) +
      geom_linerange(mapping=aes(xmin=sbar_x_min, xmax=sbar_x_max, y=sbar_y), colour="white", size=2) +
      annotate("text", label=bquote(.(sbar_text) ~ mu*"m"), x=mean(c(sbar_x_max,sbar_x_min)), y=sbar_text_pos, colour="white", size=4)
  }
  
  print(p1)
  return(data)
}


#' Plot histogram 
#' 
#' @param data Sample data from get_prob() function
#' @param palette Select color palette
#' @param bins Bin size used in histogram
#' @importFrom dplyr select
#' @export
hist_prob <- function(data, 
                      palette,
                      bins = 50){
  
  if(missing(palette)) {palette = contrast}
  getPalette = colorRampPalette(palette)
  
  p1 <- data %>% 
    select(x,y,z) %>% 
    ggplot(aes(z, fill = cut(z, bins))) +
    geom_histogram(bins = bins, colour="grey70", position = 'identity') +
    theme_black() +
    theme(legend.position='none') +
    xlab('counts') +
    ylab('') +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_fill_manual(values = getPalette(bins)) 
  
  print(p1)
  return(p1)
}


#' Plot density function
#' 
#' @param data Sample data from get_prob() function
#' @importFrom dplyr select
#' @export
dens_prob <- function(data) {
  
  p1 <- data %>% 
    select(x,y,z) %>% 
    ggplot(aes(z)) +
    geom_density(colour="red") +
    theme_black() +
    theme(legend.position='none') +
    xlab('counts') +
    ylab('') +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) 
  
  print(p1)
  return(p1)
}


#' Plot line of subset
#' 
#' @param data Data from subset_line() function
#' @export
plot_subline <- function(data){
  
  p1 <- data %>% 
    ggplot(aes(n,z)) +
    geom_line(colour="red") +
    theme_black() +
    xlab('') +
    ylab('counts')  
  
  print(p1)
}
