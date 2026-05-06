from fastapi import FastAPI, status
from fastapi.responses import JSONResponse
from pydantic import BaseModel

app = FastAPI(title="DemoQA Mock API")

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