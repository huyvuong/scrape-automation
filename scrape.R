library(tidyverse)
library(rvest)
library(readr)

###############################
# Track on op.gg
html_page = read_html("https://na.op.gg/summoner/userName=H2Co%20Secretary")
# extract elements as list
list1 = html_page %>% html_elements(".GameStats") %>% html_text2() %>% strsplit(split="\n") %>% map(., function(x) c(x[[1]], x[[3]], x[[4]])) 
list2 = html_page %>% html_elements(".GameStats") %>% html_element("span") %>% html_attr("data-datetime") %>% parse_number() 
# merge two lists
list3  = Map(c, list1, list2)
# convert list to data frame
list3.df = list3 %>% map_df( function(x) {
  names(x) = c("GameType", "GameResult", "GameLength", "TimeStamp")
  as_tibble_row(x)
})
# convert epoch time to local date
list3.df = list3.df %>% mutate(TimeStamp = as.character(as.POSIXct(as.numeric(TimeStamp), origin = "1970-01-01")))                                                                                            
# remove duplicate records
output_file = "League_timestamp.csv"
if (!file.exists(output_file)) {
  list3.df %>% write_csv(file=output_file)  
} else {
  temp = read_csv(output_file)
  list3.df %>% bind_rows(temp) %>% distinct() %>% write_csv(output_file)
}
# End track on op.gg                                                                                                    
###############################

################################
# Track on wol.gg
dat = read_html('https://wol.gg/stats/na/h2cosecretary/')
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
# End track on wol.gg                                                                                        
###############################
