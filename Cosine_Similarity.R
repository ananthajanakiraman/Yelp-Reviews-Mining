temp = list.files(pattern="*.txt")
document_df <- data.frame()
for (i in 1:length(temp)) {
  print(i)
  mystring <- read_file(temp[i])
  #document_df[i,1] <- removeWords(tolower(mystring),stopwords(kind="en"))
  document_df[i,1] <- mystring
}
rownames(document_df) <- c(gsub(".txt","",unlist(temp)))
myCorpus <- Corpus(VectorSource(document_df$V1))
myCorpus <- tm_map(myCorpus, PlainTextDocument)
myCorpus <- tm_map(myCorpus, removePunctuation)
corpus_tdm1 <- DocumentTermMatrix(myCorpus,control = list(stopwords = TRUE,stemming=TRUE))
#myCorpus <- tm_map(myCorpus, removeWords, stopwords("english"))
myCorpus <- tm_map(myCorpus, tolower)                          

#cosine_dist_mat <- crossprod_simple_triplet_matrix(corpus_tdm)/(sqrt(col_sums(corpus_tdm^2) %*% t(col_sums(corpus_tdm^2))))
#clusplot(pam(cross_relation_matrix,3),3,labels=2, lines=0,main='2D representation of the Cluster solution')
corpus_tdm2 <- TermDocumentMatrix(myCorpus,control = list(stopwords = TRUE,stemming=TRUE))
cosine_dist_mat1 <- crossprod_simple_triplet_matrix(corpus_tdm2)/(sqrt(col_sums(corpus_tdm2^2) %*% t(col_sums(corpus_tdm2^2))))
