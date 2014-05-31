library(data.table)
library(ggplot2)
library(RSQLite)

#####################################################
# Trial Data (Friday 8 May, 8am - 9am)
#####################################################
# Exploratory Analysis

# import test data
test <- read.csv("C:\\Users\\IBM_ADMIN\\Desktop\\json_files\\test.csv")
test <- setDT(test)
View(test)

# create columns
test[, c("apple", "iphone", "samsung", "s4", "s5", "note_3", "htc", "sony", "xperia", "blackberry", "q5", "q10", "z10", "nokia", "lumia", "huawei", "motorola")] <- NA

# create flags for keywords
test$apple[grep("apple", test$text, ignore.case = T)] <- 1
test$iphone[grep("iphone", test$text, ignore.case = T)] <- 1
test$samsung[grep("samsung", test$text, ignore.case = T)] <- 1
test$s4[grep("s4", test$text, ignore.case = T)] <- 1
test$s5[grep("s5", test$text, ignore.case = T)] <- 1
test$note_3[grep("note 3", test$text, ignore.case = T)] <- 1
test$htc[grep("htc", test$text, ignore.case = T)] <- 1
test$sony[grep("xperia", test$text, ignore.case = T)] <- 1
test$blackberry[grep("blackberry", test$text, ignore.case = T)] <- 1
test$q5[grep("q5", test$text, ignore.case = T)] <- 1
test$q10[grep("q10", test$text, ignore.case = T)] <- 1
test$z10[grep("z10", test$text, ignore.case = T)] <- 1
test$nokia[grep("nokia", test$text, ignore.case = T)] <- 1
test$lumia[grep("lumia", test$text, ignore.case = T)] <- 1
test$nexus[grep("nexus", test$text, ignore.case = T)] <- 1
test$huawei[grep("huawei", test$text, ignore.case = T)] <- 1
test$motorola[grep("motorola", test$text, ignore.case = T)] <- 1
test$xperia[grep("xperia", test$text, ignore.case = T)] <- 1
test$lumia[grep("lumia", test$text, ignore.case = T)] <- 1
View(test)

# subset and select only keyword columns
test_frame <- test[, c("apple", "iphone", "samsung", "s4", "s5", "note_3", "htc", "sony", "xperia", "blackberry", "q5", "q10", "z10", "nokia", "lumia", "huawei", "motorola"), with = F]

# create table with sums of each keyword
test_total <- data.table(keywords = c("apple", "iphone", "samsung", "s4", "s5", "note_3", "htc", "sony", "xperia", "blackberry", "q5", "q10", "z10", "nokia", "lumia", "huawei", "motorola"), tweets = colSums(test_frame, na.rm = T))

# ggplot of test_total
ggplot(data = test_total, aes(x = reorder(keywords, -tweets), y = tweets, fill = keywords)) + geom_bar(stat = "identity", aes(y = tweets)) + geom_text(aes(label = tweets), position = position_dodge(width = 0.9), vjust=-0.3) + labs(title = "No. of tweets/keyword (Trial run: Friday 9 May, 8am - 9am)", x = "Keywords", y = "Number of tweets", size = 20) + coord_cartesian(ylim = c(0, 7500)) + theme(axis.text=element_text(size=12), axis.title=element_text(size=12,face="bold"), title=element_text(size=14,face="bold"))

#####################################################
# Trial Data (Friday 8 May, 8am - 9am)
#####################################################
# Tidying the Data
# Plot of Brand, Brand Sentiment, and Brand over time

# Import the data; test data is 11mayb.json
test <- read.csv("C:\\Users\\IBM_ADMIN\\Desktop\\json_files\\test.csv")
test <- setDT(test)

# Create columns for brands and sentiment
test[, c("apple", "samsung", "htc", "sony", "blackberry", "nokia", "huawei", "motorola", "brand_overlap", "positive", "negative", "sen_overlap")] <- NA
str(test)

# create flags for keywords
test$apple[grep("apple", test$text, ignore.case = T)] <- 1
test$samsung[grep("samsung", test$text, ignore.case = T)] <- 1
test$htc[grep("htc", test$text, ignore.case = T)] <- 1
test$sony[grep("sony", test$text, ignore.case = T)] <- 1
test$blackberry[grep("blackberry", test$text, ignore.case = T)] <- 1
test$nokia[grep("nokia", test$text, ignore.case = T)] <- 1
test$huawei[grep("huawei", test$text, ignore.case = T)] <- 1
test$motorola[grep("motorola", test$text, ignore.case = T)] <- 1
test$brand_overlap <- rowSums(test[, c(9:16), with = F], na.rm = T)
summary(test)

# remove overlaps for brands
test <- subset(test, brand_overlap == 1)

# load in positive and negative words
pos <- read.csv("positive.csv", header = F, stringsAsFactors=FALSE)$V1
neg <- read.csv("negative.csv", header = F, stringsAsFactors=FALSE)$V1
str(pos)
str(neg)

# create flags for positive, negative, and overlaps
test$positive[grep(paste(pos, collapse="|"), test$text, ignore.case=T)] <- 1
test$negative[grep(paste(neg, collapse="|"), test$text, ignore.case=T)] <- 1
test$sen_overlap <- as.numeric(test$positive == 1 & test$negative == 1)
sum(test$sen_overlap, na.rm = T)
sum(test$positive, na.rm = T)
sum(test$negative, na.rm = T)

# remove overlaps for sentiment
test <- test[!sen_overlap %in% "1", ]
sum(test$sen_overlap, na.rm = T)
sum(test$positive, na.rm = T)
sum(test$negative, na.rm = T)

# create new column for Brand and Sentiment
test[, c("brand", "sentiment")] <- NA
test$brand[test$apple == 1] <- "apple"
test$brand[test$samsung == 1] <- "samsung"
test$brand[test$htc == 1] <- "htc"
test$brand[test$sony == 1] <- "sony"
test$brand[test$blackberry == 1] <- "bb"
test$brand[test$nokia == 1] <- "nokia"
test$brand[test$huawei == 1] <- "huawei"
test$brand[test$motorola == 1] <- "moto"
test$sentiment[test$positive == 1] <- "pos"
test$sentiment[test$negative == 1] <- "neg"
test$sentiment[is.na(test$sentiment)] <- "neu"
View(test)

# subset data table to only keep initial data and brand and sentiment columns
test <- subset(test, select = c(text: locations, brand, sentiment))

# add factor to brands to sort my decreasing order
test <- within(test,
               brand <- factor(brand, 
                               levels = names(sort(table(brand), decreasing = T))))

# reorder sentiment factor
test$sentiment <- factor(test$sentiment, c('neg', 'pos', 'neu'))

# plot ggplot of brands
ggplot(data = test, aes(x = brand, fill = brand)) + geom_bar(width = 1) + stat_bin(aes(label = sprintf("%.02f %%", ..count../sum(..count..)*100)), geom = 'text', vjust = -0.3) + labs(title = "No. of tweets/keyword (Trial run: Friday 9 May, 8am - 9am)", x = "Keywords", y = "Number of tweets", size = 20) + theme(axis.text=element_text(size=12), axis.title=element_text(size=12,face="bold"), title=element_text(size=14,face="bold"))

# plot ggplot of brands and sentiment
ggplot(data = test, aes(x = brand, fill = factor(sentiment))) + geom_bar(position = 'dodge') + stat_bin(aes(label = sprintf("%.02f %%", ..count../sum(..count..)*100)), geom = 'text', position = position_dodge(width = 0.9), vjust=-0.3) + labs(title = "Brand Sentiment (Trial run: Friday 9 May, 8am - 9am)", x = "Brands", y = "Number of tweets", fill=guide_legend(title="Sentiment"), size = 20) + theme(axis.text=element_text(size=12), axis.title=element_text(size=12,face="bold"), title=element_text(size=14,face="bold")) 

# add timestamps
test$time <- as.POSIXct(gsub("^.+? | \\+\\d{4}","", test$time_created), format = "%b %d %X %Y")

# plot ggplot of brand tweets over time
ggplot(data = test, aes(x = time, y = ..count..)) + geom_density(aes(fill = brand), position="stack") + labs(title = "Brand Tweets over Time (Trial run: Friday 9 May, 8am - 9am)", x = "Time", y = "Density", fill=guide_legend(title="Brands"),size = 20) + theme(axis.text=element_text(size=12), axis.title=element_text(size=12,face="bold"), title=element_text(size=14,face="bold"))

#########################################################
# Actual Data (13 May - 24 May)
#########################################################
# Tidying the Data
# Plot of Brand, Brand Sentiment, and Brand over time

# import data; initial number of tweets 4365495
tweets <- read.csv("C:\\Users\\IBM_ADMIN\\Desktop\\json_files\\tweets.csv")
tweets <- setDT(tweets)
str(tweets)

# add additional column for tags to brands
tweets[, c("time", "samsung", "htc", "sony", "blackberry", "nokia", "motorola", "huawei", "brand_overlap", "positive", "negative", "sen_overlap")] <- NA
str(tweets)

# how grep works
grep("Sony", tweets$text, ignore.case = T)

# create flags for brands and brand overlap
tweets$samsung[grep("samsung", tweets$text, ignore.case = T)] <- 1
tweets$htc[grep("htc", tweets$text, ignore.case = T)] <- 1
tweets$sony[grep("sony", tweets$text, ignore.case = T)] <- 1
tweets$blackberry[grep("blackberry", tweets$text, ignore.case = T)] <- 1
tweets$nokia[grep("nokia", tweets$text, ignore.case = T)] <- 1
tweets$huawei[grep("huawei", tweets$text, ignore.case = T)] <- 1
tweets$motorola[grep("motorola", tweets$text, ignore.case = T)] <- 1
tweets$brand_overlap <- rowSums(tweets[, c(10:16), with = F], na.rm = T)

# remove overlaps for brands; after removing overlaps left with 3553983
tweets <- subset(tweets, brand_overlap == 1)

# load in positive and negative words
pos <- read.csv("positive.csv", header = F, stringsAsFactors=FALSE)$V1
neg <- read.csv("negative.csv", header = F, stringsAsFactors=FALSE)$V1
str(pos)
str(neg)

##########################
# Sentiment Analysis
##########################
# interesting observation: Blackberry hase almost 100% negative sentiment!  
# found the cause: the negative word "LACK" was causing all the false positives haha

# create flags for positive, negative, and overlaps
tweets$positive[grep(paste(pos, collapse="|"), tweets$text, ignore.case=T)] <- 1
tweets$negative[grep(paste(neg, collapse="|"), tweets$text, ignore.case=T)] <- 1
tweets$sen_overlap <- as.numeric(tweets$positive == 1 & tweets$negative == 1)
sum(tweets$sen_overlap, na.rm = T)
sum(tweets$positive, na.rm = T)
sum(tweets$negative, na.rm = T)

# remove overlaps for sentiment; after removing overlaps left with 3234678 
tweets <- tweets[!sen_overlap %in% "1", ]
sum(tweets$sen_overlap, na.rm = T)
sum(tweets$positive, na.rm = T)
sum(tweets$negative, na.rm = T)

# create new column for Brand and Sentiment
tweets[, c("brand", "sentiment")] <- NA
tweets$brand[tweets$samsung == 1] <- "Samsung"
tweets$brand[tweets$htc == 1] <- "HTC"
tweets$brand[tweets$sony == 1] <- "Sony"
tweets$brand[tweets$blackberry == 1] <- "Blackberry"
tweets$brand[tweets$nokia == 1] <- "Nokia"
tweets$brand[tweets$huawei == 1] <- "Huawei"
tweets$brand[tweets$motorola == 1] <- "Motorola"
tweets$sentiment[tweets$positive == 1] <- "Positive"
tweets$sentiment[tweets$negative == 1] <- "Negative"
tweets$sentiment[is.na(tweets$sentiment)] <- "Neutral"
str(tweets)

# add timestamps
tweets$time <- as.POSIXct(gsub("^.+? | \\+\\d{4}","", tweets$time_created), format = "%b %d %X %Y")

# subset data table to only keep initial data and brand and sentiment columns
tweets <- subset(tweets, select = c(text:locations, time, brand, sentiment))

# add factor to brands to sort my decreasing order
tweets <- within(tweets,
                 brand <- factor(brand, 
                                 levels = names(sort(table(brand), decreasing = T))))

# reorder sentiment factor
tweets$sentiment <- factor(tweets$sentiment, c('Negative', 'Positive', 'Neutral'))

# save tweets data table so we don't have to process it again
save(tweets, file = 'tweets.Rda')

# create same of tweets and save it for sharing
tweets_sam <- tweets[sample(nrow(tweets), 100), ]
dput(tweets_sam, file = 'tweets_sam.R')


# configure DB and save tweets processed data to database
drv <- dbDriver('SQLite')
tweet_file <- 'tweets.db'
con <- dbConnect(drv, dbname = tweet_file)
dbWriteTable(con, )

dbWriteTable(con, "TWEETS", tweets)
dbDisconnect(con)

# plots should be 1500 x 650
# plot ggplot of brands
ggplot(data = tweets, aes(x = brand, fill = brand)) + geom_bar(width = 1) + stat_bin(aes(label = sprintf("%.02f %%", ..count../sum(..count..)*100)), geom = 'text', vjust = -0.3) + labs(title = "No. of tweets/keyword (13 - 24 May)", x = "Keywords", y = "Number of tweets", fill=guide_legend(title="Brand"), size = 20) + theme(axis.text=element_text(size=20), axis.title=element_text(size=22,face="bold"), title=element_text(size=20,face="bold"), legend.text=element_text(size=14))

# plot ggplot of brands and sentiment
ggplot(data = tweets, aes(x = brand, fill = factor(sentiment))) + geom_bar(position = 'dodge') + stat_bin(aes(label = sprintf("%.02f %%", ..count../sum(..count..)*100)), geom = 'text', position = position_dodge(width = 0.9), vjust=-0.3) + labs(title = "Brand Sentiment (13 - 24 May)", x = "Brands", y = "Number of tweets", fill=guide_legend(title="Sentiment"), size = 20) + theme(axis.text=element_text(size=20), axis.title=element_text(size=22,face="bold"), title=element_text(size=20,face="bold"), legend.text=element_text(size=14))

# plot ggplot of brand tweets over time
ggplot(data = tweets, aes(x = time, y = ..count..)) + geom_density(aes(fill = brand), position="stack") + labs(title = "Brand Tweets over Time (13 - 24 May)", x = "Time", y = "Density", fill=guide_legend(title="Brands"),size = 20) + theme(axis.text=element_text(size=20), axis.title=element_text(size=22,face="bold"), title=element_text(size=20,face="bold"), legend.text=element_text(size=14))
