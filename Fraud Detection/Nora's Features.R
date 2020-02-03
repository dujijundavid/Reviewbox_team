##### try to aggregate data at a monthly basis | 2019/12
## read the review data
data_review <- read.csv("review_af_1.csv")
#data_review$weekdays <- weekdays(as.Date(data_review$date))

library(lubridate)
library(dplyr)
#process time attribute

data_review$date1 <- as.POSIXct(data_review$date, "%Y-%m-%d %H:%M", origin = "1900-01-01", tz = "GMT")

mostrecent <- max(data_review$date1)
recentweek <- week(mostrecent)


#data_review$weeknum <- isoweek(data_review$date1)
data_review$weeknum1 <- week(data_review$date1) #use this parameter

data_review$product <- as.character(data_review$product)

#I only kept reviews that are posted in last 36 weeks (9 months)
recent_12wks_reviews <- data_review %>%
  filter(year(data_review$date1) == 2019 & week(data_review$date1) >= 30)

recent_24wks_reviews <- data_review %>%
  filter(year(data_review$date1) == 2019 & week(data_review$date1) >= 18 & week(data_review$date1) < 30)

recent_36wks_reviews <- data_review %>%
  filter(year(data_review$date1) == 2019 & week(data_review$date1) >= 6 & week(data_review$date1) < 18)

#Count number of all ratings in each 3 months
stardistri_last_1Q <- recent_12wks_reviews %>%
  group_by(product) %>%
  count()

stardistri_last_2Q <- recent_24wks_reviews %>%
  group_by(product) %>%
  count()

stardistri_last_3Q <- recent_36wks_reviews %>%
  group_by(product) %>%
  count()

# select and count one star reviews by product
onestar_last_1Q <- recent_12wks_reviews  %>%
      group_by(product) %>%
      filter(stars == 1) %>%
      count()

onestar_last_2Q <- recent_24wks_reviews %>%
  group_by(product) %>%
  filter(stars == 1) %>%
  count()

onestar_last_3Q <- recent_36wks_reviews %>%
  group_by(product) %>%
  filter(stars == 1) %>%
  count()

# select and count five star reviews by product
fivestar_last_1Q <- recent_12wks_reviews %>%
  group_by(product) %>%
  filter(stars == 5) %>%
  count()

fivestar_last_2Q <- recent_24wks_reviews %>%
  group_by(product) %>%
  filter(stars == 5) %>%
  count()

fivestar_last_3Q <- recent_36wks_reviews %>%
  group_by(product) %>%
  filter(stars == 5) %>%
  count()

#create new dataframe with the potential attributes
library(sqldf)
label <- sqldf("select distinct product, label from data_review")
byproduct <- sqldf("select distinct d.product, l.label, o1.n, o2.n, o3.n, f1.n, f2.n, f3.n, sd1.n, sd2.n, sd3.n from data_review d
                   left outer join onestar_last_1Q o1 on d.product = o1.product
                   left outer join onestar_last_2Q o2 on d.product = o2.product
                   left outer join onestar_last_3Q o3 on d.product = o3.product
                   left outer join fivestar_last_1Q f1 on d.product = f1.product
                   left outer join fivestar_last_2Q f2 on d.product = f2.product
                   left outer join fivestar_last_3Q f3 on d.product = f3.product
                   left outer join stardistri_last_1Q sd1 on d.product = sd1.product
                   left outer join stardistri_last_2Q sd2 on d.product = sd2.product
                   left outer join stardistri_last_3Q sd3 on d.product = sd3.product
                   left outer join label l on l.product = d.product")
colnames(byproduct) <- c("ID", "label", "1star_last_1Q", "1star_last_2Q", "1star_last_3Q", "5star_last_1Q", "5star_last_2Q"
                         , "5star_last_3Q", "all_ratings_last_1Q", "all_ratings_last_2Q", "all_ratings_last_3Q")

# try to create more attributes:
# change in count of 1 star reviews compared to last quarter
byproduct$att1 <- byproduct$`1star_last_1Q` / byproduct$`1star_last_2Q`
# change in count of 5 star reviews compared to last quarter
byproduct$att2 <- byproduct$`5star_last_1Q` / byproduct$`5star_last_2Q`
# change in delta 1 star reviews compared to last quarter
byproduct$att3 <- (byproduct$`1star_last_1Q` / byproduct$`1star_last_2Q` - 1) / 
                  (byproduct$`1star_last_2Q` / byproduct$`1star_last_3Q` - 1)
# change in delta 5 star reviews compared to last quarter
byproduct$att4 <- (byproduct$`5star_last_1Q` / byproduct$`5star_last_2Q`) - 1 / 
                  (byproduct$`5star_last_2Q` / byproduct$`5star_last_3Q`) - 1
# change in proportion of 1 star reviews compared to last quarter
byproduct$att5 <- byproduct$`1star_last_1Q`/byproduct$all_ratings_last_1Q - byproduct$`1star_last_2Q`/byproduct$all_ratings_last_2Q
# change in proportion of 5 star reviews compared to last quarter
byproduct$att6 <- byproduct$`5star_last_1Q`/byproduct$all_ratings_last_1Q - byproduct$`5star_last_2Q`/byproduct$all_ratings_last_2Q
# change in number of reviews
byproduct$att7 <- byproduct$all_ratings_last_1Q - byproduct$all_ratings_last_2Q

# write the new table
write.csv(file = "review_by_product.csv", byproduct)

# modeling (not enough observation for the modeling part, pls skip the following parts)
byproduct_reg <- filter(byproduct, att3 != Inf)
byproduct_reg <- filter(byproduct_reg, att3 != -Inf)
byproduct_reg$label <- factor(byproduct_reg$label, levels = c("a", "f"), order = TRUE)
library(ISLR)
regression <- glm(label ~ att1 + att2 + att3 + att4 + att5 + att6 + att7, data = byproduct_reg, family = "binomial")
summary(regression)

# model2 <- step(object = regression, trace = 0)

regression2 <- glm(label ~ att5 + att6 + att7, data = byproduct, family = "binomial")
summary(regression2)
