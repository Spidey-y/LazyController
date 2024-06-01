from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.responses import JSONResponse
import keyboard
import pyautogui


app = FastAPI()
pyautogui.FAILSAFE = False


@app.get('/play_pause')
def play_pause():
    keyboard.press_and_release('play/pause media')
    message = 'Play/Pause button pressed'
    print(message)
    return JSONResponse(content={'message': 'play/pause'})


@app.get('/next_track')
def next_track():
    keyboard.press_and_release('next track')
    message = 'Next track button pressed'
    print(message)
    return JSONResponse(content={'message': 'next track'})


@app.get('/previous_track')
def previous_track():
    keyboard.press_and_release('previous track')
    message = 'Previous track button pressed'
    print(message)
    return JSONResponse(content={'message': 'previous track'})


@app.get('/volume_up')
def volume_up():
    keyboard.press_and_release('volume up')
    message = 'Volume up button pressed'
    print(message)
    return JSONResponse(content={'message': 'volume up'})


@app.get('/volume_down')
def volume_down():
    keyboard.press_and_release('volume down')
    message = 'Volume down button pressed'
    print(message)
    return JSONResponse(content={'message': 'volume down'})


@app.get('/mute')
def mute():
    keyboard.press_and_release('volume mute')
    message = 'Mute button pressed'
    print(message)
    return JSONResponse(content={'message': 'mute'})


async def move_cursor(websocket: WebSocket):
    try:
        width, height = pyautogui.size()
        scale = .5
        await websocket.accept()
        while True:
            data = await websocket.receive_json()
            if "x" in data and "y" in data:
                x = data["x"] * width * scale
                y = data["y"] * height * scale
                pyautogui.moveTo(x, y)
            if "click" in data and data["click"] == "true":
                pyautogui.click()
            if "right_click" in data and data["right_click"] == "true":
                pyautogui.rightClick()
    except WebSocketDisconnect:
        pass


@app.websocket('/move')
async def move_handler(websocket: WebSocket):
    await move_cursor(websocket)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5000)
