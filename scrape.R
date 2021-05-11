library(tidyverse)
library(rvest)
library(readr)

dat = read_html('https://wol.gg/stats/na/h2cosecretary/')
scrape = dat %>% html_nodes("p") %>% html_text()
vec = parse_number(scrape)
write_lines(vec, file=paste0("League_", Sys.Date(), ".csv"))
