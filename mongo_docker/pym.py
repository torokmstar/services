import os
from datetime import datetime

from pymongo import MongoClient

HOST = os.environ.get("MONGO_HOST", "localhost")
PORT = os.environ.get("MONGO_PORT", "27017")

client = MongoClient("mongodb://" + HOST + ":" + PORT)
db = client.mymongo

result = db.restaurants.insert_one(
    {
        "address": {
            "street": "2 Avenue",
            "zipcode": "10075",
            "building": "1480",
            "coord": [-73.9557413, 40.7720266]
        },
        "borough": "Manhattan",
        "cuisine": "Italian",
        "grades": [
            {
                "date": datetime.strptime("2014-10-01", "%Y-%m-%d"),
                "grade": "A",
                "score": 11
            },
            {
                "date": datetime.strptime("2014-01-16", "%Y-%m-%d"),
                "grade": "B",
                "score": 17
            }
        ],
        "name": "Vella",
        "restaurant_id": "41704620"
    }
)

print(result.inserted_id)

cursor = db.restaurants.find()

for document in cursor:
    print(document)
