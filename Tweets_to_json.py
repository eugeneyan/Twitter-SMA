import sys
import tweepy
import json

consumer_key=" "
consumer_secret=" "
access_key = " "
access_secret = " "

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_key, access_secret)
api = tweepy.API(auth)
# initialize blank list to contain tweets
tweets = []
# file name that you want to open is the second argument
save_file = open('9may.json', 'a')

class CustomStreamListener(tweepy.StreamListener):
    def __init__(self, api):
        self.api = api
        super(tweepy.StreamListener, self).__init__()

        self.save_file = tweets

    def on_data(self, tweet):
        self.save_file.append(json.loads(tweet))
        print tweet
        save_file.write(str(tweet))

    def on_error(self, status_code):
        print >> sys.stderr, 'Encountered error with status code:', status_code
        return True # Don't kill the stream

    def on_timeout(self):
        print >> sys.stderr, 'Timeout...'
        return True # Don't kill the stream

sapi = tweepy.streaming.Stream(auth, CustomStreamListener(api))
sapi.filter(track=["Sony", "sony", "Xperia", "xperia", "PS4", "ps4"])

