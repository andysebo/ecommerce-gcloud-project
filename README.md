
# E-Commerce Conversion & Process Funnel
**Live Dashboard:** View the interactive [Streamlit](https://ecommerce-gcloud-project-tqfx7hv4kg8jgcajgw2sbl.streamlit.app) app here.

## Oveview of the project:

This project is focused on UX/process optimalization by deriving insights from the REES46 dataset - representing user behavior on an online store. The use of Google Cloud Services (GCS) and Google's BigQuery, along with SQL queries and funnels to generate features allows us to obtain inputs for a machine learning model - specifically the Random Forest algorithm. The classification algorithmThe results of the project can also be viewed as a Streamlit dashboard deployed on Streamlit Community Cloud which also serves as a visual summary of the findings.

# The data:

**The REES46 dataset** consists of over **42 million rows** and represents **the raw, click-level event logs of user behavior on a large, multi-category e-commerce platform.**

To get a better understanding of the data, let's summarize the data generating process behind it: 

**Every time a shopper interacts with the website, an analytics engine captures that micro-event and writes a new row to the database. The millisecond a user opens a product page, a `view` event is logged with a precise UTC timestamp. If they click the "Add to Cart" button, a `cart` event is recorded. Finally, if they successfully navigate the checkout process, a `purchase` event is generated. All of these sequential, individual actions are tied together by a temporary `user_session` ID, creating a complete digital footprint of their exact shopping journey.**

**The 9 columns of the dataset include:**

| Column Name | Description |
| :--- | :--- |
| **`event_time`** | The exact UTC timestamp when the user clicked or took an action. |
| **`event_type`** | The specific action the user took. In this dataset this would always be one of these three actions 1. view (looking at a product) 2. cart (added to cart) 3. purchase |
| **`product_id`** | The unique numerical ID of the item th user interacted with. |
| **`category_id`** | A unique numerical ID for the broad category the product belongs to. |
| **`category_code`** | The human-readable category tree of the product (e.g. electronics.smartphone) |
| **`brand`** | The brand name of the product. |
| **`price`** | The price of the product in USD. |
| **`user_id`** | A permanent, unique numerical ID assigned to a specific shopper. |
| **`user_session`** | A temporary ID assigned to a user's specific visit. | 

# Data operations and feature engineering:

The data was initially downloaded from Kaggle to local disk and then uploaded into a Google Cloud Storage (GCS) Bucket. From GCS the data was loaded into Google's Big Query - a Cloud Data Warehouse - in order to leverage the cloud performance advantage as the dataset contained around 42 million data points. This way we avoided the memory problem - performing these operations locally would likely lead to a out of memory error due to pandas use of local RAM.

As the dataset contained rows which were micro-events, data aggregation was necessary to reduce multiple rows into separate user sessions. Creating features such as **total product views**, **cart additions**, and **session duration**, the necessary input data for the Random Forest algorithm was obtained. 

The goal of the ML analysis is to figure out **the exact probability that a browsing session will convert into a successful purchase based entirely on the user's clicking behavior**. For that end, we needed to extract this behavioral info from the raw data. We started by grouping the individual rows by `user_session`. This gave us the ability to look at and evaluate each session separately, regardless of the user's lifetime history. The inputs (features) fed into the model were then the following:

* **`total_events_in_session`**: The absolute volume of clicks and actions during the visit.
* **`total_views`**: How many specific product pages the shopper looked at.
* **`total_cart_adds`**: How many times they clicked the "Add to Cart" button.
* **`session_duration_seconds`**: The total elapsed time between their very first and very last click.
* **`made_purchase` (Target Variable)**: The binary label (1 for Yes, 0 for No) that the model learned to predict.

# ML analysis:

In the `03_random_forest_training.py` script, the Google Cloud API is used to securely connect to the BigQuery data warehouse. It accesses and ingests a random, representative sample of 100,000 aggregated user sessions from the cloud into a local pandas DataFrame. The data is then split into standard 80/20 train-test subsets. 

A Random Forest Classifier is then trained on this data to predict conversion probability. Finally, the model's performance is evaluated against the unseen test data, and the mathematical importance of each behavioral feature is assessed. These final results—the model metrics and feature importances—are exported as lightweight CSV files to power the Streamlit dashboard.

### Conclusion & Model Insights

The Random Forest classifier achieved exceptional performance in predicting session-level conversions, reaching an **overall accuracy of 99%**. More importantly for an imbalanced e-commerce dataset, it achieved a **96% recall** and **98% precision** on the minority 'purchase' class (Class 1.0). This indicates the model is highly capable of identifying true buyers while generating very few false positives.

By analyzing the model's `feature_importances_` array, we extracted the exact mathematical weights of the user behaviors driving conversions:

* **`total_views` (43.7%) & `total_events_in_session` (29.8%):** Raw browsing volume and overall active engagement were by far the strongest predictors of a final conversion, combining for over 73% of the model's decision weight.
* **`total_cart_adds` (19.8%):** While a clear signal of purchase intent, cart additions served as a strong secondary feature rather than the primary driver.
* **`session_duration_seconds` (6.7%):** Time spent on site had the lowest predictive power. This suggests that *active clicking and exploration* is a much stronger buying signal than simply how long a session remains open.

Ultimately, these outputs prove that tracking active product exploration is the most critical metric for identifying high-intent shoppers on this platform. Deployed via Streamlit, these insights allow the business to confidently target highly active browsers, rather than just relying on cart-abandonment metrics.
