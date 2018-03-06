# CapstoneProject
Next Word Prediction App

This is the Capstone project for the Coursera Data Science Specialization through John Hopkins University.

The goal is to design and implement a Shiny app which allows a user to enter a phrase and the app will predict and return the next word in the phrase.

An algorithm was created to predict the next word.  This algorithm makes use of "n-grams" created from samples of a large data set composed of text from blogs, news feeds and twitter posts.  The prediction of next words was based primarily on how frequent an "n-gram" matching the supplied phrase from the user is found in the samples from the data set.

A Shiny app was then constructed with a simple user interface to capture a phrase and then display the predicted next word to user.  The server side of the Shiny app takes the phrase as input, runs the phrase through the algorithm to generate the predicted next word, and then returns the next word to the user interface. 
