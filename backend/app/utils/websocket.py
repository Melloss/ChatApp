from fastapi import WebSocket
import json

from fastapi.websockets import WebSocketState

class ConnctionManager:
    def __init__(self):
        self.active_connections: list[WebSocket] = []
    
    async def connect(self,websocket: WebSocket):
        await websocket.accept()
        for connection in self.active_connections:
            if(connection.state.user_id == websocket.state.user_id):
                await connection.close()
                self.active_connections.remove(connection)
                break;
        self.active_connections.append(websocket)
        print(f"connections: {self.active_connections}")
        
    async def disconnect(self, websocket: WebSocket):
        if(websocket.application_state != WebSocketState.DISCONNECTED):
            await websocket.close()
            self.active_connections.remove(websocket)
        
    async def receive_data(self,websocket: WebSocket):
        data= await websocket.receive_text()
        dictData = json.loads(data)
        
        return dictData
    async def send(self, websockt: WebSocket,data: dict):
        await websockt.send_json(data)
     
    async def sent_only_to(self,to_user:int,data:dict):
        for connection in self.active_connections:
                if(connection.state.user_id == to_user):
                    await connection.send_json(data)
                    break
    
    async def brodcast(self, data: dict):
        for connection in self.active_connections:
            await connection.send_json(data)
        
        
manager = ConnctionManager()