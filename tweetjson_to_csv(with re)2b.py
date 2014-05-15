import re
import os
import json
from csv import writer

# directory that you want to open the json file
## change this to the directory you story your files
os.chdir("C:\Users\IBM_ADMIN\Desktop\json_files")

# csv file that you want to save to
## change this to the file you want to save
out_file = open("test3.csv", "wb")

# json file list
## change filenames to the files you want to open
filenames = ["8may.json", "9may.json", "10may.json", "11may.json", "12may.json", "14may.json"]
open_files = map(open, filenames)

# keywords that you want to filter out; note that keywords should be in all lowercase
## change this to the keywords you want to use
keywords = ["samsung", "samsung's", "s4", "s4's", "s5", "s5's", "note 3", "note 3's", "htc", "htc's", "sony", "sony's", "xperia", "xperia's", "blackberry", "blackberry's", "q5", "q5's", "q10", "q10's", "z10", "z10's", "nokia", "nokia's", "lumia", "lumia's", "nexus", "nexus'", "nexus's", "huawei", "huawei's", "motorola", "motolora's"]

# iterates though the files and does keyword matching; the tweet is only saved in csv if the tweet["text"] matches the keywords
def load_json():
    for file in open_files:
        for line in file:
            # condition for searching through each line with keywords
            if line.rstrip() and re.findall(r'\b(%s)\b' % '|'.join(keywords), str(line).lower()):
                try:
                    datum = json.loads(line)
                except:
                    pass
                else:
                    yield datum
                    
# print header for csv file
csv = writer(out_file)
print >> out_file, "ids,text,time_created,retweet_counts,in_reply_to,geos,coordinates,places,language,screen_name,followers,friends,statuses,locations"

for tweet in load_json():
    # condition for searching through each tweet status with keywords
    if re.findall(r'\b(%s)\b' % '|'.join(keywords), tweet["text"].lower()):
        row = (tweet["id_str"], tweet["text"], tweet["created_at"], tweet["retweet_count"], tweet["in_reply_to_screen_name"], tweet["geo"], tweet["coordinates"], tweet["place"], tweet["lang"], tweet["user"]["screen_name"], tweet["user"]["followers_count"], tweet["user"]["friends_count"], tweet["user"]["statuses_count"], tweet["user"]["statuses_count"])
        row_utf8 = [(row_utf8.encode('utf8') if hasattr(row_utf8, 'encode') else row_utf8) for row_utf8 in row]
        csv.writerow(row_utf8)

print "json to csv conversion complete"
    
    
