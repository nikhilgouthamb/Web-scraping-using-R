

# Web Scraping Project in R for Genome Biology Articles

This project aims to extract articles from Genome Biology for a specific year and extract key information from them. The extracted information includes the title, authors, affiliations, correspondence author, email, publish date, abstract, keywords, and full text of the articles. The project utilizes R packages like rvest for web scraping and data manipulation to collect and organize the information.

## How to Use

1. Install the required R packages:
   ```R
   install.packages("rvest")
   install.packages("dplyr")
   ```

2. Run the `web_scraping.R` script to scrape the articles and extract the key information.

3. The extracted information will be saved in a CSV file for further analysis.

## Project Structure

- `genome_biologyfinal.R`: R script for web scraping and data extraction.
- `data/`: Folder to store the extracted data.

## Dependencies

- R (>= 3.5.0)
- rvest
- dplyr

## Credits

This project was developed by Nikhil Goutham as part of DS636/Data Analytics with R/Mini Project.
