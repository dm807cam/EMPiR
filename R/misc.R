#' Theme EMPiR
#' @importFrom ggplot2 %+replace%
theme_empir = function() {
  theme_void() %+replace%
    theme(
      legend.background = element_rect(color = NA, fill = "black"),  
      legend.key = element_rect(color = "white",  fill = "black"),  
      legend.key.size = unit(1.2, "lines"),  
      legend.key.height = NULL,  
      legend.key.width = NULL,      
      legend.text = element_text(size = 11*0.8, color = "white"),  
      legend.title = element_text(size = 11*0.8, face = "bold", hjust = 0, color = "white"),  
      legend.position = "right",  
      legend.text.align = NULL,  
      legend.title.align = NULL,  
      legend.direction = "vertical",  
      legend.box = NULL, 
      legend.margin=margin(0,0,0,5),
      panel.background = element_rect(fill = "black", color  =  NA),
      panel.border = element_rect(colour = "white", fill=NA, size=1),
      panel.spacing = unit(c(0.5,0.5,0.5,0.5),"lines"),
      strip.background = element_rect(fill = "grey30", color = "grey10"),  
      strip.text.x = element_text(size = 11*0.8, color = "white"),  
      strip.text.y = element_text(size = 11*0.8, color = "white",angle = -90),  
      plot.background = element_rect(color = "black", fill = "black"),  
      plot.title = element_text(size = 11*1.2, color = "white"),
      plot.margin = unit(c(1,1,1,1),"lines")
    )
}


#' Theme Black
#' @importFrom ggplot2 %+replace%
theme_black = function() {
  theme_grey() %+replace%
    theme(
      axis.line = element_blank(),  
      axis.text.x = element_text(size = 11*0.8, color = "white", lineheight = 0.9),  
      axis.text.y = element_text(size = 11*0.8, color = "white", lineheight = 0.9),  
      axis.ticks = element_line(color = "white", size  =  0.2),  
      axis.title.x = element_text(size = 11, color = "white", margin = margin(0, 10, 0, 0)),  
      axis.title.y = element_text(size = 11, color = "white", angle = 90, margin = margin(0, 10, 0, 0)),  
      axis.ticks.length = unit(0.3, "lines"),  
      legend.background = element_rect(color = NA, fill = "black"),  
      legend.key = element_rect(color = "white",  fill = "black"),  
      legend.key.size = unit(1.2, "lines"),  
      legend.key.height = NULL,  
      legend.key.width = NULL,      
      legend.text = element_text(size = 11*0.8, color = "white"),  
      legend.title = element_text(size = 11*0.8, face = "bold", hjust = 0, color = "white"),  
      legend.position = "right",  
      legend.text.align = NULL,  
      legend.title.align = NULL,  
      legend.direction = "vertical",  
      legend.box = NULL, 
      panel.background = element_rect(fill = "black", color  =  NA),  
      panel.border = element_rect(fill = NA, color = "white"),  
      panel.grid.major = element_line(color = "grey35"),  
      panel.grid.minor = element_line(color = "grey20", linetype = 2),  
      panel.spacing = unit(0.5, "lines"),   
      strip.background = element_rect(fill = "grey30", color = "grey10"),  
      strip.text.x = element_text(size = 11*0.8, color = "white"),  
      strip.text.y = element_text(size = 11*0.8, color = "white",angle = -90),  
      plot.background = element_rect(color = "black", fill = "black"),  
      plot.title = element_text(size = 11*1.2, color = "white"),  
      plot.margin = unit(rep(1, 4), "lines")
    )
}


#' Contrast color palette
#' @export
contrast <- c('#000000','#0033ff','#0099ff','#7fff00','#ffff00','#ff9900','#ff0000','#ff004c')


#' Moonlight color palette
#' @export
moonlight <- c('#000000','#4a4e4d', '#0e9aa7', '#3da4ab', '#f6cd61', '#fe8a71')


#' Pastell color palette
#' @export
pastell <- c('#000000','#071e22', '#1d7874', '#679289', '#f4c095', '#ee2e31')