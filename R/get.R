#' Import sample file
#' 
#' This function helps to import raw EMP data to EMPiR. 
#' Data must be an n by m matrix without header or row ID stored in a single .txt file.
#' @param data_path Path to file
#' @param data_name File name
#' @keywords get, import, sample  
#' @export
#' @examples
#' get_prob('path/to/file', 'awesome_file.txt')
get_prob <- function(data_path, 
                     data_name){
  
  prob_df <- read_delim(file.path(data_path, data_name), col_types = cols(), col_names=F, delim="\t") %>% 
    tibble::rowid_to_column("y")
  
  # Remove X from column names
  colnames(prob_df) <- c("y",paste(1:ncol(prob_df)))
  
  # From wide to long format
  prob_df <- pivot_longer(prob_df, 
                          -y, 
                          names_to = 'x', 
                          values_to ='z')
  
  prob_df$x <- as.numeric(prob_df$x)
  
  return(prob_df)
  
}

#' Import standard files
#' 
#' This function helps to import standard files to EMPiR.
#' Data must be an n by m matrix without header or row ID stored in individual .txt files.
#' Please refer to the vignette for more details.
#' @param data_path Path to file(s)
#' @param data_string File name(s).
#' @keywords get, import, standard
#' @export
#' @examples
#' get_prob('path/to/file', c('VG-2', 'Dolomite')) 
get_std <- function(data_path, 
                    data_string){
  if(length(data_string) > 1) {
    std_df <- data_frame(filename = dir(data_path, pattern = paste(paste(data_string,collapse="|"),"*",sep=""))) %>%
      mutate(file_contents = map(filename,      
                                 ~ read_delim(file.path(data_path, .), col_names=F, delim="\t")) 
      ) %>% 
      unnest(file_contents) } else {
        std_df <- data_frame(filename = dir(data_path, pattern = paste(data_string,"*",sep=""))) %>%
          mutate(file_contents = map(filename,      
                                     ~ read_delim(file.path(data_path, .), col_names=F, delim="\t")) 
          ) %>% 
          unnest(file_contents)
      }
  
  # Remove X from column names
  colnames(std_df) <- c("filename", paste(1:ncol(std_df)))
  
  # From wide to long format
  std_df <- pivot_longer(std_df, 
                         -filename, 
                         names_to = 'column', 
                         values_to ='counts')
  
  # Assign standard and measurement order to data frame
  std_df$std <- vapply(strsplit(std_df$filename,"_"), `[`, 1, FUN.VALUE=character(1))
  std_df <- dplyr::select(std_df, filename, std, everything())
  return(std_df)
}

#' Import background
#' 
#' This function helps to import background files to EMPiR.
#' Data must be an n by m matrix without header or row ID stored in individual .txt files.
#' Please refer to the vignette for more details.
#' @param data_path Path to file(s)
#' @param data_string File name(s).
#' @keywords get, import, background
#' @export
#' @examples
#' get_bg('path/to/file', 'Bg') 
get_bg <- function(data_path, 
                   data_string){
  
  bg_df <- data_frame(filename = dir(data_path, pattern = paste(data_string,"*",sep=""))) %>%
    mutate(file_contents = map(filename,      
                               ~ read_delim(file.path(data_path, .), col_names=F, delim="\t")) 
    ) %>% 
    unnest(file_contents)
  
  colnames(bg_df) <- c("filename", paste(1:ncol(bg_df)))
  
  B <- mean(as.matrix(dplyr::select(bg_df, -1)))
  return(B)
}
