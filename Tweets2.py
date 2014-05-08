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
### keywords for the public stream
keyword = "iPhone", "Samsung", "HTC", "Sony", "Blackberry"
### initialize blank list to contain tweets
tweets = []
### file name that you want to open is the second argument
f = open('today.txt', 'a')

class CustomStreamListener(tweepy.StreamListener):
    global tweets
    def on_status(self, status):
        ### info that you want to capture
        info = status.id, status.text, status.created_at, status.place, status.user, status.in_reply_to_screen_name, status.in_reply_to_status_id 
        for word in keyword:
            if word in status.text.lower():
                print status.text
                # this is for writing the tweets into the txt file
                f.write(str(info))
                try:
                    tweets.append(info)
                except:
                    pass
                

    def on_error(self, status_code):
        print >> sys.stderr, 'Encountered error with status code:', status_code
        return True # Don't kill the stream

    def on_timeout(self):
        print >> sys.stderr, 'Timeout...'
        return True # Don't kill the stream

### filter for location
# locations should be a pair of longtitude and latitude pairs, with the southwest corner
# of the bounding box coming first
sapi = tweepy.streaming.Stream(auth, CustomStreamListener())    
sapi.filter(locations=[103.60998,1.25752,104.03295,1.44973])

