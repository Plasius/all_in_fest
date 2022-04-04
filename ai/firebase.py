import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import random

# code
import numpy as np
import pandas as pd
import sklearn
import matplotlib.pyplot as plt
import seaborn as sns

''' use once
import os
os.environ["GOOGLE_APPLICATION_CREDENTIALS"]="/Users/plasius/.spyder-py3/serviceAccountKey.json"
'''


def get_dfs():
    cred = credentials.Certificate("serviceAccountKey.json")
    try:
        firebase_admin.initialize_app(cred)
    except:
        pass
    
    db = firestore.client()
    
    
    
    
    # construct fav df
    favs = {}
    
    fav_ref = db.collection(u'favorites')
    fav_docs = fav_ref.stream()
    
    data = []
    index = 0
    for doc in fav_docs:
        doc = doc.to_dict()
        data.append([doc['userId'], doc['eventId']])
        
        if doc['userId'] in favs:
            favs[doc['userId']].append(doc['eventId'])
        else:
            favs[doc['userId']] = [doc['eventId']]
            
        index+=1
    
    fav_df = pd.DataFrame(data, columns=['userId', 'eventId'])
    
    
    # construct events df
    events_ref = db.collection(u'events')
    events_docs = events_ref.stream()
    
    
    data = []
    index = 0
    for doc in events_docs:
        doc = doc.to_dict()
        data.append([doc['id'], doc['name']])
        index+=1
    
    events_df = pd.DataFrame(data, columns=['eventId', 'title'])
    
    
    
    return events_df, fav_df, favs


'''
favorites_ref = db.collection(u'favorites')
favorites_docs = favorites_ref.stream()

for doc in docs:
    print(f'{doc.id} => {doc.to_dict()}')
    

event_df = pd.DataFrame(docs)
'''


'''
#upload to firebase
    
cred = credentials.Certificate("serviceAccountKey.json")
try:
    firebase_admin.initialize_app(cred)
except:
    pass

db = firestore.client()
'''

'''dummy events
for i in range(50):
    doc_ref = db.collection(u'events').document(u'event'+str(i))
    doc_ref.set({
        u'id': i,
        u'name': u'event'+str(i)
    })
'''

'''dummy favorites
for i in range(100):
    doc_ref = db.collection(u'favorites').document(u'favorite'+str(i))
    doc_ref.set({
        u'userId': int(random.random()*25),
        u'eventId': int(random.random()*50)
    })
'''
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    