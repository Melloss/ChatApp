from typing import Optional
from fastapi import FastAPI, HTTPException, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
from .database import Base,engine
from .routers import auth,chat
from redis import Redis
from fastapi.middleware.cors import CORSMiddleware


Base.metadata.create_all(bind=engine)



app = FastAPI(
    title='Chat App',
    version='1.0.0',
    contact={
        "name": "Melloss",
        "url": "https://melloss.dev",
        # "email": "mellossdev@gmail.com",
    },
    license_info={
        "name": "MIT License",
        "url": "https://opensource.org/licenses/MIT",
    },
    responses={
        422: {
            "description": "Validation Error",
            "content": {
                "application/json": {
                    "example": {
                        "message": "string",
                        "error_type": "string"
                    }
                }
            },
        }
    },
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace "*" with specific domains in production for security
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
redis = Redis()

class ServerResponse(BaseModel):
    message : str
    error_type : Optional[str] = Field(default=None)
    

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError) -> ServerResponse:
    error = exc.errors();
    customError =  ServerResponse(
        message=error[0]['msg'],
        error_type=error[0]['type']
    )
    return JSONResponse(content=customError.model_dump(),status_code=422)

@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException) -> JSONResponse:
    custom_error = ServerResponse(
        message=exc.detail if isinstance(exc.detail, str) else "An error occurred",
        error_type="http_error"
    )
    return JSONResponse(content=custom_error.model_dump(), status_code=exc.status_code)


@app.middleware('http')
async  def rate_limit_middleware(request: Request, call_next):
    
    client_ip = request.client.host
    key = f'rate_limit:{client_ip}'
    
    # Allow 10 requests per minute
    current = redis.incr(key)
    if current > 10:
        custom_error = ServerResponse(
            message="Rate limit exceeded",
            error_type="http_error"
        )
        return JSONResponse(custom_error.model_dump(),429)
    if current == 1:
        redis.expire(key,60
                     )
    return await call_next(request)




app.include_router(auth.router,tags=['Auth'],prefix='/auth')
app.include_router(chat.router,tags=['Chat'],prefix='/chat')


