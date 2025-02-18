import jwt
from fastapi import HTTPException,WebSocketException
from datetime import datetime,timedelta,timezone

SECRECT_KEY = '1IjQ7PPFPaU-0OyQITFryxN8MxSEW8_iMkykA-Gr35I='
ALGORIGHM = 'HS256'
EXPIRE_MINUTE = 30

def create_access_token(data:dict,expire_delta: timedelta | None = None) -> str:
    to_encode = data.copy()
    expires = datetime.now(timezone.utc) + (expire_delta or timedelta(minutes=float(EXPIRE_MINUTE)))
    to_encode.update({
        "exp":expires
    })
    return jwt.encode(to_encode,SECRECT_KEY,algorithm=ALGORIGHM)
    
def get_user_data(token: str,is_websocket= False) -> dict:
    try:
        decoded_data = jwt.decode(token,SECRECT_KEY,algorithms=ALGORIGHM)
        return decoded_data
    except jwt.ExpiredSignatureError:
        if is_websocket:
            raise WebSocketException(code=1000,reason="Token has expired")
        else:
            raise HTTPException(status_code=400,detail="Token has expired")
    except: 
        if is_websocket:
            raise WebSocketException(reason="Invalid Token",code=1000)
        else:
            raise HTTPException(detail="Invalid Token",status_code=400)

       