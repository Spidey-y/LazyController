import logging
import sys
from flask import Flask, jsonify
import keyboard
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

logging.disable(logging.CRITICAL)


@app.route('/play_pause')
def play_pause():
    keyboard.press_and_release('play/pause media')
    message = 'Play/Pause button pressed'
    print(message)
    return jsonify({'message': 'play/pause'})


@app.route('/next_track')
def next_track():
    keyboard.press_and_release('next track')
    message = 'Next track button pressed'
    print(message)
    return jsonify({'message': 'next track'})


@app.route('/previous_track')
def previous_track():
    keyboard.press_and_release('previous track')
    message = 'Previous track button pressed'
    print(message)
    return jsonify({'message': 'previous track'})


@app.route('/volume_up')
def volume_up():
    keyboard.press_and_release('volume up')
    message = 'Volume up button pressed'
    print(message)
    return jsonify({'message': 'volume up'})


@app.route('/volume_down')
def volume_down():
    keyboard.press_and_release('volume down')
    message = 'Volume down button pressed'
    print(message)
    return jsonify({'message': 'volume down'})


@app.route('/mute')
def mute():
    keyboard.press_and_release('volume mute')
    message = 'Mute button pressed'
    print(message)
    return jsonify({'message': 'mute'})


cli = sys.modules['flask.cli']
cli.show_server_banner = lambda *x: None
if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=sys.argv[1])
