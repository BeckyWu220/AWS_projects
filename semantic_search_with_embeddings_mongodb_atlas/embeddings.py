from db import *

# Generate embedding vectors for `plot` field of up to 50 movies.
for doc in collection.find({'plot':{"$exists": True}}).limit(50):
  doc['plot_embedding_hf'] = generate_embedding(doc['plot'])
  collection.replace_one({'_id': doc['_id']}, doc)