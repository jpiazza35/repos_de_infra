from selenium import webdriver


def selenium_driver(
    download_directory: str
) -> webdriver:

    # Configure driver for Docker container
    options = webdriver.ChromeOptions()
    options.add_argument('--ignore-ssl-errors=yes')
    options.add_argument('--ignore-certificate-errors')
    options.binary_location = "/usr/bin/google-chrome"  # chrome binary location specified here
    options.add_argument("--no-sandbox")  # bypass OS security model
    options.add_argument("--disable-dev-shm-usage")  # overcome limited resource problems
    options.add_argument("--headless")

    # Specify download location
    prefs = {'download.default_directory': download_directory}
    options.add_experimental_option('prefs', prefs)
    return webdriver.Chrome(options=options)

