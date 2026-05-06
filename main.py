from fastapi import FastAPI, HTTPException, status
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import List


app = FastAPI(title="Automation Testing Mock API")

registered_users = set()


class Customer(BaseModel):
    FirstName: str
    LastName: str
    UserName: str
    Password: str
    Email: str


@app.post("/customer/register")
async def register_customer(customer: Customer):
    if customer.UserName in registered_users:
        return JSONResponse(
            status_code=400,
            content={
                "FaultId": "User already exists",
                "fault": "FAULT_USER_ALREADY_EXISTS"
            }
        )
    registered_users.add(customer.UserName)
    return JSONResponse(
        status_code=201,
        content={
            "SuccessCode": "OPERATION_SUCCESS",
            "Message": "Operation completed successfully"
        }
    )


class VideoGame(BaseModel):
    id: int
    name: str
    releaseDate: str
    reviewScore: int
    category: str
    rating: str


videogames_db = {
    1: {"id": 1, "name": "Red Dead Redemption 2", "releaseDate": "2018-10-26", "reviewScore": 97,
        "category": "Action-Adventure", "rating": "Mature"},
    2: {"id": 2, "name": "Ghost of Tsushima", "releaseDate": "2020-07-17", "reviewScore": 83,
        "category": "Action-Adventure", "rating": "Mature"},
    3: {"id": 3, "name": "Valorant", "releaseDate": "2020-06-02", "reviewScore": 80, "category": "Tactical Shooter",
        "rating": "Teen"},
    4: {"id": 4, "name": "Raft", "releaseDate": "2022-06-20", "reviewScore": 85, "category": "Survival",
        "rating": "Teen"}
}


@app.get("/app/videogames", response_model=List[VideoGame])
async def get_all_videogames():
    return list(videogames_db.values())


@app.get("/app/videogames/{game_id}", response_model=VideoGame)
async def get_videogame_by_id(game_id: int):
    if game_id not in videogames_db:
        raise HTTPException(status_code=404, detail="Video game not found")
    return videogames_db[game_id]


@app.post("/app/videogames")
async def add_videogame(game: VideoGame):
    if game.id in videogames_db:
        raise HTTPException(status_code=400, detail="Video game with this ID already exists")

    videogames_db[game.id] = game.dict()
    return JSONResponse(status_code=201, content={"status": "Record Added Successfully"})


@app.put("/app/videogames/{game_id}")
async def update_videogame(game_id: int, game: VideoGame):
    if game_id not in videogames_db:
        raise HTTPException(status_code=404, detail="Video game not found")

    updated_data = game.dict()
    updated_data["id"] = game_id
    videogames_db[game_id] = updated_data
    return videogames_db[game_id]


@app.delete("/app/videogames/{game_id}")
async def delete_videogame(game_id: int):
    if game_id not in videogames_db:
        raise HTTPException(status_code=404, detail="Video game not found")

    del videogames_db[game_id]
    return JSONResponse(status_code=200, content={"status": "Record Deleted Successfully"})
