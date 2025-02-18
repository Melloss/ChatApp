from fastapi import APIRouter,HTTPException
from pydantic import BaseModel,EmailStr,Field
from sqlalchemy.exc import IntegrityError
from datetime import datetime
from ..utils.dependencies import db_dependency,user_dependency
from ..utils.hashing import hash_password,verify_password
from ..utils.jwt import create_access_token
from ..models import User
from ..utils.websocket import manager


router = APIRouter()

class UserRequest(BaseModel):
    first_name : str
    last_name : str
    email: EmailStr
    password: str
    
class LoginRequest(BaseModel):
    email : EmailStr
    password: str
    
class LoginResponse(BaseModel):
    token : str
    first_name :str
    last_name : str
    email : str
    
class UserResponse(BaseModel):
    id : int
    first_name : str
    last_name : str
    email: EmailStr
    created_date : datetime
    updated_date : datetime
    status: str = 'ONLINE'
    

@router.post('/login',status_code=201)
def login_user(db:db_dependency, login_form: LoginRequest) -> LoginResponse:
    user = db.query(User).filter(User.email == login_form.email).first()
    if  user:
        if verify_password(login_form.password,user.hashed_password):
            data = {
                'id':user.id,
                'email':user.email,
                'first_name':user.first_name,
                'last_name':user.last_name
            }
            return LoginResponse(
                token=create_access_token(
                    data=data,
                ),
                first_name=user.first_name,
                last_name=user.last_name,
                email=user.email
            )
    raise HTTPException(status_code=404,detail='Email or Password is incorrect') 

@router.post("/signup",status_code=201)
def register_user(db:db_dependency,user: UserRequest) -> UserResponse:
    try:
        user = User(
            first_name = user.first_name,
            last_name = user.last_name,
            email = user.email,
            hashed_password= hash_password(user.password)
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        return user
    except IntegrityError as e:
        raise HTTPException(detail=e,status_code=400)
    
        
@router.get('/users')
def get_users(db:db_dependency,user:user_dependency) -> list[UserResponse]:
    users = db.query(User).filter(User.id != user['id']).all()
    user_ids = {websocket.state.user_id for websocket in manager.active_connections}
    return [
        UserResponse(
            id=u.id,
            first_name=u.first_name,
            last_name=u.last_name,
            updated_date=u.updated_date,
            created_date=u.created_date,
            email=u.email,
            status= 'ONLINE' if u.id in user_ids else 'NOT_ONLINE'
        )
        for u in users
    ]