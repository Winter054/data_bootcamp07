### Pull api from public api
### Make it into a .csv

from requests import get

nums = list(range(1, 10))
result = []

for x in nums:
    url = f"https://pokeapi.co/api/v2/pokemon/{x}"
    response = get(url)
    data = response.json()
    row = [
            data["id"],
            data["name"],
            data["height"],
            data["weight"]
    ]
    result.append(row)
    print(result)

import pandas as pd

df = pd.DataFrame(result, columns = ["id", "name", "height", ["weight"]])

df.to_csv("pokemon.csv")

import csv
pokemon = []

with open("pokemon.csv", "r") as file:
    data = csv.reader(file)
    for row in data:
        pokemon.append(row)
print(pokemon)