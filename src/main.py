import json

def save_global_config(httpIp, httpPort, httpsIp, httpsPort, noProxyList):
    proxySettings = {
        'http_proxy': httpIp + ':' + httpPort,
        'https_proxy': httpsIp + ':' + httpsPort,
        'no_proxy': ','.join(noProxyList)
    }

    with open('global_config.json', 'w') as file:
        json.dump(proxySettings, file, indent=4)
    
    return json.dumps(proxySettings)  

