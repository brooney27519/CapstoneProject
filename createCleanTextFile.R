## Create and preprocess text data for Shiny app
## Set working dir
setwd("~/Brian/R Learning Files/Capstone/CAPSTONE DATASET/Coursera-SwiftKey/")

## Create indexes for sample text files
file_loc <- "./final/samples/"
files <- dir(file_loc, full.names = TRUE)
index_blog <- grep("blog",files)
index_news <- grep("news",files)
index_twit <- grep("twit",files)

# Read in sample text files
blog <- readLines(files[index_blog], warn = FALSE, skipNul = TRUE)
news <- readLines(files[index_news], warn = FALSE, skipNul = TRUE)
twit <- readLines(files[index_twit], warn = FALSE, skipNul = TRUE)

text <- c(blog,news,twit)
rm(list = c("blog","news","twit"))
Encoding(text) <- "UTF-8"

## Remove hexidecimal characters, numbers, and URLs
text <- gsub('[^\x01-\x7F]+','',text)
text <- gsub('[0-9]','',text)
text <- gsub('www.*.com','',text)

## text is a very large file (667337 elements, 113 Mb), so it needs to be split up into smaller files
text1 <- text[1:225000]
text2 <- text[225001:667337]

textfile1 <- "./final/capstonePredictWord/cleanText1.rds"
textfile2 <- "./final/capstonePredictWord/cleanText2.rds"

## Save cleanText files in "./final/capstonePredictWord" dir of Shiny app
saveRDS(text1, textfile1)
saveRDS(text2, textfile2)
