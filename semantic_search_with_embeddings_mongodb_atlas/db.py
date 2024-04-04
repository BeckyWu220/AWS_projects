import os
import requests
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from dotenv import load_dotenv

load_dotenv()

uri = "mongodb+srv://{}:{}@{}/?retryWrites=true&w=majority&appName=AltasCluster".format(os.getenv('MONGODB_USERNAME'), os.getenv('MONGODB_PASSWORD'), os.getenv('MONGODB_URL'), )

# Create a new client and connect to the server
client = MongoClient(uri, server_api=ServerApi('1'))

# Send a ping to confirm a successful connection
# try:
#     client.admin.command('ping')
#     print("Pinged your deployment. You successfully connected to MongoDB!")
# except Exception as e:
#     print(e)

db = client.sample_mflix
collection = db.movies

# items = collection.find().limit(5)

# for item in items:
#     print(item)

# Create embeddings with Huggingface Inference API - all-MiniLM-L6-v2
hf_token = os.getenv('HUGGINGFACE_API_TOKEN')
EMBEDDING_URL = 'https://api-inference.huggingface.co/pipeline/feature-extraction/sentence-transformers/all-MiniLM-L6-v2'

def generate_embedding(text: str) -> list[float]:

    response = requests.post(
        EMBEDDING_URL,
        headers={"Authorization": f"Bearer {hf_token}"},
        json={"inputs": text}
    )

    if response.status_code != 200:
        raise ValueError(f"Request failed with status code {response.status_code}: {response.text}")

    return response.json()
