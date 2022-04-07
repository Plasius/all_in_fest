# code
import numpy as np
import pandas as pd
import sklearn
import matplotlib.pyplot as plt
import seaborn as sns
from collections import Counter

import firebase

import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)

'''
favorites = pd.read_csv("/Users/plasius/Desktop/favorites.csv")
favorites.head()

events = pd.read_csv("/Users/plasius/Desktop/events.csv")
events.head()
'''



events, favorites, favs = firebase.get_dfs()



n_favorites = len(favorites)
n_events = len(favorites['eventId'].unique())
n_users = len(favorites['userId'].unique())

print(f"Number of favorites: {n_favorites}")
print(f"Number of unique events: {n_events}")
print(f"Number of unique users: {n_users}")
print(f"Average favorites per user: {round(n_favorites/n_users, 2)}")
print(f"Average favorites per event: {round(n_favorites/n_events, 2)}")

user_freq = favorites[['userId', 'eventId']].groupby('userId').count().reset_index()
user_freq.columns = ['userId', 'n_favorites']
user_freq.head()


# Find Lowest and Highest rated events:
mean_favorite = favorites.groupby('eventId')[['userId']].mean()
# Lowest rated events
lowest_rated = mean_favorite['userId'].idxmin()
events.loc[events['eventId'] == lowest_rated]
# Highest rated events
highest_rated = mean_favorite['userId'].idxmax()
events.loc[events['eventId'] == highest_rated]
# show number of people who rated events rated event highest
favorites[favorites['eventId']==highest_rated]
# show number of people who rated events rated event lowest
favorites[favorites['eventId']==lowest_rated]

## the above events has very low dataset. We will use bayesian average
event_stats = favorites.groupby('eventId')[['userId']].agg(['count', 'mean'])
event_stats.columns = event_stats.columns.droplevel()

# Now, we create user-item matrix using scipy csr matrix
from scipy.sparse import csr_matrix

def create_matrix(df):
	
	N = len(df['userId'].unique())
	M = len(df['eventId'].unique())
    
    # Map Ids to indices
	user_mapper = dict(zip(np.unique(df["userId"]), list(range(N))))
	event_mapper = dict(zip(np.unique(df["eventId"]), list(range(M))))
	
	# Map indices to IDs
	user_inv_mapper = dict(zip(list(range(N)), np.unique(df["userId"])))
	event_inv_mapper = dict(zip(list(range(M)), np.unique(df["eventId"])))
	
	user_index = [user_mapper[i] for i in df['userId']]
	event_index = [event_mapper[i] for i in df['eventId']]

	X = csr_matrix((df["userId"], (event_index, user_index)), shape=(M, N))
	
	return X, user_mapper, event_mapper, user_inv_mapper, event_inv_mapper

X, user_mapper, event_mapper, user_inv_mapper, event_inv_mapper = create_matrix(favorites)

from sklearn.neighbors import NearestNeighbors
"""
Find similar events using KNN
"""
def find_similar_events(event_id, X, k, metric='cosine', show_distance=False):
	
	neighbour_ids = []
	
	event_ind = event_mapper[event_id]
	event_vec = X[event_ind]
	k+=1
	kNN = NearestNeighbors(n_neighbors=k, algorithm="brute", metric=metric)
	kNN.fit(X)
	event_vec = event_vec.reshape(1,-1)
	neighbour = kNN.kneighbors(event_vec, return_distance=show_distance)
	for i in range(0,k):
		n = neighbour.item(i)
		neighbour_ids.append(event_inv_mapper[n])
	neighbour_ids.pop(0)
	return neighbour_ids


event_titles = dict(zip(events['eventId'], events['title']))

event_id = 1

similar_ids = find_similar_events(event_id, X, k=10)
event_title = event_titles[event_id]


rec_freq = {}
current_user = 0

#print(favs[current_user])

for event in favs[current_user]:
    similar_ids = find_similar_events(event, X, k=5)
    for i in similar_ids:
        if i in rec_freq:
            rec_freq[i]+=1
        else:
            rec_freq[i]=1
            
print(rec_freq)

k = Counter(rec_freq)
 
# Finding 3 highest values
high = k.most_common(3)

for i in high:
    print(events['title'][i[0]])



'''
print(f"Since you liked {event_title}")
for i in similar_ids:
	print(event_titles[i])
'''
    
    


