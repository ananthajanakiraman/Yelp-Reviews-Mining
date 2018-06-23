json_df	<- fromJSON("yelp_academic_dataset_business.json")
restaurant_subset <- json_df[grep("Chinese",json_df$categories),]
chinese_subset <- cbind.data.frame(restaurant_subset$business_id,restaurant_subset$name,stringsAsFactors = FALSE)
colnames(chinese_subset) <- c("business_id","name")

json_df1 <- fromJSON("yelp_academic_dataset_review.json")
chinese_sub <- chinese_subset[,1]
temp_df1 <- json_df1[json_df1$business_id %in% chinese_sub,]
chinese_restaurant_reviews <- temp_df1[,c(2,3,4,6,8)]

#dish_df <- read.csv("dishes1.txt",header = FALSE,col.names = c("dish_name"),stringsAsFactors = FALSE)
dish_df <- cbind.data.frame(chinese_subset,pos_rev_count=0,neg_rev_count=0)
chinese_restaurant_pos_rev <- chinese_restaurant_reviews[chinese_restaurant_reviews$stars>=3,]
chinese_restaurant_neg_rev <- chinese_restaurant_reviews[chinese_restaurant_reviews$stars<3,]
total_pos_user <- length(unique(chinese_restaurant_pos_rev$user_id))
total_neg_user <- length(unique(chinese_restaurant_neg_rev$user_id))
total_res_user <- length(unique(chinese_restaurant_reviews$user_id))

#1. Loop through positive restaurant reviews and count the dishes
for(dish_count in 1:nrow(dish_df)) {
  
  user_pos_list <- list()
  total_dish_count <- 0
  
  cat("restaurant_count : ",dish_count,"\n")
  
  business_subset <- chinese_restaurant_pos_rev[grep(dish_df[dish_count,1],chinese_restaurant_pos_rev$business_id),] 
  
  for (i in 1:nrow(business_subset)) {
    
    myCorpus	<- Corpus(VectorSource(business_subset[i,]$text))
    myCorpus	<- tm_map(myCorpus,	PlainTextDocument)
    myCorpus	<- tm_map(myCorpus,	tolower)
    
    if (length(myCorpus) > 0) {
      phrase_count <- as.numeric(phrase.count(tolower("orange chicken"),myCorpus))  
    }
    
    if (phrase_count > 0) {
      total_dish_count = total_dish_count + 1
      if (length(user_pos_list)==0) 
      { user_pos_list <- c(business_subset[i,]$user_id)
      } else {
        user_pos_list <- c(user_pos_list,business_subset[i,]$user_id)
      }      
    }
    
  }
  
  final_dish_count <- (total_dish_count * length(unique(user_pos_list)))
  dish_df[dish_count,3] <- final_dish_count
  
}

#2. Loop through negative restaurant reviews and count the dishes
for(dish_count in 1:nrow(dish_df)) {
  
  user_neg_list <- list()
  total_dish_count <- 0
  
  cat("restaurant_count : ",dish_count,"\n")
  
  business_subset <- chinese_restaurant_neg_rev[grep(dish_df[dish_count,1],chinese_restaurant_neg_rev$business_id),] 
  
  for (i in 1:nrow(business_subset)) {
    
    myCorpus	<- Corpus(VectorSource(business_subset[i,]$text))
    myCorpus	<- tm_map(myCorpus,	PlainTextDocument)
    myCorpus	<- tm_map(myCorpus,	tolower)
    
    if (length(myCorpus) > 0) {
      phrase_count <- as.numeric(phrase.count(tolower("orange chicken"),myCorpus))  
    }
    
    if (phrase_count > 0) {
      total_dish_count = total_dish_count + 1
      if (length(user_neg_list)==0) 
      { user_neg_list <- c(business_subset[i,]$user_id)
      } else {
        user_neg_list <- c(user_neg_list,business_subset[i,]$user_id)
      }      
    }
    
  }
  
  final_dish_count <- (total_dish_count * length(unique(user_neg_list)))
  dish_df[dish_count,4] <- final_dish_count
  
}
dish3_df <- dish_df[(dish_df$pos_rev_count>1 | dish_df$neg_rev_count>1),]
dish3_df <- dish3_df[,c(2:4)]
colnames(dish3_df) <- c('Restaurant_Name','Positive Review','Negative Review')
dish_part1_df <- dish3_df[1:152,]
dish_part2_df <- dish3_df[153:304,]
dfm_part1 <- melt(dish_part1_df[,c('Restaurant_Name','Positive Review','Negative Review')],id.vars = 1)
dfm_part2 <- melt(dish_part2_df[,c('Restaurant_Name','Positive Review','Negative Review')],id.vars = 1)
ggplot(dfm_part1,aes(x = Restaurant_Name,y = value)) + 
  geom_bar(aes(fill = variable),stat = "identity",position = "dodge") +
  theme(axis.text.x=element_text(angle=90,hjust =1,size=7),legend.position = "top") + coord_trans(y = "sqrt")
ggplot(dfm_part2,aes(x = Restaurant_Name,y = value)) + 
  geom_bar(aes(fill = variable),stat = "identity",position = "dodge") +
  theme(axis.text.x=element_text(angle=90,hjust =1,size=7),legend.position = "top") + coord_trans(y = "sqrt")
  #scale_y_log10() 
  #theme(axis.text.x = element_text(angle = 45, hjust = 1,vjust=2)) +
  #theme(axis.text.x=element_text(angle=90,margin = margin(1, unit = "cm"),vjust =1)) +
  #scale_y_log10() 
