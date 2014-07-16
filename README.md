Twitter Streaming and Analysis with Python and R
================================================

Introduction
------------

The Git repository contains Python and R code for a mini project to analyse tweets on consumer electronic brands.  In the project, 15.3gb of tweets was downloaded from 13 - 25 may using Python and then analysed in R.  A deck on the project is available here: http://www.slideshare.net/eugeneyan/diving-into-twitter-data

About the scripts
-----------------

There are two main Python scripts that were used.

To download the data from Twitter's public streaming API, use the script listed below.  Just (i) plug in your Twitter authentication details, (ii) change the directory and name where you want to save the data, and (iii) change the list of keywords to track and you're good to go!
- tweets_to_json.py

To download process and filter the downloaded json files, and convert to csv format, use the scripts below.  Just (i) change the directory and name of the output file, (ii) the keywords you would like to filter on, (iii) and the fields you would like to keep.
- tweetjson_to_csv.py           ### does not have regular expression filtering
- tweetjson_to_csv(with re).py  ### has regular expression filtering
- tweetjson_to_csv(with re)b.py ### has regular expression filtering and saves fewer fields in my bid to reduce the output file size

To reference my R script and output, check out the SMA folder.  Feel free to use the R script as necessary though significant editing will be necessary (i.e., regular expression keywords, variable names, etc).

Enjoy!
