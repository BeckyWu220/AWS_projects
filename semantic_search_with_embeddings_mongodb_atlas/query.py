from db import *

query = "imaginary characters from outer space at war"

# Perform a vector search in MongoDB collection 
# The `plot_embedding_hf` field needs to semantically similar to the provided query. 
results = collection.aggregate([
  {
    "$vectorSearch": {
        "queryVector": generate_embedding(query),
        "path": "plot_embedding_hf",
        "numCandidates": 100,
        "limit": 4,
        "index": os.getenv('SEARCH_INDEX_NAME'),
    }
  }
])

for document in results:
    print(f'Movie Name: {document["title"]},\nMovie Plot: {document["plot"]}\n')