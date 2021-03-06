library(text2vec)
tokens = word_tokenizer(tolower(document_df$V1))
it = itoken(tokens, ids = rownames(document_df))
v = create_vocabulary(it)
v = prune_vocabulary(v, term_count_min = 5, doc_proportion_max = 0.2)
dtm1 = create_dtm(it, vocab_vectorizer(v))
lda_model = LDA$new(n_topics = 10)
doc_topic_distr1 = lda_model$fit_transform(dtm1, n_iter = 20)
#doc_topic_distr1 = lda_model$fit_transform(dtm_tfidf, n_iter = 5)


library(text2vec)
tokens_doc = word_tokenizer(tolower(doc_df_final$V1))
it_doc = itoken(tokens_doc, ids = rownames(doc_df_final))
v_doc = create_vocabulary(it_doc)
v_doc = prune_vocabulary(v_doc, term_count_min = 1)
dtm_doc = create_dtm(it_doc, vocab_vectorizer(v_doc))
model_tfidf = TfIdf$new(smooth_idf = TRUE,sublinear_tf = TRUE)
dtm_tfidf = model_tfidf$fit_transform(dtm_doc)
lda_model_doc = LDA$new(n_topics = 10)
#doc_topic_distr1 = lda_model$fit_transform(dtm1, n_iter = 20)
doc_topic_distr2 = lda_model_doc$fit_transform(corpus_tdm, n_iter = 20)
