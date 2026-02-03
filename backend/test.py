from . import app

#A testing endpoint
@app.route("/test")
def test():
	return "Hello world"