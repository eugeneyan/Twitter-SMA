# import data 
may11 <- read.csv("C:\\Users\\IBM_ADMIN\\Desktop\\json_files\\11may.csv")
summary(may11)
View(may11)
View(may11$text[2])

# how grep works
grep("Sony", may11$text, ignore.case = T)

# add additional column for tags to brands
may11[, c("Sony", "Xperia", "Apple", "iPhone", "Samsung", "S5", "Note3", "HTC", "Blackberry", "Q5", "Q10", "Z10")] <- NA

# search through tweet_texts; if tweet text contains keyword assign 1 to keyword column
may11$Sony[grep("Sony", may11$text, ignore.case = T)] <- 1
may11$Xperia[grep("Xperia", may11$text, ignore.case = T)] <- 1
may11$Apple[grep("Apple", may11$text, ignore.case = T)] <- 1
may11$iPhone[grep("iPhone", may11$text, ignore.case = T)] <- 1
may11$Samsung[grep("Samsung", may11$text, ignore.case = T)] <- 1
may11$S5[grep("s5", may11$text, ignore.case = T)] <- 1
may11$Note3[grep("Note 3", may11$text, ignore.case = T)] <- 1
may11$HTC[grep("HTC", may11$text, ignore.case = T)] <- 1
may11$Blackberry[grep("Blackberry", may11$text, ignore.case = T)] <- 1
may11$Q5[grep("q5", may11$text, ignore.case = T)] <- 1
may11$Q10[grep("q10", may11$text, ignore.case = T)] <- 1
may11$Z10[grep("z10", may11$text, ignore.case = T)] <- 1

brands <- may11[, c("Sony", "Xperia", "Apple", "iPhone", "Samsung", "S5", "Note3", "HTC", "Blackberry", "Q5", "Q10", "Z10")]
brand_total <- colSums(brands, na.rm = T)
View(brand_total)
barplot(brand_total)
