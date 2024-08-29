import logging
logger = logging.getLogger(__name__)

from core.app import db, app
from core.scrapper.scrapper import google_play_scrapper


class SpecialApp(db.Model):
    __tablename__ = 'special_app'

    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String(80), unique=True, nullable=False)
    isBank = db.Column(db.Boolean(), unique=False, nullable=False)
    isAzar = db.Column(db.Boolean(), unique=False, nullable=False)

    def serialize(self):
        return {
            'id': self.id,
            'code': self.code,
            'isBank': self.isBank,
            'isAzar': self.isAzar
        }

    def __repr__(self):
        return '<SpecialApp %r>' % self.code

    def __str__(self):
        return '{self.id}'


def save(SpecialApp):
    
    db.session.add(SpecialApp)
    db.session.commit()
