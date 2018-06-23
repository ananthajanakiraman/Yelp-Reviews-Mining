temp = list.files(pattern="*.txt")
doc_df1 <- data.frame()
doc_df2 <- data.frame()
doc_df_final <- data.frame()
rowname1 <- vector()
rowname2 <- vector()
cross_relation_matrix <- matrix(data=NA,nrow = length(temp),ncol = length(temp),dimnames = list(c(gsub(".txt","",unlist(temp))),c(gsub(".txt","",unlist(temp)))))

for(i in 1:length(temp)) {
  cat(" Processing...", temp[i],"...",i,"\n")
  for(j in 1:length(temp)) {
  
    doc_df_final <- read.csv(temp[i],sep="\n",quote="",header = FALSE,stringsAsFactors = FALSE)
    length1 <- nrow(doc_df_final)
    doc_df1 <- read.csv(temp[j],sep="\n",quote="",header = FALSE,stringsAsFactors = FALSE)
    length2 <- nrow(doc_df1)
    doc_df_final <- rbind.data.frame(doc_df_final,doc_df1)
    
    for (k in 1:length1) {
      rowname1 <- c(rowname1,gsub(".txt","",unlist(temp[i])))
    }
    
    for (l in 1:length2) {
      rowname2 <- c(rowname2,gsub(".txt","",unlist(temp[j])))
    }
    
    tokens_doc = word_tokenizer(tolower(doc_df_final$V1))
    it_doc = itoken(tokens_doc, ids = rownames(doc_df_final))
    v_doc = create_vocabulary(it_doc)
    v_doc = prune_vocabulary(v_doc, term_count_min = 1, doc_proportion_max = 1)
    dtm_doc = create_dtm(it_doc, vocab_vectorizer(v_doc))
    matrix1 <- sim2(dtm_doc,method="cosine")
    matrix2 <- as.vector(matrix1)
    #matrix2 <- matrix2[matrix2 > 0]
    cross_relation_matrix[c(gsub(".txt","",unlist(temp[i]))),c(gsub(".txt","",unlist(temp[j])))] <- as.numeric(mean(matrix2))
    print(as.numeric(mean(matrix2)))
  }
  
}

for(i in 1:length(temp)) {
  cross_relation_matrix[c(gsub(".txt","",unlist(temp[i]))),c(gsub(".txt","",unlist(temp[i])))] <- 1.000
}
