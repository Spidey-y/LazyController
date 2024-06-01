from fastapi import FastAPI
from .app import app

asgi_application = app
