from flask import jsonify

from . import routes


@routes.route('/special_app/save_csv')
def save_csv():
    from core.model.special_app import SpecialApp
    from core.model.special_app import save
    special = SpecialApp(code = 'com.app.that.is.special', isBank = 0, isAzar = 1)
    save(special)
    return jsonify("Ok")


