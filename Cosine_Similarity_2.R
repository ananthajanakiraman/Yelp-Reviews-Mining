temp = list.files(pattern="*.txt")
doc_df <- data.frame()
for (i in 1:length(temp)) {
  print(i)
  mystring <- read_file(temp[i])
  #document_df[i,1] <- stemDocument(removeWords(tolower(mystring),stopwords(kind="en")),language="english")
  doc_df[i,1] <- mystring
}
for(i in 1:length(temp)) {
  doc_df[i,1] <- removePunctuation(doc_df[i,1])
}
rownames(doc_df) <- c(gsub(".txt","",unlist(temp)))


  myCorpus <- Corpus(VectorSource(doc_df$V1))
  myCorpus <- tm_map(myCorpus, PlainTextDocument)
  myCorpus <- tm_map(myCorpus, removePunctuation)
  #myCorpus <- tm_map(myCorpus, removeWords, stopwords("english"))
  myCorpus <- tm_map(myCorpus, tolower)                          
  corpus_tdm <- TermDocumentMatrix(myCorpus,control = list(stopwords = FALSE,stemming=FALSE))
  #lda_model_doc <- LDA(corpus_tdm,10)
  cosine_dist_mat <- crossprod_simple_triplet_matrix(corpus_tdm)/(sqrt(col_sums(corpus_tdm^2) %*% t(col_sums(corpus_tdm^2))))
  