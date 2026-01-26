#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
from sqlalchemy import create_engine, select


# In[2]:


engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')


# In[3]:


taxi_zone_prefix = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/'
df_taxi_zone = pd.read_csv(taxi_zone_prefix + 'taxi_zone_lookup.csv')


# In[4]:


green_taxi_prefix = 'https://d37ci6vzurychx.cloudfront.net/trip-data/'
df_green_taxi = pd.read_parquet(green_taxi_prefix + 'green_tripdata_2025-11.parquet')


# In[5]:


df_green_taxi.to_sql(
    name="green_taxi_data",
    con=engine,
    if_exists="append",
    chunksize=100
)


# In[6]:


print("green_taxi_data table created and data inserted")


# In[7]:


df_taxi_zone.to_sql(
    name="taxi_zone",
    con=engine,
    if_exists="append",
     chunksize=100
)


# In[8]:


print("taxi_zone table created and data inserted")


# In[ ]:




