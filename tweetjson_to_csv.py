import re
import os
import json
from csv import writer

# global variable to store tweets in json
tweets = []

# global variables to store specific tweet info
# returns tweet-specific id
ids = []
# returns tweet text
texts = []
# returns time tweet was created
time_created = []
# returns number of times the tweet was retweeted
retweet_counts = []
# returns the user that the tweet was replying to
in_reply_to_screen_name = []
# returns latitude and longitude coordinates
geos = []
# returns also lat and long coordinates
coordinates = []
# returns country code, country, etc
places = []
# returns country 
places_country = []
# returns language
lang = []
# return the twitter name
user_screen_names = []
# returns the number of followers this user has
user_followers_count = []
# returns the number of users this user is following
user_friends_count = []
# returns the number of statuses user has posted
user_statuses_count = []
# returns free form text; not sure why it only returns numerics
user_locations = []

# directory that you want to open the json file
os.chdir("C:\Users\IBM_ADMIN\Desktop\json_files")

# csv file that you want to save to
out = open("unfiltered.csv", "ab")

filenames = ["8may.json", "9may.json", "10may.json", "11may.json", "12may.json"]
open_files = map(open, filenames)

# change argument to the file you want to open
for file in open_files:
    for line in file:
        # only keep tweets and not the empty lines
        if line.rstrip():
            try:
                tweets.append(json.loads(line))
            except:
                pass

for tweet in tweets:
    ids.append(tweet["id_str"])
    texts.append(tweet["text"])
    time_created.append(tweet["created_at"])
    retweet_counts.append(tweet["retweet_count"])
    in_reply_to_screen_name.append(tweet["in_reply_to_screen_name"])
    geos.append(tweet["geo"])
    coordinates.append(tweet["coordinates"])
    places.append(tweet["place"])
    # if there is no places data, then return None
    try:
        places_country.append(tweet["place"]["country"])
    except:
        places_country.append("None")
    lang.append(tweet["lang"])
    user_screen_names.append(tweet["user"]["screen_name"])
    user_followers_count.append(tweet["user"]["followers_count"])
    user_friends_count.append(tweet["user"]["friends_count"])
    user_statuses_count.append(tweet["user"]["statuses_count"])
    user_locations.append(tweet["user"]["statuses_count"])

print >> out, "ids,text,time_created,retweet_counts,in_reply_to,geos,coordinates,places,country,language,screen_name,followers,friends,statuses,locations"
rows = zip(ids,texts,time_created,retweet_counts,in_reply_to_screen_name,geos,coordinates,places,places_country,lang,user_screen_names,user_followers_count,user_friends_count,user_statuses_count,user_locations)

csv = writer(out)

for row in rows:
    values = [(value.encode('utf8') if hasattr(value, 'encode') else value) for value in row]
    csv.writerow(values)

out.close()

print "json to csv conversion complete"
    
    
