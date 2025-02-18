from .database import Base
from sqlalchemy import Column,Integer,String,DateTime,ForeignKey,Boolean
from datetime import datetime,timezone

class User(Base):
    __tablename__ = 'user'
    
    id = Column(Integer,primary_key=True,index=True)
    first_name = Column(String,nullable=False)
    last_name = Column(String,nullable=False)
    email = Column(String, unique=True,nullable=False)
    hashed_password = Column(String,nullable=False)
    created_date = Column(
        DateTime, 
        default=lambda: datetime.now(timezone.utc),  # Callable for fresh time
        nullable=False
    )
    updated_date = Column(
        DateTime, 
        default=lambda: datetime.now(timezone.utc), 
        onupdate=lambda: datetime.now(timezone.utc),  # Callable for updates
        nullable=False
    )
    

    
class Chat(Base):
    __tablename__ = 'chat'
    
    id = Column(Integer, primary_key=True, index=True)
    text = Column(String, nullable=False)
    is_seen = Column(Boolean, nullable=False)
    is_edited = Column(Boolean, nullable=False)
    created_date = Column(
        DateTime, 
        default=lambda: datetime.now(timezone.utc),  # Callable for fresh time
        nullable=False
    )
    updated_date = Column(
        DateTime, 
        default=lambda: datetime.now(timezone.utc), 
        onupdate=lambda: datetime.now(timezone.utc),  # Callable for updates
        nullable=False
    )
    from_user = Column(Integer, ForeignKey('user.id'), nullable=False, index=True)
    to_user = Column(Integer, ForeignKey('user.id'), nullable=False, index=True)
    