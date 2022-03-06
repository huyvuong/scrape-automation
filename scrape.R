library(tidyverse)
library(rvest)
library(readr)

###############################
# Track on op.gg
out1 = tryCatch({
  #html_page = read_html("https://na.op.gg/summoner/userName=H2Co%20Secretary")
  #html_page = read_html("https://na.op.gg/summoner/userName=Spectateconcac")
  #html_page = read_html("https://na.op.gg/summoner/userName=H2Co%20Gabriel")
  html_page = read_html("https://na.op.gg/summoners/na/H2Co%20Gabriel")
  
  time_stamp = html_page %>% html_elements(".time-stamp") %>% html_text()
  game_length = html_page %>% html_elements(".game-length") %>% html_text()
  game_result = html_page %>% html_elements(".game-result") %>% html_text()
  #type = html_page %>% html_elements(".type") %>% html_text()
  
  df = cbind.data.frame(time_stamp, game_length, game_result)
  
  # remove duplicate records
  output_file = "League_timestamp_new.csv"
  if (!file.exists(output_file)) {
    df %>% write_csv(file=output_file)  
  } else {
    temp = read_csv(output_file, col_types = "ccc")
    df %>% bind_rows(temp) %>% distinct() %>% write_csv(output_file)  
  }
},
error = function(cond) {
  message(cond)
})
# End track on op.gg                    
###############################

################################
# Track on wol.gg
# tryCatch to handle error 524 server down                                                                                                    
out2 = tryCatch ({
  #dat = read_html('https://wol.gg/stats/na/h2cosecretary/')
  dat = read_html("https://wol.gg/stats/na/spectateconcac/")
  # extract elements
  lev = dat %>% html_elements("#level") %>% html_text() %>% parse_number()
  names(lev) = "level"
  last_seen = dat %>% html_elements("#last-seen") %>% html_text()
  names(last_seen) = "last_seen"
  scrape = dat %>% html_elements("p") %>% html_text()
  vec = parse_number(scrape)
  names(vec) = c("minutes", "hours", "days", "rank_NA", "rank_world", "books", "movies" , "kilometer")
  out = c(lev, last_seen, vec)
  # convert to data frame
  out.df = t(out) %>% as_tibble() 
  #out.df %>% write_csv(file=paste0("League_", Sys.Date(), ".csv"))
  # output file
  out.df %>% write_csv(file="League_cumulative.csv", append=TRUE)
},
error = function(cond) {
  message(cond)
})
# End track on wol.gg                                                                                        
###############################
