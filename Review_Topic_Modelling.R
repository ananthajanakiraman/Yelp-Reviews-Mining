json_df <- fromJSON("ReviewSample.json")
myCorpus <- Corpus(VectorSource(json_df$text))
myCorpus <- tm_map(myCorpus, PlainTextDocument)
myCorpus <- tm_map(myCorpus, tolower)
myCorpus <- tm_map(myCorpus, removePunctuation)
myCorpus <-  tm_map(myCorpus, removeWords, stopwords("english"))

corpus_review_dtm <- DocumentTermMatrix(myCorpus)  

ui = unique(corpus_review_dtm$i)
corpus_review_dtm.new <- corpus_review_dtm[ui,]

best.model <- lapply(seq(2,25, by=1), function(k){LDA(corpus_review_dtm.new, k)})
best.model.logLik <- as.data.frame(as.matrix(lapply(best.model, logLik)))
best.model.logLik.df <- data.frame(topics=c(2:25), LL=as.numeric(as.matrix(best.model.logLik)))
ggplot(best.model.logLik.df, aes(x=topics, y=LL)) +
xlab("Number of topics") + ylab("Log likelihood of the model") +
geom_line() +
theme_bw()

review_lda_5 <- LDA(corpus_review_dtm.new,5)
review_lda_10 <- LDA(corpus_review_dtm.new,10)
review_topics <- tidy(review_lda_X,matrix="beta")
review_top_terms <- review_topics %>% group_by(topic) %>% top_n(5,beta) %>% ungroup() %>% arrange(topic,-beta)
review_top_terms %>% mutate(term = reorder(term, beta)) %>% ggplot(aes(term, beta, fill = factor(topic))) + geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") + coord_flip()

new_json_df <- fromJSON("review.json")  #review.json is the second sample dataset with 600000
# reviews
count(new_df,"business_id")
business <- new_df %>% count(business_id)
write.csv(business,"business.csv")  #wrote the business_id and count grouping to csv file

filter_df <- new_df[new_df$business_id=="4bEjOyTaDG24SY5TxsaUNQ",]
high_filter_df <- filter_df[filter_df$stars>4,] #nrow = 1552
low_filter_df <- filter_df[filter_df$stars<3,] #nrow = 687

high_myCorpus<-Corpus(VectorSource(high_filter_df$text))
high_myCorpus <- tm_map(high_myCorpus, PlainTextDocument)
high_myCorpus <- tm_map(high_myCorpus, tolower)
high_myCorpus <- tm_map(high_myCorpus, removePunctuation)
high_myCorpus = tm_map(high_myCorpus, removeWords, stopwords("english"))
high_corpus_review_dtm <- DocumentTermMatrix(high_myCorpus)

low_myCorpus<-Corpus(VectorSource(low_filter_df$text))
low_myCorpus <- tm_map(low_myCorpus, PlainTextDocument)
low_myCorpus <- tm_map(low_myCorpus, tolower)
low_myCorpus <- tm_map(low_myCorpus, removePunctuation)
low_myCorpus = tm_map(low_myCorpus, removeWords, stopwords("english"))
low_corpus_review_dtm <- DocumentTermMatrix(low_myCorpus)

best.model <- lapply(seq(2,30, by=1), function(k){ LDA(high_corpus_review_dtm, k)})
best.model.logLik <- as.data.frame(as.matrix(lapply(best.model, logLik)))
best.model.logLik.df <- data.frame(topics=c(2:30), LL=as.numeric(as.matrix(best.model.logLik)))
ggplot(best.model.logLik.df, aes(x=topics, y=LL)) +
  + xlab("Number of topics") + ylab("Log likelihood of the model") +
  + geom_line() +
  + theme_bw()

best.model <- lapply(seq(2,30, by=1), function(k){ LDA(low_corpus_review_dtm, k)})
best.model.logLik <- as.data.frame(as.matrix(lapply(best.model, logLik)))
best.model.logLik.df <- data.frame(topics=c(2:30), LL=as.numeric(as.matrix(best.model.logLik)))
ggplot(best.model.logLik.df, aes(x=topics, y=LL)) +
  + xlab("Number of topics") + ylab("Log likelihood of the model") +
  + geom_line() +
  + theme_bw()

high_review_lda <- LDA(high_corpus_review_dtm,24)
high_review_topics <- tidy(high_review_lda,matrix="beta")
review_top_terms <- high_review_topics %>% group_by(topic) %>% top_n(5,beta) %>% ungroup() %>% arrange(topic,-beta)
review_top_terms %>% mutate(term = reorder(term, beta)) %>% ggplot(aes(term, beta, fill = factor(topic))) + geom_col(show.legend = FALSE) +
  +     facet_wrap(~ topic, scales = "free") + coord_flip() + scale_fill_manual(values=c("red1","red2","red3","red4","red1","red2","red3","red4","red1","red2","red3","red4","red1","red2","red3","red4","red1","red2","red3","red4","red1","red2","red3","red4"))

low_review_lda <- LDA(low_corpus_review_dtm,24)
low_review_topics <- tidy(low_review_lda,matrix="beta")
review_top_terms <- low_review_topics %>% group_by(topic) %>% top_n(5,beta) %>% ungroup() %>% arrange(topic,-beta)
review_top_terms %>% mutate(term = reorder(term, beta)) %>% ggplot(aes(term, beta, fill = factor(topic))) + geom_col(show.legend = FALSE) +
  +     facet_wrap(~ topic, scales = "free") + coord_flip() + scale_fill_manual(values=c("springgreen1","springgreen2","springgreen3","springgreen4","springgreen1","springgreen2","springgreen3","springgreen4","springgreen1","springgreen2","springgreen3","springgreen4","springgreen1","springgreen2","springgreen3","springgreen4","springgreen1","springgreen2","springgreen3","springgreen4","springgreen1","springgreen2","springgreen3","springgreen4"))
