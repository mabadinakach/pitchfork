from flask import Flask, jsonify
import pitchfork
import pyrebase
import random

config = {
  "apiKey": "AIzaSyAlF8VqgC2_TeFTkIaWTMoTsH7826XPbIk",
  "authDomain": "pitchfork-client.firebaseapp.com",
  "databaseURL": "https://pitchfork-client.firebaseio.com",
  "storageBucket": "pitchfork-client.appspot.com"
}

firebase = pyrebase.initialize_app(config)
app = Flask(__name__)



if __name__ == "main":
    app.debug = True
    app.run(host = "192.168.0.14", port = 5000)


@app.errorhandler(404)
def not_found(error):
    return {
    "error":404,
    "message":"Not found, Album and Artist paremters are required"
    }
@app.route('/<string:_artist>&<string:_album>')
def hello_world(_artist, _album):
    _artist = _artist[2:]
    _album = _album[2:]
    print(_artist)
    print(_album)
    db = firebase.database()
    
    try:
        p = pitchfork.search("the beatles", "help")
        #p = pitchfork.search(_artist, _album)
    except IndexError as error:
        return str(error)

    print(p.cover())

    id = random.randint(1, 10000)
    data = {"album":p.album(),"cover":p.cover(),"score":p.score(),"review":p.editorial()}
    db.child("genre").child(p.genre()).child(p.artist()).child(p.album()).set(data)
    db.child("artist").child(p.artist()).child(p.album()).set({"cover":p.cover(), "score":p.score(), "review":p.editorial()})
    json = jsonify({
        "status":True,
        "data":{
            "artist":p.artist(),
            "year":p.year(),
            "album":p.album(),
            "genre":p.genre(),
            "score":p.score(),
            "cover":p.cover(),
            "author":p.author(),
            "editorial":p.editorial(),
        }
    })
    return json
