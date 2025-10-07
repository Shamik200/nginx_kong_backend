from fastapi import FastAPI
from pydantic import BaseModel
import json
import os

app = FastAPI()

userData = [
    {
        "id":1,
        "name":"Niraj"
    },
    {
        "id":2,
        "name":"Penguin"
    }
]

@app.get("/favicon.ico")
def favicon():
    return {"message": "This is It."}

@app.get("/")
def base():
    return {"message": "This is It."}

@app.get("/users")
def getData():
    return userData

class User(BaseModel):
    name: str

@app.post("/users")
def addData(user: User):
    new_user = {
        "id": len(userData) + 1,
        "name": user.name
    }
    userData.append(new_user)

    return {"message": "user added"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=3001)