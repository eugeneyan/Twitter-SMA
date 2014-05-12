import sys
import tweepy
import json
import os

consumer_key="Uyk7A893bypMmcpdWMSvB6VbZ"
consumer_secret="2Ml8ZkhmGllbeVSu98KnHtVpNmHCIXGaKQObVTXtBwwwDPmOHU"
access_key = "35109534-sPwWPITGOsKkFTKPhOwXqiRkWAb55QWgNrBtWURiC"
access_secret = "8AZWXWYDO1qaCSc2lltxGOPZV3OKpMdY5PzevBj9n5lpm"

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_key, access_secret)
api = tweepy.API(auth)
# directory that you want to save the json file
# os.chdir("C:\Users\IBM_ADMIN\Desktop\json_files")
# name of json file you want to create/open and append json to
save_file = open("12may.json", 'a')

class CustomStreamListener(tweepy.StreamListener):
    def __init__(self, api):
        self.api = api
        super(tweepy.StreamListener, self).__init__()

        self.list_of_tweets = []

    def on_data(self, tweet):
        # self.list_of_tweets.append(json.loads(tweet))
        # print tweet
        save_file.write(str(tweet))

    def on_error(self, status_code):
        print >> sys.stderr, 'Encountered error with status code:', status_code
        return True # Don't kill the stream

    def on_timeout(self):
        print >> sys.stderr, 'Timeout...'
        return True # Don't kill the stream

sapi = tweepy.streaming.Stream(auth, CustomStreamListener(api))
sapi.filter(track=["Sony", "Xperia", "iPhone", "Apple", "Samsung", "s4", "s5", "note" "3", "HTC", "Blackberry", "q5", "q10", "z10", "Nokia", "Lumia", "Nexus", "LG", "Huawei", "Motorola"])

