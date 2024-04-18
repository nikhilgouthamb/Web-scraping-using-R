library(rvest)
library(dplyr)
library(tidyverse)
library(openxlsx)
library(readr)
extract_genome_biology_articles <- function(year) {
  # calculate volume number based on year
  volume <- year - 1999
  
  # create URL for Genome Biology website for given year
  url <- paste0("https://genomebiology.biomedcentral.com/articles?query=&volume=", volume, "&searchType=&tab=keyword")
  
  # scrape HTML code from website
  page <- read_html(url)
  
  # extract article URLs from listing page
  article_links <- page %>% 
    html_nodes(".c-listing__title a") %>% 
    html_attr("href")
  
  # initialize empty list to store articles
  articles <- list()
  
  # iterate over article URLs and extract information
  for (link in article_links) {
    # construct full URL for article page
    article_url <- paste0("https://genomebiology.biomedcentral.com", link)
    
    # scrape HTML code from article page
    article_page <- read_html(article_url)
    
    # extract fields for each article
    tryCatch({
      title <- article_page %>% html_node(".c-article-title") %>% html_text(trim = TRUE)
      authors <- article_page %>% html_nodes(".c-article-author-list__item a") %>% html_text(trim = TRUE) %>% toString()
      affils <- article_page %>% html_nodes(".c-article-author-affiliation__address") %>% html_text(trim = TRUE) %>% toString()
      corr_author <- article_page %>% html_node("#corresp-c1") %>% html_text(trim = TRUE)
      corr_email <- ""
      pub_date <- article_page %>% html_node(".c-article-identifiers__item time") %>% html_text(trim = TRUE)
      abstract <- article_page %>% html_node("#Abs1-content p") %>% html_text(trim = TRUE)
      keywords <- article_page %>% html_nodes(".c-article-subject-list__subject span") %>% html_text(trim = TRUE) %>% toString()
      full_text <- article_page %>% html_node("#Abs1-content p:nth-child(4)") %>% html_text(trim = TRUE)
      
      
      # store fields in a list
      article <- list(title = title,
                      authors = authors,
                      affiliations = affils,
                      correspondence_author = corr_author,
                      correspondence_email = corr_email,
                      publish_date = pub_date,
                      abstract = abstract,
                      keywords = keywords,
                      full_text = full_text)
      
      # add article to list of articles
      articles[[length(articles) + 1]] <- article
    }, error = function(e) {
      cat(paste0("Error: '", link, "' does not exist.\n"))
    })
  }
  
  # convert list of articles to data frame
  articles_df <- do.call(rbind, articles)
  
  # return data frame
  return(articles_df)
}

# example usage for year 2021
my_articles <- extract_genome_biology_articles(2021)
write.table(my_articles, file = "P_output.txt", sep = "\t", row.names = FALSE, col.names = TRUE)