from flask import jsonify

from . import routes


@routes.route('/util/google_scrap/<code>')
def google_scrap(code):
    from core.model import google_play_scrap
    obj = google_play_scrap.getByCode(code)
    if(obj):
        return jsonify(obj.serialize())
    return jsonify("code not found")
