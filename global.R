
## This script will load the necessary files and functions used in the PredictNextWord Shiny app:
# cleanText (the data)
# profanity words to remove from ngrams
# function which contains prediction algorithm

library(stringr)
library(tidytext)

## Get and load list of profanity words from stored file
con <- file(description = "http://raw.githubusercontent.com/brooney27519/CapstoneProject/master/full-list-of-bad-words-banned-by-google.txt", open = "r")
bad <- readLines(con)
close(con)
bad <- str_trim(bad)

## Create list of stopwords
data(stop_words)
stop_wds <- stop_words[which(stop_words$lexicon == 'snowball'),]

my_words <- c("lol","wanna","bout","haha","hahaha","yea","yay","michael","ppl","tho","smh","joe","chris",
              "steve","matt","btw","tim","boo","los","omfg","hah","mon","ooh","del","hoes","z","zz","zzz","//","@")

words_to_remove <- c(stop_wds$word,my_words,bad)

# read in RDS files containing text used as the data
con1 <- file(description = "http://raw.githubusercontent.com/brooney27519/CapstoneProject/master/cleanText1.rds", open = "rb")
text1 <- readRDS(con1)
close(con1)

con2 <- file(description = "http://raw.githubusercontent.com/brooney27519/CapstoneProject/master/cleanText2.rds", open = "rb")
text2 <- readRDS(con2)
close(con2)

text <- c(text1, text2)

## This function is the algorithm that predicts the next word for a given phrase
get_next_word <- function(phrase) {
  
  split_phrase <- unlist(strsplit(phrase," ",fixed = TRUE))
  len_sp <- length(split_phrase)
  max <- 4
  wds <- vector()
  
  if(len_sp <= max) {
    j <- 1
    while(j < (len_sp + 1)) {
      wds <- append(wds,tolower(split_phrase[j]))
      j <- j + 1
    }
  } else {
    i <- len_sp - max + 1
    while(i < (len_sp + 1)) {
      wds <- append(wds,tolower(split_phrase[i]))
      i <- i + 1
    }
  }
  
  next_word <- tibble()
  
  # try 5gram if user gave 4 or more words
  if( (!is.na(wds[1])) && (!is.na(wds[2])) && (!is.na(wds[3])) && (!is.na(wds[4])) ) {
    pattern <- paste0(wds[1],".",wds[2],".",wds[3],".",wds[4])
    subtext <- grep(pattern, text, value = TRUE)
    if(length(subtext) > 0) {
      df_subtext <- data_frame(line = 1:length(subtext), each_text = subtext)
      next_word <- df_subtext %>% unnest_tokens(output = word,input = each_text, token = "ngrams", n=5) %>%
        separate(word, c("word1","word2","word3","word4","word5"), sep = " ") %>%
        filter(word1 %in% wds[1]) %>%
        filter(word2 %in% wds[2]) %>%
        filter(word3 %in% wds[3]) %>%
        filter(word4 %in% wds[4]) %>%
        filter(!word5 %in% c(words_to_remove,wds[4])) %>%
        count(word1, word2, word3, word4, word5, sort = TRUE) %>%
        select(word5, n) %>% head(5)
    }
  }
  
  # try 4gram if no results yet or user gave 3 words
  if( nrow(next_word)==0 && (!is.na(wds[1])) && (!is.na(wds[2])) && (!is.na(wds[3])) ) {
    pattern <- paste0(wds[1],".",wds[2],".",wds[3])
    subtext <- grep(pattern, text, value = TRUE)
    if(length(subtext) > 0) {
      df_subtext <- data_frame(line = 1:length(subtext), each_text = subtext)
      next_word <- df_subtext %>% unnest_tokens(output = word,input = each_text, token = "ngrams", n=4) %>%
        separate(word, c("word1","word2","word3","word4"), sep = " ") %>%
        filter(word1 %in% wds[1]) %>%
        filter(word2 %in% wds[2]) %>%
        filter(word3 %in% wds[3]) %>%
        filter(!word4 %in% c(words_to_remove,wds[3])) %>%
        count(word1, word2, word3, word4, sort = TRUE) %>%
        select(word4, n) %>% head(5)
    }
  }
  
  # try 3gram if no results yet or user gave 2 words
  
  if(nrow(next_word)==0 && (!is.na(wds[1])) && (!is.na(wds[2])) ) {
    pattern <- paste0(as.character(wds[1]),".",as.character(wds[2]))
    subtext <- grep(pattern, text, value = TRUE)
    if(length(subtext) > 0) {
      df_subtext <- data_frame(line = 1:length(subtext), each_text = subtext)
      next_word <- df_subtext %>% unnest_tokens(output = word,input = each_text, token = "ngrams", n=3) %>%
        separate(word, c("word1","word2","word3"), sep = " ") %>%
        filter(word1 == wds[1]) %>%
        filter(word2 == wds[2]) %>%
        filter(!word3 %in% c(words_to_remove,wds[2])) %>%
        count(word1, word2, word3, sort = TRUE) %>%
        select(word3, n) %>% head(5)
    }
  }
  
  # try unigram if still no results
  if(nrow(next_word)==0) {
    pattern <- paste0(wds[1],"|",wds[2])
    subtext <- grep(pattern, text, value = TRUE)
    df_subtext <- data_frame(line = 1:length(subtext), each_text = subtext)
    next_word <- df_subtext %>% unnest_tokens(output = word,input = each_text, token = "ngrams", n=2) %>%
      separate(word, c("word1","word2"), sep = " ") %>%
      filter(word1 %in% c(wds[1],wds[2])) %>%
      filter(!word2 %in% c(words_to_remove,wds[1])) %>%
      count(word1, word2, sort = TRUE) %>%
      select(word2, n) %>% head(5)
  }
  
  return(next_word)
}
## END OF FUNCTION: get_next_word