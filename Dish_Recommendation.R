json_df	<- fromJSON("yelp_academic_dataset_business.json")
restaurant_subset <- json_df[grep("Chinese",json_df$categories),]
chinese_subset <- as.data.frame(restaurant_subset$business_id,stringsAsFactors = FALSE)

json_df1 <- fromJSON("yelp_academic_dataset_review.json")
chinese_sub <- chinese_subset[,1]
temp_df1 <- json_df1[json_df1$business_id %in% chinese_sub,]
chinese_restaurant_reviews <- temp_df1[,c(3,4,6,8)]

dish_df <- read.csv("dishes1.txt",header = FALSE,col.names = c("dish_name"),stringsAsFactors = FALSE)
dish_df <- cbind.data.frame(dish_df,pos_rev_count=0,neg_rev_count=0)
chinese_restaurant_pos_rev <- chinese_restaurant_reviews[chinese_restaurant_reviews$stars>=3,]
chinese_restaurant_neg_rev <- chinese_restaurant_reviews[chinese_restaurant_reviews$stars<3,]
total_pos_business <- length(unique(chinese_restaurant_pos_rev$business_id))
total_neg_business <- length(unique(chinese_restaurant_neg_rev$business_id))
total_res_business <- length(unique(chinese_restaurant_reviews$business_id))

#1. Loop through positive restaurant reviews and count the dishes
for(dish_count in 1:nrow(dish_df)) {
  
  business_pos_list <- list()
  total_dish_count <- 0
  
  cat("dish_count : ",dish_count,"\n")
  
  for (i in 1:nrow(chinese_restaurant_pos_rev)) {
    myCorpus	<- Corpus(VectorSource(chinese_restaurant_pos_rev[i,]$text))
    myCorpus	<- tm_map(myCorpus,	PlainTextDocument)
    myCorpus	<- tm_map(myCorpus,	tolower)
    phrase_count <- phrase.count(tolower(dish_df[dish_count,1]),myCorpus)
    total_dish_count = total_dish_count + phrase_count
    
    if (phrase_count > 0) {
      if (length(business_pos_list)==0) 
      { business_pos_list <- c(chinese_restaurant_pos_rev[i,]$business_id)
      } else {
        business_pos_list <- c(business_pos_list,chinese_restaurant_pos_rev[i,]$business_id)
      }      
    }

  }
  
  print(total_dish_count)
  print(length(unique(business_pos_list)))
  print(total_pos_business)
  final_dish_count <- (total_dish_count * length(unique(business_pos_list)))/total_res_business
  print(final_dish_count)
  dish_df[dish_count,2] <- final_dish_count
  
}

#2. Loop through negative restaurant reviews and count the dishes
for(dish_count in 1:nrow(dish_df)) {
  
  business_pos_list <- list()
  total_dish_count <- 0
  
  cat("dish_count : ",dish_count,"\n")
  
  for (i in 1:nrow(chinese_restaurant_neg_rev)) {
    myCorpus	<- Corpus(VectorSource(chinese_restaurant_neg_rev[i,]$text))
    myCorpus	<- tm_map(myCorpus,	PlainTextDocument)
    myCorpus	<- tm_map(myCorpus,	tolower)
    phrase_count <- phrase.count(tolower(dish_df[dish_count,1]),myCorpus)
    total_dish_count = total_dish_count + phrase_count
    
    if (phrase_count > 0) {
      if (length(business_pos_list)==0) 
      { business_pos_list <- c(chinese_restaurant_neg_rev[i,]$business_id)
      } else {
        business_pos_list <- c(business_pos_list,chinese_restaurant_neg_rev[i,]$business_id)
      }      
    }
    
  }
  
  print(total_dish_count)
  print(length(unique(business_pos_list)))
  print(total_pos_business)
  final_dish_count <- (total_dish_count * length(unique(business_pos_list)))/total_res_business
  print(final_dish_count)
  dish_df[dish_count,3] <- final_dish_count
  
}
dish2_df <- dish_df[dish_df$neg_rev_count>2,]
colnames(dish2_df) <- c('Dish_Name','Positive Review','Negative Review')
dfm <- melt(dish2_df[,c('Dish_Name','Positive Review','Negative Review')],id.vars = 1)
ggplot(dfm,aes(x = reorder(Dish_Name,value),y = value)) + 
  geom_bar(aes(fill = variable),stat = "identity",position = "dodge") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_y_log10() 
