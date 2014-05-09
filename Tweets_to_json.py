import sys
import tweepy
import json
import os

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_key, access_secret)
api = tweepy.API(auth)
# directory that you want to save the json file
os.chdir("C:\Users\IBM_ADMIN\Desktop\json_files")
# name of json file you want to create/open and append json to
save_file = open("11may.json", 'a')

class CustomStreamListener(tweepy.StreamListener):
    def __init__(self, api):
        self.api = api
        super(tweepy.StreamListener, self).__init__()

        self.list_of_tweets = []

    def on_data(self, tweet):
##        self.list_of_tweets.append(json.loads(tweet))
        print tweet
        save_file.write(str(tweet))

    def on_error(self, status_code):
        print >> sys.stderr, 'Encountered error with status code:', status_code
        return True # Don't kill the stream

    def on_timeout(self):
        print >> sys.stderr, 'Timeout...'
        return True # Don't kill the stream

sapi = tweepy.streaming.Stream(auth, CustomStreamListener(api))
sapi.filter(track=["Sony", "Xperia", "iPhone", "Apple", "Samsung", "s5", "note 3" "HTC", "Blackberry", "q5", "q10", "z10", "Nokia", "Lumia"])

