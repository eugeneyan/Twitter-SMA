import sys
import tweepy

consumer_key="Uyk7A893bypMmcpdWMSvB6VbZ"
consumer_secret="2Ml8ZkhmGllbeVSu98KnHtVpNmHCIXGaKQObVTXtBwwwDPmOHU"
access_key = "35109534-sPwWPITGOsKkFTKPhOwXqiRkWAb55QWgNrBtWURiC"
access_secret = "8AZWXWYDO1qaCSc2lltxGOPZV3OKpMdY5PzevBj9n5lpm"

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_key, access_secret)
api = tweepy.API(auth)
keyword = "who", "test"

class CustomStreamListener(tweepy.StreamListener):
    def on_status(self, status):
        if "at" in status.text.lower():
            print status.text

    def on_error(self, status_code):
        print >> sys.stderr, 'Encountered error with status code:', status_code
        return True # Don't kill the stream

    def on_timeout(self):
        print >> sys.stderr, 'Timeout...'
        return True # Don't kill the stream

# filter for location
# locations should be a pair of longtitude and latitude pairs, with the southwest corner
# of the bounding box coming first
sapi = tweepy.streaming.Stream(auth, CustomStreamListener())    
sapi.filter(locations=[103.60998,1.25752,104.03295,1.44973])

