from fastapi import APIRouter,WebSocket,Path,HTTPException
from pydantic import BaseModel
from sqlalchemy import or_

from ..models import Chat,User
from ..utils.websocket import manager
from ..utils.jwt import get_user_data
from ..utils.dependencies import db_dependency,user_dependency
from .auth import UserResponse

router = APIRouter()

class ChatResponse(BaseModel):
    id: int
    text: str
    updated_date: str
    to_user: int
    from_user:int
    is_seen : bool
    is_edited : bool
    
class ChatError(BaseModel):
    error : str
    error_type: str = 'websocket_error'


@router.websocket('/send/{to_user}/{token}')
async def send_chat(websocket:WebSocket,db:db_dependency,to_user:int,token: str = None):
    try:
        print(token);
        # token = websocket.headers.get('token')
        if not token:
            await manager.disconnect(websocket)
            return
        from_user = get_user_data(token,is_websocket=True).get('id')
        websocket.state.user_id = from_user
        await manager.connect(websocket)
        while True:
            data = await manager.receive_data(websocket)
            if "message" in data:
                chat = Chat(
                    text = data['message'],
                    from_user = from_user,
                    to_user = to_user,
                    is_seen = False,
                    is_edited = False,
                )
                db.add(chat)
                db.commit()
                db.refresh(chat)
                chat_response = ChatResponse(
                    id=chat.id,
                    text=chat.text,
                    to_user=chat.to_user,
                    updated_date=str(chat.updated_date),
                    is_edited=chat.is_edited,
                    from_user=chat.from_user,
                    is_seen=chat.is_seen
                ).model_dump()
                await manager.sent_only_to(to_user=to_user,data=chat_response)
                await manager.send(websockt=websocket,data=chat_response)
            elif "command" in data:
                if (data.get("command")  == "chats"):
                    chats = db.query(Chat).order_by(Chat.created_date.asc()).filter(or_((Chat.to_user == to_user) & (Chat.from_user == from_user),(Chat.to_user == from_user) & (Chat.from_user == to_user)),).all()
                    chats_response = []
                    for c in chats:
                        chat_response = ChatResponse(
                            id=c.id,
                            text=c.text,
                            to_user=c.to_user,
                            updated_date=str(c.updated_date),
                            is_edited=c.is_edited,
                            from_user=c.from_user,
                            is_seen=c.is_seen
                        ).model_dump()
                        chats_response.append(chat_response)
                    await manager.send(websockt=websocket,data={'chats':chats_response},)
                elif (data.get("command") == 'disconnect'):
                    await manager.disconnect(websocket=websocket)
            else:
                error = ChatError(error="Invalid request")
                await manager.send(websocket,error.model_dump())
    except Exception  as e:
        print(e)
        await manager.disconnect(websocket)
        

@router.delete('/{chat_id}')
async def delete_chat(db: db_dependency,user:user_dependency,chat_id: int = Path(gt=0)) -> ChatResponse:
    chat = db.query(Chat).filter(Chat.id == chat_id and user.get('id') == Chat.from_user).first()
    if chat: 
        db.delete(chat)
        db.commit()
        chat_response = ChatResponse(
            id=chat.id,
            text=chat.text,
            to_user=chat.to_user,
            updated_date=str(chat.updated_date),
            is_edited=chat.is_edited,
            from_user=chat.from_user,
            is_seen=chat.is_seen
        )
        return chat_response
    raise HTTPException(detail='Chat not found',status_code=404)

@router.get('/sessions')

def get_active_sessions(db: db_dependency,user:user_dependency) -> list[UserResponse]:
    user_ids = {websocket.state.user_id for websocket in manager.active_connections}
    users = db.query(User).filter(User.id.in_(user_ids)).all()
    return users
