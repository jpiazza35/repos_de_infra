def google_play_scrapper(code):
    import requests
    from bs4 import BeautifulSoup
    import re

    url = 'https://play.google.com/store/apps/details?id=' + code + '&hl=es'

    response = requests.get(url)
    if response.status_code == 200:

        soup = BeautifulSoup(response.content, 'html.parser')
        category = soup.find('a', class_='document-subtitle category').find('span').get_text()
        ratingsValue = soup.find('meta', {'itemprop': 'ratingValue'})['content']
        ratingsCount = soup.find('meta', {'itemprop': 'ratingCount'})['content']
        author = soup.find('div', {'itemprop': 'author'}).a.get_text()
        numDownloads = soup.find('div', {'itemprop': 'numDownloads'}).text.split('-')
        price = soup.find('meta', {'itemprop': 'price'})['content']
        contentRating = soup.find('div', {'itemprop': 'contentRating'}).text.strip()

        app_info = {'code': code,
                    'category': category,
                    'contentRating': contentRating,
                    'ratingsValue': float(ratingsValue),
                    'ratingsCount': int(ratingsCount),
                    'price': [int(s) for s in re.findall(r'\b\d+\b', price)][0],
                    'author': author,
                    'numDownloadsMin': int(numDownloads[0].rstrip().lstrip().replace('.', '')),
                    'numDownloadsMax': int(numDownloads[1].rstrip().lstrip().replace('.', ''))
                    }
        return app_info

    else:
        return None
