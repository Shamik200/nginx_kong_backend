from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List

app = FastAPI()

posts = [
    {
        "title":"t1",
        "content":"This is First Post",
        "userId":100
    }
]

class Post(BaseModel):
    title: str
    content: str
    userId: int

@app.get("/posts", response_model=List[dict])
def get_posts():
    return posts

@app.post("/posts", status_code=201)
def create_post(post: Post):
    new_post = {
        "id": len(posts) + 1,
        "title": post.title,
        "content": post.content,
        "userId": post.userId
    }
    posts.append(new_post)
    return new_post

@app.put("/posts/{post_id}")
def update_post(post_id: int, updated: Post):
    for post in posts:
        if post["id"] == post_id:
            post["title"] = updated.title
            post["content"] = updated.content
            return post
    raise HTTPException(status_code=404, detail="Post not found")

@app.delete("/posts/{post_id}", status_code=204)
def delete_post(post_id: int):
    global posts
    posts = [p for p in posts if p["id"] != post_id]
    return

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=3002)