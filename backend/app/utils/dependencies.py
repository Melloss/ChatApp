from fastapi import Depends
from redis import Redis,ConnectionPool
from fastapi.security.oauth2 import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from typing import Annotated, Optional

from ..database import SessionLocal
from .jwt import get_user_data

    
oauth2_scheme = OAuth2PasswordBearer(tokenUrl='/auth/login')

redis_pool = ConnectionPool(
    host='localhost',
    port=6379,
    db=0,
    max_connections=10
)
def get_user(token:str = Depends(oauth2_scheme)) -> dict:
    return get_user_data(token)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
        
        

# def get_redis():
#     redis = Redis(connection_pool=redis_pool)
#     try:
#         redis.ping()
#     except redis.exceptions.ConnectionError:
#         raise RuntimeError("Redis connection failed")
#     return redis
    
    
# redis_dependency = Annotated[Redis,Depends(get_redis)]
user_dependency = Annotated[dict,Depends(get_user)]
db_dependency = Annotated[Session,Depends(get_db)]


