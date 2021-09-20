library('hexsticker')
library('showtext')

font_add_google('Raleway')
showtext_auto()

p <- get_prob(data_path = "./example_data",
              data_name = "Sample2.txt") %>%
  cut_prob('quant', 0.04) %>% 
  smooth_prob(na_rm = T) %>% 
  image_prob(legend_unit = "test") 

p <- last_plot() + theme_void() + theme(legend.position = 'none') + coord_flip() + scale_x_reverse()
p


# Delete old logo before running logo function
# hexSticker does not provide an overwrite function.
file.remove('man/figures/logo.png')

hexSticker::sticker(p, h_fill = "black", 
                    h_color = "grey80", 
                    white_around_sticker = T,
                    package="EMPiR",
                    p_size = 58, 
                    p_x = 1,
                    p_y = 1.4,
                    p_family = 'Raleway',
                    p_fontface = 'bold',
                    s_width=2, 
                    s_height=2,
                    s_x = 1.1,
                    s_y = 0.5,
                    url="https://github.com/dm807cam/EMPiR",
                    u_size = 7.6,
                    u_color = "white",
                    u_family = 'Raleway',
                    dpi=600,
                    filename="assets/logo.png")
