#' Import sample file
#' 
#' This function helps to import raw EMP data to EMPiR. 
#' Data must be an n by m matrix without header or row ID stored in a single file.
#' @param data_path Path to file
#' @param data_name File name
#' @param delim Delimiter
#' @keywords get, import, sample  
#' @importFrom readr read_delim
#' @importFrom readr cols
#' @export
get_prob <- function(data_path, 
                     data_name, 
                     delim="\t"){
  
  # Read data
  data <- read_delim(file.path(data_path, data_name), col_types = cols(), col_names=F, delim=delim) %>% 
    rowid_to_column("y")
  
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


#' Import standard files
#' 
#' This function helps to import standard files to EMPiR.
#' Data must be an n by m matrix without header or row ID stored in individual .txt files.
#' Please refer to the vignette for more details.
#' @param data_path Path to file(s)
#' @param data_string File name(s)
#' @keywords get, import, standard
#' @importFrom dplyr select
#' @importFrom readr read_delim
#' @importFrom readr cols
#' @export
get_std <- function(data_path, 
                    data_string){
  
  # Read data
  if(length(data_string) > 1) {
    std_df <- data_frame(filename = dir(data_path, pattern = paste(paste(data_string,collapse="|"),"*",sep=""))) %>%
      mutate(file_contents = map(filename,      
                                 ~ read_delim(file.path(data_path, .), col_names=F, delim="\t")) 
      ) %>% 
      unnest(file_contents) 
  } else {
    std_df <- data_frame(filename = dir(data_path, pattern = paste(data_string,"*",sep=""))) %>%
      mutate(file_contents = map(filename,      
                                 ~ read_delim(file.path(data_path, .), col_names=F, delim="\t")) 
      ) %>% 
      unnest(file_contents)
  }
  
  # Remove non-numerical from column names
  colnames(std_df) <- c("filename", paste(seq_len(ncol(std_df))))
  
  # From wide to long format
  std_df <- pivot_longer(std_df, 
                         -filename, 
                         names_to = 'column', 
                         values_to ='counts')
  
  # Assign standard and measurement order to data frame
  std_df$std <- vapply(strsplit(std_df$filename,"_"), `[`, 1, FUN.VALUE=character(1))
  std_df <- select(std_df, filename, std, everything())
  
  return(std_df)
}


#' Import background
#' 
#' This function helps to import background files to EMPiR.
#' Data must be an n by m matrix without header or row ID stored in individual .txt files.
#' Please refer to the vignette for more details.
#' @param data_path Path to file(s)
#' @param data_string File name(s)
#' @keywords get, import, background
#' @importFrom dplyr select
#' @importFrom readr read_delim
#' @importFrom readr cols
#' @export
get_bg <- function(data_path, 
                   data_string){
  
  # Read data
  bg_df <- tibble(filename = dir(data_path, pattern = paste(data_string,"*",sep=""))) %>%
    mutate(file_contents = map(filename,      
                               ~ read_delim(file.path(data_path, .), col_names=F, delim="\t")) 
    ) %>% 
    unnest(file_contents)
  
  # Remove non-numerical from column names
  colnames(bg_df) <- c("filename", paste(seq_len(ncol(bg_df))))
  
  # Calculate background (B) value
  B <- mean(as.matrix(select(bg_df, -1)))
  
  return(B)
}
