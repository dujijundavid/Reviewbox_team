This folder contains 3 main notebooks and an input datasets folder. We also include a data dictionary to explain the metrics we aggregated from the sales rank, reviews and price datasets. 

Please note the following instructions before running them:

0. Input Datasets of Feature Engineering Code:

Avery_BulkReviewsExport_Nov2019-Mar2020.csv
BULK_all_56e3bb29-6796-44a0-8918-0cc355344eab.csv
BuyboxExport_5c5e6d9d-e9c4-47da-b68c-df0c270afcb8.csv
BuyboxExport_8a64b831-a793-4cfc-acd0-9713b89ff12f.csv
BuyboxExport_eaf8d027-48c3-40c6-8147-7e41eded6c5c.csv
SalesRankExport_Avery_April2019.csv
SalesRankExport_Avery_August2019.csv
SalesRankExport_Avery_December2019.csv
SalesRankExport_Avery_January2020.csv
SalesRankExport_Avery_July2019.csv
SalesRankExport_Avery_June2019.csv
SalesRankExport_Avery_March2019.csv
SalesRankExport_Avery_May2019.csv
SalesRankExport_Avery_November2019.csv
SalesRankExport_Avery_October2019.csv
SalesRankExport_Avery_September2019.csv
SalesRankExport_f390988e-4679-471d-b9bb-b2a35062976b.csv

1. SS Feature Engineering Code - Colab Version.ipynb

    This notebook is created for feature engineering and can be run on Google Colab. If you have access to the shared folder "UC Davis Practicum", we recommend using this notebook for feature engineering, as the input datasets for Sales Score project are scattered around. This Colab version code will reduce your effort in downloading these datasets. Before running the code, please make sure that you have network connection and the authorization to access the shared folder "UC Davis Practicum". 


2. SS Feature Engineering Code - Local Version.ipynb

    This notebook has the same content as the "SS Feature Engineering Code - Colab Version.ipynb", and can be run on local computer. To use this code, you need to download all the input datasets to run it locally. The input datasets are in the folder "Input Dataset of Feature Engineering Code".


3. Sales Score Model.ipynb

    This notebook covers the machine learning part of the project. This code should be used after running either of the feature engineering codes. The input of the modeling code is the output of the feature engineering code.


