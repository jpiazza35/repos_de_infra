import logging
logger = logging.getLogger(__name__)

from core.app import db, app
from core.scrapper.scrapper import google_play_scrapper


class GooglePlayScrap(db.Model):
    __tablename__ = 'google_play_scrap'

    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String(80), unique=True, nullable=False)
    author = db.Column(db.String(120), unique=False, nullable=False)
    category = db.Column(db.String(80), unique=False, nullable=True)
    ratingsValue = db.Column(db.Float(), unique=False, nullable=False)
    ratingsCount = db.Column(db.Integer, unique=False, nullable=False)
    numDownloadsMin = db.Column(db.Integer, unique=False, nullable=False)
    numDownloadsMax = db.Column(db.Integer, unique=False, nullable=False)
    price = db.Column(db.Integer, unique=False, nullable=False)
    contentRating =  db.Column(db.String(80), unique=False, nullable=True)

    def serialize(self):
        return {
            'id': self.id,
            'code': self.code,
            'author': self.author,
            'category': self.category,
            'ratingsValue': self.ratingsValue,
            'ratingsCount': self.ratingsCount,
            'numDownloadsMin': self.numDownloadsMin,
            'numDownloadsMax': self.numDownloadsMax,
            'price': self.price,
            'contentRating': self.contentRating
        }

    def __repr__(self):
        return '<GooglePlayScrap %r>' % self.code

    def __str__(self):
        return '{self.id}'


def getByCode(code):

    scrap = GooglePlayScrap.query.filter_by(code=code).first()
    if(not scrap):
        scrappedResult = google_play_scrapper(code)
        if(scrappedResult):
            scrap = GooglePlayScrap(code=code, author=scrappedResult['author'], category=scrappedResult['category'],
                                    ratingsValue = scrappedResult['ratingsValue'], ratingsCount = scrappedResult['ratingsCount'],
                                    numDownloadsMin = scrappedResult['numDownloadsMin'], numDownloadsMax = scrappedResult['numDownloadsMax'],
                                    price = scrappedResult['price'], contentRating = scrappedResult['contentRating'])
            db.session.add(scrap)
            db.session.commit()
        else:
            scrap = None

    return scrap
