#!/usr/bin/python3.9
import io
import json
import os

from requests import request

try:
    configPath = os.environ["HOME"] + "/.config/waybar/owm_config.json"
    # Uses the template file and renames it to the correct name
    if not os.path.exists(configPath):
        os.system("cp " + configPath + ".template " + configPath)

    config = io.open(configPath, "r")
    apiConfig = json.loads(str(config.read()))
    config.close()
    apiKey, location = apiConfig["API_KEY"], apiConfig["location"]

    url = (
        "https://api.openweathermap.org/data/2.5/weather?q="
        + location
        + "&appid="
        + apiKey
        + "&units=imperial"
    )
    req = request("GET", url)
    result = dict(json.loads(req.text))

    if int(result["cod"]) >= 400:
        temp = result["message"]
        description = ""
        icon = ""
    else:
        temp = str(int(result["main"]["temp"])) + "°F"
        description = result["weather"][0]["description"]
        icon = result["weather"][0]["icon"]

    printDict = {"text": temp, "tooltip": description, "alt": icon, "class": icon}

    print(json.dumps(printDict))
except:
    exit(1)
