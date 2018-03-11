# CapstoneProject
<h3>Next Word Prediction App</h3>

This is the Capstone project for the Coursera Data Science Specialization through John Hopkins University.

The goal is to design and implement a Shiny app which allows a user to enter a phrase and the app will predict and return the next word in the phrase.

An algorithm was created to predict the next word.  This algorithm makes use of "n-grams" created from samples of a large data set composed of text from blogs, news feeds and twitter posts.  The prediction of next words was based primarily on how frequent an "n-gram" matching the supplied phrase from the user is found in the samples from the data set.

A Shiny app was then constructed with a simple user interface to capture a phrase and then display the predicted next word to user.  The server side of the Shiny app takes the phrase as input, runs the phrase through the algorithm to generate the predicted next word, and then returns the next word to the user interface. 

<h3>File Information</h3>

<ul>
<li><strong>app.R</strong>: Shiny app which displays the predicted next word and a list of next best predictions. app.R sources (calls) the gloabl.R file which the Shiny app is launched.</li>

<li><strong>global.R</strong> does the following tasks:
<ol>
<li>1) loads "full-list-of-bad-words-banned-by-google.txt" which is used to remove profanity from text.</li>
<li>2) loads the "cleanText1.rds" and "cleanText2.rds" files which contain cleaned text used by the prediction algorithm.</li>
<li>3) loads the "get_next_word" function which is the algorithm used to predict the next word for the given phrase.</li>
</ol>
</li>

<li><strong>createCleanTextFile.R</strong>: this script is used to clean the source text and then generate the "cleanText1.RDS" and "cleanText2.RDS" files.</li>
