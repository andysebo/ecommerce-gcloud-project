import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

# 1. Dashboard Settings
st.set_page_config(page_title="E-Commerce AI Insights", layout="wide")
st.title("🛒 E-Commerce Conversion & Process Funnel")
st.markdown("This dashboard analyzes millions of raw user events to identify process bottlenecks and predict customer purchases using Machine Learning.")

# 2. Load the Data
@st.cache_data
def load_data():
    importance_df = pd.read_csv('feature_importance.csv')
    metrics_df = pd.read_csv('model_metrics.csv')
    return importance_df, metrics_df

importance_df, metrics_df = load_data()

# 3. Display Top-Level Metrics
st.header("1. Machine Learning Performance")
col1, col2 = st.columns(2)
col1.metric("Model Accuracy", f"{metrics_df.iloc[0]['Score'] * 100}%")
col2.metric("Purchase Recall", f"{metrics_df.iloc[1]['Score'] * 100}%")

# 4. Plot Feature Importance
st.header("2. What Drives a Purchase? (Feature Importance)")
fig, ax = plt.subplots(figsize=(8, 4))
ax.barh(importance_df['Feature'], importance_df['Importance'], color='skyblue')
ax.set_xlabel('Importance Score')
ax.invert_yaxis()  # Put the most important feature at the top
st.pyplot(fig)

st.success("Business Insight: The number of unique views drives conversions significantly more than the total time spent on the site.")