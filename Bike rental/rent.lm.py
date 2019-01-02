
# coding: utf-8

# In[1]:


import os
import pandas as pd
import numpy as np
import matplotlib as mlt
import matplotlib.pyplot as plt
import seaborn as sn


# In[2]:


os.chdir("G:/bike rental project")


# In[3]:


rent=pd.read_csv("day.csv")


# In[4]:


rent.columns


# In[5]:


rent=rent.drop(['instant','dteday'],axis=1)


# In[6]:


rent.isnull().sum()


# In[7]:


cnames=['temp','atemp','hum','windspeed','casual','registered','cnt']


# In[8]:


for i in cnames:
    q75,q25=np.percentile(rent.loc[:,i],[75,25])
    iqr=q75-q25
    min=q25-(iqr*1.5)
    max=q75+(iqr*1.5)
    rent=rent.drop(rent[rent.loc[:,i]<min].index)
    rent=rent.drop(rent[rent.loc[:,i]>max].index)


# In[9]:


rent_corr=rent.loc[:,cnames]


# In[10]:


f,ax=plt.subplots(figsize=(7,5))
corr=rent_corr.corr()
sn.heatmap(corr,mask=np.zeros_like(corr,dtype=np.bool),cmap=sn.diverging_palette(220,10,as_cmap=True),square=True,ax=ax)


# In[11]:


rent=rent.drop(['atemp','casual','registered'],axis=1)


# In[12]:


from sklearn.cross_validation import train_test_split


# In[13]:


train,test=train_test_split(rent,test_size=0.2)


# In[14]:


import statsmodels.api as sm


# In[15]:


lm=sm.OLS(train.iloc[:,10],train.iloc[:,0:10]).fit()


# In[16]:


lm.summary()

