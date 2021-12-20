from flask import Flask
import logging

logging.basicConfig(filename='app.log', level=logging.INFO)

log = logging.getLogger()

app = Flask(__name__)


@app.route('/sayhi', methods=['GET'])
def say_hello():
    log.info("Saying Hello")
    return "Hello Altais"
