library(tidyverse)
library(rvest)
library(readr)

dat = read_html('https://wol.gg/stats/na/h2cosecretary/')

lev = dat %>% html_elements("#level") %>% html_text() %>% parse_number()
names(lev) = "level"

last_seen = dat %>% html_elements("#last-seen") %>% html_text()
names(last_seen) = "last_seen"

scrape = dat %>% html_elements("p") %>% html_text()
vec = parse_number(scrape)
names(vec) = c("minutes", "hours", "days", "rank_NA", "rank_world", "books", "movies" , "kilometer")

out = c(lev, last_seen, vec)

t(out) %>% as_tibble() %>% write_csv(file=paste0("League_", Sys.Date(), ".csv"))

