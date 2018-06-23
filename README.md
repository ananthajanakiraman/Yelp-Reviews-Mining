**1. Introduction**

Today, customer reviews in social media contribute significantly to the economic success of any kind of business. In this project, we examine restaurant reviews posted by customers in a well-known crowd-sourced business ratings and reviews website – &quot;yelp.com&quot;. Customers when choosing a restaurant look for a complete and satisfactory experience regarding food quality, service, and ambience and they often seek the opinion of patrons when they are choosing a place for their next meal. Yelp provides a wealth information to such customers. Users can look for a list of restaurant under a specific cuisine category and can also get the overall rating for those restaurants. They can also read the reviews that other customers wrote for those restaurants.

Reviews content is diverse and can talk about the food, the service, the ambience; they can reflect a positive experience or be a complain about some specific aspect of their experience. Therefore, reviews are a wealth of information and usually are more informative than a numeric rating. On the other hand, a service like Yelp receives thousands of reviews each day from every corner of the world and summarizing or extracting specific pieces of information from a massive corpus is a challenging task.

Data mining and more concretely text mining techniques allow us to explore a massive corpus like the one of Yelp reviews. We can obtain new insights about the text content that may be helpful for customers, restaurant owners, government or even for Yelp.

In this project, we mine a corpus of Yelp restaurant reviews to explore the next questions: What topics are frequently treated in the reviews? How are different cuisines related? Can we recommend dishes for a particular cuisine and which restaurant is best to try them? Can we predict whether a restaurant will pass its hygiene inspection?

**2. Data**

The data used in this project is part of the  [Yelp Dataset Challenge](http://www.yelp.com/dataset_challenge). The dataset consists of a set of JSON files that include business information, reviews, tips (shorter reviews), user information and check-ins. The JSON objects contain various restaurant/cuisine information including name, location, opening hours, category, average star rating, the number of reviews about the business and a series of attributes like noise level or reservations policy. The review objects in particular contain star rating, the review text, the review date, and the number of votes that the review has received. In this project, we have focused on these two types of objects.

The reviews dataset is a 1 GB dataset and has slightly over a million reviews for different businesses. A large sampling of this dataset about 103977 reviews/documents of size approximately 92 MB was utilized for various tasks. This included reviews of about 50 to 100 different cuisines of size ranging between 1MB to 20 MB. The business, tips and user&#39;s datasets were used to extract or filter reviews for different criteria. The sampling was completely random and we did not employ any filtering criteria during the sampling process.

**2.1 Language model**

Many of the techniques applied in the various tasks in this project required the use of a document-term or a term-document matrix as input. To obtain such matrix we have processed each of the reviews to build a bag of words language model. To create this model, we preprocessed each document in the corpus as follows:

- Remove non-writable characters.
- Lower case.
- Remove punctuation
- Remove numbers
- Stemming
- Stop words removal.

After that, each text was tokenized into unigrams, and the unigram frequencies were counted and stored into a document-term matrix of counts. There were total of 122587 unique terms in the vocabulary and contributes to more than 80% of total words in the entire corpus.

**3. Summary of Tasks**

**3.1 Task 1. What are the major topics in the reviews?**

The questions that come to our mind about the reviews are: Are they different in the positive and negative reviews? Are they different for different cuisines? What does the distribution of the number of reviews over other variables (e.g., cuisine, location) look like? What does the distribution of ratings look like?

Learning which topics are the most frequent among customer reviews and how they associate to a positive or negative rating can help business improve their offer and have a better chance of succeeding. Therefore, our first task was to explore which topics are frequent in the reviews.

**Topic Model**

To discover latent themes in our corpus, we run LDA (Latent Dirichlet Allocation) algorithm using Document Term Matrix (DTM) with number of topics (K) as the input. A document-term matrix or term-document matrix is a mathematical matrix that describes the frequency of terms that occur in a collection of documents. In a document-term matrix, rows correspond to documents in the collection and columns correspond to terms.

**Sparsity Examination**

The sparsity for the document term matrix was 100% but we inspected the matrix for rows/documents with total row sum = 0 and eliminated them from the matrix because they did not contribute to the model. In other words, only those indices with non-zero sum were retained in the document term matrix that will be used by the LDA algorithm and others were eliminated.

**How many topics?**

We used log-likelihood method to determine the value of K (number of topics) that should be input to the algorithm. The model values were generated by invoking the LDA algorithm for a range of K values and using the model values a plot as seen in Figure 1 was generated – log-likelihood values vs number of topics that visually provided an approximate number for the optimal number of topics.

**Figure 1. Log Likelihood plot for number of topics selection.**

**Results**

After applying LDA to a sample of the reviews and choosing an appropriate input for the number of topics (K=5 &amp; K=10), we obtained the following visualizations using a popular visualization package in R. Figure 2 shows a 5-topic model with the top 5 words identified in each topic, the topics are well defined in each of the 5 topics and colors signify different topics. Figure 3 is similar to Figure 2 and identifies 10 different topics with the top 5 words listed under each topic.

**Figure 2. LDA Topic Visualization with topic parameter, K=5**

**Figure 3. LDA Topic Visualization with topic parameter, K=10**

We created another sample set from the original yelp review dataset that contains almost 6000000 reviews (550 MB in size) and filtered reviews for one specific business that resulted in a dataset of 3695 reviews. The reviews were separated as positive (&gt;3 stars) and negative reviews (&lt;3 stars). We did not include reviews with three stars because that rating is neither positive nor negative. Then as detailed previously, a log likelihood plot – Figure 4 and 5 were generated on the positive and negative review data to determine the optimal number of topics. The topic model visualizations were generated as shown in Figure 6 and 7 for positive and negative reviews. The green color signifies positive reviews and the red color signifies negative reviews. We chose the optimal topic parameter to be 24 but it could anything in the range of 20 and 30.

**Figure 4. Log Likelihood for positive reviews dataset**

**Figure 5. Log Likelihood for negative reviews dataset**

**Figure 6. Topic Model visualization for negative reviews**

**Figure 7. Topic Model visualization for positive reviews**

**3.2 Task 2. How are different cuisines related?**

This task covered an interesting and important question of how the different cuisines are related? The restaurants listed in the Yelp dataset, are often labeled according to the kind of cuisine that they serve. How those categories are related is an interesting question that allows to draw a similarity map of cuisines.

To investigate this question, we used a large sampling of this dataset – reviews for 50 different cuisines of size approximately 20 MB. The sampling was completely random and did not employ any filtering criteria during the sampling process.

Businesses are classified according to their categories field. Each business can have multiple labels and, in addition to the restaurant label, restaurants receive other tags to specify the type of restaurant. Some of those labels correspond to easily recognizable types of cuisines such as American, Italian and Chinese. Other tags refer to businesses that may or may not serve food (Karaoke or Swimming Pools for example) but that do not have a particular type of cuisine associated. A third kind of label, like Taxi or Automotive, lack a definite relationship with food. For this task, we have used only the reviews related to business that has one of the labels that clearly points to a type of cuisine and also a sample set of review files for different cuisines were provided in the task overview section.

To discover the relations among the cuisines, we have used a document-term matrix to compute the similarities among the reviews of each cuisine type pair. Then we have used the similarities to create a similarity matrix representation and also different clustering representations.

We attempted different combinations of transformations of a document-term matrix and similarity functions:

- Similarity Matrix with data used as it is without any transformation
- Similarity Matrix with TF weighting only
- Similarity Matrix with TF-IDF weighting
- Similarity Matrix with LDA and different document proportions
- Similarity Matrix based on aggregated reviews

We used cosine similarity as measure of similarity between different cuisines. The fourth approach gave the best results with a higher document proportion and minimum term frequency count between 3 and 5. In this approach, we applied a topic model (LDA for this visualization) and obtained a document topic distribution vector. We used this topic distribution vector to compute similarity using a similarity function &amp; produced a similarity matrix. The result is a 50x50 matrix.

The term frequency weight and term frequency &amp; inverse document frequency weighting were performed using document term matrix. The TF weighting approach identified lot of high opacity cells indicating high similarity (Figure 9) between cuisines while the TF-IDF weighting approach sparsely identified high opacity cells indicating low similarity between cuisines (Figure 10). The outcome of using the data as it is without any transformation performed poorer than TF weighting approach as it identified too many high opacity cells (Figure 8).

Figure 11 shows the similarity matrix computed using a topic model and cosine similarity. Darker cells indicate a stronger similarity between two given cuisines. The cuisines were ordered alphabetically in the visualization. We attempted document proportions of 0.1 and 0.2, the document proportion of 0.2 seemed to yield a better result.

We generated a similarity matrix based on aggregated similarity of individual reviews between cuisines. After data preprocessing, a similarity matrix was generated using a similarity function across all reviews between cuisines. We aggregated the similarities of individual reviews between cuisines and produced a final aggregated similarity matrix that was plotted in the below visualization – Figure 12. The visualization shows predominantly low opacity cells indicating low similarity across cuisines but could be improved significantly by adjusting the weighting &amp; applying other pruning techniques.

**Figure 8. Similarity with no transformation                         Figure 9. Similarity with TF weighting**

**Figure 10. Similarity with TF-IDF weighting                         Figure 11. Similarity using Topic Model**

**Figure 12. Similarity using aggregated reviews**

Although this representation clearly shows some groups, it makes hard to infer the relationships between groups. Each cell in the cuisine similarity matrix represents the strength of the relationship between two cuisines. We can also represent the similarity matrix as clusters in which each cluster contains cuisines with high similarity. We performed the followed clustering methods and out of these the K-Medoids clustering method using representative objects performed better for the chosen sample set. Figures 13, 14 and 15 are sample visualizations of outcome from these clustering methods.

- K-Means (3 and 5 clusters)
- Hierarchical
- K-Medoids (3 and 5 clusters)

For K-Means, we did Principal Component Analysis (PCA) on the similarity matrix to determine proportion of variance across components/features that describe the data and then used components that cumulatively contribute to at least 70% proportion of variance for plotting clustering results. And for K-Medoids, the first two principal components that explain more than 75%-point variability were used in the visualizations.

**Figure 13. K-Means Clustering**

**Figure 14. Hierarchical Clustering**

**Figure 15. K-Medoids Clustering**

**3.3 Tasks 3, 4 and 5. What are the best dish recommendations for a particular cuisine and what is the best restaurant serving that dish?**

In tasks 3,4 and 5 we focused on extracting new, specific knowledge from the reviews and creating a product that could be useful to the users, the restaurant owners or even Yelp. In particular, we extracted dish names from the reviews and created a ranking of popular dishes for a given cuisine that we could offer to a user as a guide to discovering new dishes. Also, we attempted to recommend restaurants that are good at a particular dish.

**3.3.1 Dish Extraction**

In this step, our objective was to extract dish names from a corpus of Yelp reviews. In particular, we tried to compile a list of dishes for Chinese cuisines. For that, we have applied two different algorithms for phrase extraction: SegPhrase and TopMine.

**Top Mine**

Top Mine first segments each review into single and multi-word phrases and then applies an LDA topic model on the partitioned document. The algorithm estimates the topic model hyper parameters using Gibbs sampling. The output of the algorithm includes the distribution by topic of single and multi-word phrases.

We run the algorithm using the following configuration.

- minimum phrase frequency: 5
- maximum size of phrase (number of words): 5
- number of topics: 10
- Gibbs sampling iterations: 1000
- significance threshold for merging unigrams into phrases: 5
- burnin before hyper parameter optimization: 100
- alpha hyper parameter: 2
- ptimize hyper parameters every n iterations: 50

After running the algorithm, we inspected the resulting topics, and we selected those topics that clearly related to dishes and food. Of all the terms chosen for Chinese cuisine, we only kept those with a frequency above a threshold determined by the quality of the items above and below the threshold.

**Segphrase**

This algorithm extracts popular phrases by first segmenting the corpus and selecting those phrases above some minimum threshold support and then rectifying the phrase counts according to phrase quality criteria. The algorithm allows as input a set of labeled good and bad quality phrases that allows to rectify the counts to extract phrases closely related to the positively labeled samples. Here we used a list of items obtained using a feature of SegPhrase that allows get a list of phrases auto-labeled. We reviewed manually the auto generated list to remove false positives and negatives and also by comparing the SegPhrase output with wiki.auto.label file through a process and including the missing phrases that are related to dish names. We attempted to expand the dish names using TopMine as described above and merged the outputs from SegPhrase and TopMine.

We cloned the Segphrase from Github repository and applied the tool using default parameters except for:

- support threshold: 5.
- max iterations: 5
- discard ratio: 0.05
- enabled use of unigrams.
- enabled use of word networks.

After that, we filtered the phrases listed in the file salient.csv to keep only those phrases with a rectified count above 0.85.

**Results**

All the methods applied retrieved valid dish names and, although the highest scored results were dishes, the quality of the results deteriorated rapidly. Therefore, to keep only good quality results, we inspected the output and fixed the thresholds described above. We discarded all items with score below the corresponding threshold.

Proceeding this way, we got one list of items for each algorithm and Chinese cuisine. TopMine seemed to return a better list compared to SegPhrase. Below is a word cloud – Figure 16 generated from TopMine results using the configuration above and this is just a sample.

**Figure 16. Word Cloud from Top Mine results**

However, even after keeping only the top scoring items for each algorithm we found items not related to food, related to food but that were not dishes and dishes from other cuisines. We compared the popular dish names to popular Chinese dish names using the Chinese dish list extracted from various sources including Wikipedia and eliminated non-dish names.

We have used the resulting lists of dishes in the next two steps.

**3.3.2 Dish Ranking**

A dish ranking is a useful tool for those who want to explore a cuisine because it tells them which dishes are the most popular and, therefore, the most representative. To create a dish ranking, we need some measure or score to compare the dishes according to their popularity. Once we have such score, we simply list the dishes in decreasing order of the score, and we present to the user the top-N dishes.

We mine the dataset for a particular cuisine, to discover common/popular dishes of a particular cuisine and also recommend restaurants for a popular dish. For this task, we mined popular dishes and restaurants for Chinese Cuisine.

**Review Stars**

There were total of 38775 reviews that were extracted from the reviews json file out of which 30061 reviews have greater than or equal to 3 stars and 8714 reviews have less than 3 stars. All reviews associated with Chinese restaurants were identified and extracted and classified as positive or negative reviews based on the number of stars. When the number of stars for a particular review was less than 3 then it was considered a negative review otherwise as positive.

**Document Frequency**

For each common dish name extracted from previous task, the frequency of occurrence was determined in the positive and negative review partitions. To calculate the frequency of dish occurrence in a document corpus, a phrase count function from a popular package was used. I then filtered out dishes with weighted review count less than 2 because they either do not appear often or appear in a very few restaurants.

**Weighted Review count**

We multiplied the frequency of dish occurrence by the count of unique number of restaurants in each partition (positive and negative) containing the dish name and normalized over the total number of businesses in the Chinese cuisine category. This is the weighted review count. We created the below visualization – Figure 17 of weighted review count plotted on log scale against popular Chinese dish names using a visualization package.

The y axis was adjusted to log scale because for some of the dishes the weighted review count was significantly higher than the others making the visualization slightly unreadable.

**Results**

From the analysis and visualizations, we were able to identify, extract and reasonably conclude top three popular Chinese dishes based on the reviews extracted from yelp academic datasets. They were, 1. Fried Rice 2. Orange Chicken and 3. Dim Sum and these results seemed reasonable and matched expectation based on some manual examination that we performed on the reviews dataset at a very high level.

The dishes that have high positive reviews also seem to have reasonably high negative reviews but in case of some dishes although they do not fall under high weighted review count, they seem to have very low negative reviews compared to number of positive reviews. Overall, the weighted frequency based approach to determine popular dish and recommend restaurant seemed to work fine but there are definitely other methods like sentiment based mining and modeling methods that could be employed to improve the accuracy of the recommendation.

**Figure 17. Popular dishes from Chinese cuisine reviews**

**3.3.3 Restaurant recommendation**

To recommend a restaurant for a given dish, we need a score that tells us how good each restaurant is cooking that dish.

From the previous task, we used one of the top three dishes (top three weighted review counts) which in this case is &quot;orange chicken&quot; and recommend top three restaurants based on their overall review score.

For each positive and negative reviews for restaurants, we determine the frequency of occurrence for the popular dish - &quot;orange chicken&quot;. We ignore multiple occurrences of popular dish within the same review and increment the frequency only by 1 if the popular dish was mentioned in the review. We then calculate the weighted review score by multiplying the frequency and count of unique users in each partition (positive and negative).

To calculate the frequency of dish occurrence in a document corpus, a phrase count function from a popular package was used. We also filtered out restaurants with weighted review score less than 2 because those restaurant businesses had insufficient reviews for the popular dish and cannot be used for the restaurant recommendation task. We ended up with 304 restaurants for recommendation and used them in the visualization.

For readability, only the first 75 restaurants have been shown in the visualization - Figure 18.

**Results**

From the analysis and visualizations, we were able to identify, extract and reasonably conclude top three popular Chinese restaurants serving &quot;orange chicken&quot; based on the reviews extracted from yelp academic datasets. They were, 1. Tott&#39;s Asian Dinner 2. China Chilli and 3. Asian Café Express. Similar to dish recommendation,

the restaurants that have high positive reviews also seem to have reasonably high negative reviews but in case of some restaurants although they do not fall under high weighted review score, they seem to have very low negative reviews compared to number of positive reviews. Overall, the weighted frequency based approach to determine recommend restaurant seemed to work fine.

**Figure 18. Popular restaurants serving &quot;orange chicken&quot;**

**3.4 Task 6. Restaurant Hygiene Prediction**

**3.4.1 Data**

The data that we used in this task is slightly different. It is a corpus of 13,299 documents in which each document is the result of concatenating all the Yelp reviews of a restaurant. In addition to the reviews, we have the following additional data for each restaurant:

- Cuisines offered.
- ZIP code.
- number of reviews.
- average rating in a 0 to 5 scale (5 being the best).

For 7000 restaurants, we have a label indicating whether the restaurant has passed the latest public health inspection test (0) or not (1). We do not have a label for the remaining 6299 (the evaluation set). Our objective is to use the 7000 labeled records as the training set to train a classifier that predicts the label of the remaining 6299 to predict whether they would pass the hygiene inspection or not. The performance of our classifier will be measured using the F1 measure.

One important feature of this dataset is that the training set has a balanced distribution of 0/1 labels, but the evaluation is unbalanced.

**3.4.2 Classifier training**

**Data Pre-Processing**

We preprocessed the reviews as follows:

- Lower case.
- Remove punctuation
- Remove numbers
- Stemming
- Stop words removal.

After that, each text was tokenized into unigrams, and the unigram frequencies were counted and stored into an inverted index and forward index with a vocabulary of 13299 terms. To preprocess the text data and compute the inverted and forward index we updated the configuration file in Metapy appropriately.

**Additional features**

Together with the reviews, other features were provided: average rating, the number of reviews, cuisine categories and ZIP code. We used average cuisine type, zip code, rating and number of reviews as regular numeric features.

**Training Algorithms**

This task is a supervised machine learning classification task. We have selected three algorithms to train our models: naïve bayes, binary classifiers (one-vs-one and one-vs-all), winnow classifiers. We hold 20% of the training cases to evaluate the performance of our approaches (test set), and we used the remaining 80% to train our classifiers. To train a classifier with any of the algorithms mentioned above, we used 5-fold cross-validation using the training set for model parameter selection. Once we selected the model parameters, we trained our final model over the complete training set.

We invoked different classifiers available in Metapy with appropriate configuration file settings. We have held out a 20% of the training data as a test set in which we can perform our evaluation of the algorithm performance. We have assessed the performance by computing the F1 measure for the prediction on the test set.

**Results**

We tabled our results from different classifier and configuration settings as seen in Figure 19. The best accuracy (F1 score) was achieved with Naïve Bayes classifier with Unigram tokenization, a default-unigram-chain filter and few additional features included. The accuracy achieved with this classifier was 0.9384.

Predicting whether a set of restaurants will pass the public health inspection tests given the corresponding Yelp text reviews along with some additional information such as the locations and cuisines offered in these restaurants using data mining techniques represents a wide range of important applications of data mining. The comparison of results against various classifiers was extremely important and helps understand what classifier with appropriate setting is best suited for this task.

**Figure 19. Classifier results comparison table**

**4. Usefulness of the results**

**4.1 Topic models**

Topics frequently treated in Yelp reviews reflect what people care when they go to a restaurant. This information is important for restaurant owners because it helps them to focus their efforts to improve their business in the aspects of their customers experience that matter. In particular, the topics in the model obtained from negative reviews point to what a restaurant owner and staff should avoid at all costs.

**4.2 Cuisine map**

There are many cuisines, and customers often only know a few of them and usually do not try new cuisines because they do not know what to expect and some hesitation to move outside the comfort zone. Our map of cuisines can help users to explore new cuisines by starting at their favorite cuisines and then try other cuisines that could discover new culinary experiences that are familiar enough to keep them in their comfort zone. On the other hand, people who seek different experience can move to different cluster based on our cuisine similarity map.

**4.3 Dish ranking and restaurant recommendation for a dish**

We rank dishes within a cuisine by popularity and provide a recommendation about where to try those dishes. These products are useful for users who are looking for new cuisine experience and for restaurant owners who want to modify their menu offer. However, these products could be useful also for Yelp. Restaurants often list their menus in Yelp. We can use the dishes listed in the menus to go beyond the explicit information provided in the reviews and recommend restaurants for a dish, even if the dish was never mentioned in the restaurant comments.

**4.4 Hygiene prediction**

The capacity of predicting whether a restaurant will pass a hygiene inspection from the contents of user reviews is a valuable tool for governments. By monitoring the opinions of customers, a flag can be raised when the content of the reviews indicates that the restaurant may be deviating from public health regulations. This in turn helps to focus public resources and makes public inspections more efficient.

**5. Novelty of Exploration**

We have applied a set of tools for text mining along this project. In all the cases, we have tested different sets of parameters and data-algorithm combinations to seek for optimal results. Also, during the development of this project some standard tools have been provided. For the most of this project, we have not used the tools provided but looked for equivalent solutions in the R environment except for Task 6 where we used Metapy.

In Task 2, we created sparse matrix after employing pruning techniques like applying minimum term count across reviews and maximum document proportion for terms. We attempted different combinations of minimum term counts and document proportions and a right combination of these two special pruning parameters helped obtain a better representation of the similarity matrix and a balanced opacity in the cuisine similarity map.

Also in Task2, we attempted to aggregate similarities between individual reviews across cuisines and populated a final aggregate similarity matrix consolidating the similarities between individual reviews across cuisines. We were able to arrive at a strong conclusion that the similarity representation could be improved drastically by adjusting the weighting and performing additional pruning. This technique although may have resulted in predominantly low opacity similarity matrix for cuisines it helped identify customer similarity which is another important data mining application and very useful for restaurant owners.

We made an interesting discovery in Task 2 on clustering similarities using K-Medoids. The clustering method using representative objects proved to be effective compared to other clustering techniques. This method identified strong clusters with extremely low overlap and the first two principal components explained more than 75%-point variability. This was our highly recommended approach to cluster and visualize similarities between cuisines.

In Task3, we attempted different phrasal segmentation and word association methods to identify and rank dishes from the review corpus. We were able to compare and analyze different techniques and used special packages in R (like textreg) to count phrases quickly. We tried different procedures to extract dish phrases and in each of the procedures we were able to uniquely identify dish names. In the course of exploration, we observed that minimum support threshold and discard ratio were very important knobs to retain dish names and discard phrases that are not related to dish names. These two parameter settings helped us refine and produce a cleaner list of phrases that was used in Task 4 and 5 for cuisine and restaurant recommendation.

In the hygiene prediction task, we tried different classifiers at least one in each of multiclass, binary and linear classifiers. We were able to systematically isolate features that did not contribute to model accuracy or less significant and identify specific features that improved the accuracy significantly. We were surprised with the notion that stemming did not contribute significantly to model accuracy improvement in Task 6 and on the contrary, unigram tokenization proved to be more effective compared to bigrams, trigrams etc. We were able to identify specific tokenization, analyzer and filter combinations that improved accuracy for classification tasks similar to Task 6.

**6. Contribution of New Knowledge**

Based on the optimized results observed in similarity representation tasks, it is important to consider pruning techniques that are best suited for a task. Choosing right pruning techniques to filter features has a significant correlation to increased accuracy in representation of relationships. The document term matrix and term document matrix sparsity needs to be at an optimal dimension not just from the term and term frequency count perspective but also from an overall performance standpoint. The document proportion parameter setting for example turned out to be an important knob for filtering features more so than TF and TF-IDF weighting in the task of identifying relationships. The general assumption that a sparser feature matrix would help identify stronger relationships may not hold true in all cases and all kinds of mining tasks.

It is also our useful finding and knowledge discovered in the due course of performing hygiene prediction task that although the classification task is binary and the obvious choice of classifier would be binary classifier, it would be worth exploring a multiclass classifier with appropriate filter settings and tokenizers particularly while exploring a dataset with highly sparse features.

It is also advisable to employ appropriate feature selection methodology and filter out features that may not help in improving accuracy (in the case of a prediction problem) rather lower the accuracy. These features could be selected based on mutual information like what we attempted in the hygiene prediction task. We were able to reasonably conclude that the number of reviews and review stars have higher correlation and improve the accuracy of prediction but including a feature like zip code may have a negative impact to accuracy due to a weaker correlation.

Key customers that have high connections in their networks, are usually doing much more reviews than the general mass, and according to the network theory, they are more influential. Studying their topics reveals a brand-new scope of focuses compared with the mass, which can be supplied to restaurant owners to improve their services, so as to attract these people.

Results from the explorations in the final report demonstrate that key customers can be extracted by their significance in network, and their review values. Also, topic mining upon these samples reveals that they do focus on things other than dishes. Such information is useful to the restaurant owners if they want to attract such key customers.

**7. References**

1. [Anderson and J. Magruder. &quot;Learning from the Crowd.&quot; The Economic Journal. 5 October,2011.](http://are.berkeley.edu/~mlanderson/pdf/Anderson%20and%20Magruder.pdf)
2. [Blei DM, Ng AY, Jordan MI (2003b). &quot;Latent Dirichlet Allocation.&quot; Journal of Machine Learning Research, 3, 993–1022.](http://robotics.stanford.edu/~ang/papers/jair03-lda.pdf)
3. [Griffiths TL, Steyvers M (2004). &quot;Finding Scientific Topics.&quot; Proceedings of the National Academy of Sciences of the United States of America, 101, 5228–5235.](http://dx.doi.org/10.1073/pnas.0307752101)
4. [Phan XH, Nguyen LM, Horiguchi S (2008). &quot;Learning to Classify Short and Sparse Text &amp; Web with Hidden Topics from Large-Scale Data Collections.&quot; In Proceedings of the 17th International World Wide Web Conference (WWW 2008), pp. 91–100. Beijing, China.](http://dx.doi.org/10.1145/1367497.1367510)
5. [Blei DM, Lafferty JD (2007). &quot;A Correlated Topic Model of Science.&quot; The Annals of Applied Statistics, 1(1), 17–35.](http://dx.doi.org/10.1214/07-AOAS114)
6. [Lv, Y., Zhai, C., 2011. Lower-bounding term frequency normalization, in:. Presented at the Proceedings of the 20th ACM international conference on Information and knowledge management, ACM, pp. 7–16.](http://dx.doi.org/10.1145/2063576.2063584)
7. https://rstudio-pubs-static.s3.amazonaws.com/117506\_ea365271268f4615b07332b169424183.html
8. [textreg: n-Gram Text Regression, aka Concise Comparative Summarization](https://cran.r-project.org/web/packages/textreg/index.html)
9. [Ingo Feinerer, Kurt Hornik, and David Meyer (2008). Text Mining Infrastructure in R. Journal of Statistical Software 25(5): 1-54](https://cran.r-project.org/web/packages/textreg/index.html)
10. [Kurt Hornik, Christian Buchta, Achim Zeileis (2009) Open-Source Machine Learning: R Meets Weka. Computational Statistics, 24(2), 225-232. ](http://dx.doi.org/10.1007/s00180-008-0119-7) [doi:10.1007/s00180-008-0119-7](doi:10.1007/s00180-008-0119-7)
11. [Hornik, K., Grün, B., 2011. topicmodels: An R package for fitting topic models. Journal of Statistical Software 40, 1–30.](http://dx.doi.org/10.18637/jss.v040.i13)
