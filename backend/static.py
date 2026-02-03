from flask import render_template
from flask import request
from flask import send_file

from werkzeug.security import safe_join
import os

from . import app

FRONTEND = os.path.join(os.path.dirname(__file__), "..")
FRONTEND_SPECIFIC = {"js": "js", "css": "css", "html": "static"}

TEMPLATE_404 = "404.html"
PAGE_404 = os.path.join(FRONTEND, "404.html")

@app.errorhandler(404)
def load_static(e):
	paths = set()
	paths.add(FRONTEND)

	try:
		return render_template(request.path.split("/")[-1])
	except:
		print("Template " + request.path.split("/")[-1] + " not found")

	filetype = request.path.split(".")[-1]
	if(filetype in FRONTEND_SPECIFIC):
		paths.add(os.path.join(FRONTEND, FRONTEND_SPECIFIC[filetype]))

	for path in paths:
		path = safe_join(path, request.path.lstrip("/"))
		if(os.path.exists(path)):
			return send_file(path)

	try:
		return render_template(TEMPLATE_404), 404
	except:
		return send_file(PAGE_404), 404
