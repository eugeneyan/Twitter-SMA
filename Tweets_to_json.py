import sys
import tweepy
import json
import os
import logging

consumer_key=""
consumer_secret=""
access_key = ""
access_secret = ""

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_key, access_secret)
api = tweepy.API(auth)
# directory that you want to save the json file
# os.chdir("C:\Users\IBM_ADMIN\Desktop\json_files")
# name of json file you want to create/open and append json to
save_file = open("16may.json", 'a')

# logging file for errors
logging.basicConfig(level = logging.DEBUG, filename = "exceptions.txt")

class CustomStreamListener(tweepy.StreamListener):
    def __init__(self, api):
        self.api = api
        super(tweepy.StreamListener, self).__init__()

        # self.list_of_tweets = []
        
    def on_data(self, tweet):
        print tweet 
        save_file.write(str(tweet))

    def on_error(self, status_code):
        print >> sys.stderr, 'Encountered error with status code:', status_code
        return True # Don't kill the stream
        print "Stream restarted"

    def on_timeout(self):
        print >> sys.stderr, 'Timeout...'
        return True # Don't kill the stream
        print "Stream restarted"

def start_stream():
    while True:
        try:
            sapi = tweepy.streaming.Stream(auth, CustomStreamListener(api))
            sapi.filter(track=["Samsung", "s4", "s5", "note" "3", "HTC", "Sony", "Xperia", "Blackberry", "q5", "q10", "z10", "Nokia", "Lumia", "Nexus", "Huawei", "Motorola"])
        except KeyboardInterrupt as int: 
            logging.exception("Error", int)
            break
        except Exception, err:
            logging.exception("Error", err)
            pass
        except:
            continue
            
start_stream()

