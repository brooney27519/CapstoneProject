## Purpose: Load large source data files, create smaller subsets of source data,
## clean text data, and output cleaned data for use in Shiny app

## Description:
# The original files are far too large to use because performance suffers greatly if used as is.
# This script imports the original raw blogs, news, and twitter text files and creates smaller data sets.

# read in blog, news, and twitter source files.
# create subsets of original blog, news, and twitter files. Target is 20% of each of the 3 source files.
# combine subsets of blog, news, and twitter samples into 1 large char vector.
# remove all non-alphanumeric chars with gsub.
# divide large text file into 2 smaller subsets to store text in smaller .rds files for use in Shiny app.
# github and shinyapps.io need files to be < 30Mb.

# set working dir to location of source or original files
setwd("~/Brian/R Learning Files/Capstone/CAPSTONE DATASET/Coursera-SwiftKey/final/en_US")

## Create connections to the files.  Read as binary, encode as utf-8, but do not block loading process.
f_blog <- file(description = "./en_US.blogs.txt", open = "rb", blocking = FALSE, encoding = "UTF-8")
f_news <- file(description = "./en_US.news.txt", open = "rb", blocking = FALSE, encoding = "UTF-8")
f_twit <- file(description = "./en_US.twitter.txt", open = "rb", blocking = FALSE, encoding = "UTF-8")

# Read in each file
blog <- readLines(f_blog, skipNul = TRUE)
news <- readLines(f_news, skipNul = TRUE)
twit <- readLines(f_twit, skipNul = TRUE)

close(f_blog)
close(f_news)
close(f_twit)

# Create smaller sample sizes (subsets)
sample_blog <- sample(blog, size = length(blog)*.2, replace = FALSE)
sample_news <- sample(news, size = length(news)*.2, replace = FALSE)
sample_twit <- sample(twit, size = length(twit)*.2, replace = FALSE)

rm(list = c("blog","news","twit"))

# final text to use in Shiny app:
text <- c(sample_blog, sample_news, sample_twit)

# Convert unicode single apostrophes to UTF-8
text <- gsub('â€™',"'",text)
text <- gsub('â€˜',"'",text)

# Remove non-essential unicode characters (emojis, foreign chars, etc)
text <- gsub('[\x80-\xFF]+','',text)

# clean up the rest of text - remove punctuation and non-alpha chars, URLs, and double and triple spaces.
text <- gsub('[0-9]','',text)
text <- gsub('\\.','',text)
text <- gsub('\\*','',text)
text <- gsub('\\"','',text)
text <- gsub('\\\\','',text)
text <- gsub('\\/','',text)
text <- gsub('\\$','',text)
text <- gsub('\\(','',text)
text <- gsub('\\)','',text)
text <- gsub('\\?','',text)
text <- gsub('\\!','',text)
text <- gsub('\\+','',text)
text <- gsub(':','',text)
text <- gsub(';','',text)
text <- gsub(',','',text)
text <- gsub('-','',text)
text <- gsub('@','',text)
text <- gsub('#','',text)
text <- gsub('&','',text)
text <- gsub('~','',text)
text <- gsub('www.*.com','',text)
text <- gsub('\\s\\s\\s',' ',text)
text <- gsub('\\s\\s',' ',text)
text <- gsub('^\\s','',text)
text <- gsub('\\s$','',text)

## text is a very large file (667337 elements, 113 Mb), so it needs to be split up into smaller files
text1 <- text[1:225000]
text2 <- text[225001:667337]

# set working dir to putput location
setwd("~/Brian/R Learning Files/Capstone/CAPSTONE DATASET/Coursera-SwiftKey/final")

# create path and filenames
textfile1 <- "./PredictWord/cleanText1.rds"
textfile2 <- "./PredictWord/cleanText2.rds"

## Save cleanText files in "PredictWord" dir of Shiny app
saveRDS(text1, textfile1)
saveRDS(text2, textfile2)
