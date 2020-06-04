## Prepare Data
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import os
import re
import nltk
from nltk.stem import WordNetLemmatizer 
from nltk.tokenize import sent_tokenize, word_tokenize
from textblob import TextBlob

def normalize_document(doc):   # doc is one Review text
    '''
       Input: list of text (Reviewbox provided text)
       Output: Cleaned text
        
       sample: 
           texts=df['text'].apply(str)
           normalize_corpus=np.vectorize(normalize_document)
           texts_clean= normalize_corpus(texts)
       
    ''' 

    # Lemmatizer, tokenizer, stop_words
    lemmatizer = WordNetLemmatizer() 
    stop_words = nltk.corpus.stopwords.words('english')

    # lower case and remove special characters\whitespaces
    doc = re.sub(r'[^a-zA-Z\s]', '', doc, re.I|re.A)
    doc = doc.lower()
    doc = doc.strip()

    # tokenize & lemmatize document
    tokens = [lemmatizer.lemmatize(word,pos="v") for word in word_tokenize(doc)]
    filtered_tokens = [token for token in tokens if token not in stop_words]

    # re-create document from filtered tokens
    doc = ' '.join(filtered_tokens)
    return doc

def get_polarity (content):
    # Simplist sentiment score
    
    score = TextBlob(content).sentiment.polarity
    return score


def generate_text_features(text):
    # Extract coamment length, number of digit in the comment, and the polarity score of the comment
    # Use with apply for list of text
    
    text_len =text.apply(lambda x:len(x))
    text_digit = text.apply(lambda x:sum(c.isdigit()for c in x))
    text_polarity = text.apply(lambda x:get_polarity(str(x)))
    text_df = pd.DataFrame(list(zip(text_len,text_digit,text_polarity)),
                          columns=['text_len','text_dight','text_polarity'])
    return text_df



