import sys
import tweepy
import json
import pymongo

consumer_key="Uyk7A893bypMmcpdWMSvB6VbZ"
consumer_secret="2Ml8ZkhmGllbeVSu98KnHtVpNmHCIXGaKQObVTXtBwwwDPmOHU"
access_key = "35109534-sPwWPITGOsKkFTKPhOwXqiRkWAb55QWgNrBtWURiC"
access_secret = "8AZWXWYDO1qaCSc2lltxGOPZV3OKpMdY5PzevBj9n5lpm"

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_key, access_secret)
api = tweepy.API(auth)
# initialize blank list to contain tweets
tweets = []
# file name that you want to open is the second argument
file = open('8may.json', 'a')

class CustomStreamListener(tweepy.StreamListener):
    def __init__(self, api):
        self.api = api
        super(tweepy.StreamListener, self).__init__()

        self.file = tweets

    def on_data(self, tweet):
        self.file.append(json.loads(tweet))
        print tweet
        file.write(str(tweet))

    def on_status(self, status):
        print status.text

    def on_error(self, status_code):
        print >> sys.stderr, 'Encountered error with status code:', status_code
        return True # Don't kill the stream

    def on_timeout(self):
        print >> sys.stderr, 'Timeout...'
        return True # Don't kill the stream

sapi = tweepy.streaming.Stream(auth, CustomStreamListener(api))
sapi.filter(track=["Sony", "sony", "Xperia", "xperia", "PS4", "ps4"])

