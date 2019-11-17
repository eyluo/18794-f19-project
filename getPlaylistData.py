import sys
import spotipy
import json
import pprint
import requests
import simplejson

import urllib.request

'''
In order to use this file, provide the following in credentials.json:

{
    "user" : <user : string>, 
    "userID" : <userID : int>,
    "token" : <token : string>
}

'''

GENRES=[
    'rock',
    'pop',
    'rnb',
    'country',
    'hiphop',
    'indie_alt',
    'edm_dance',
]

def main():
    f = open("./credentials.json")
    obj = json.load(f)

    token = obj['token']
    userID = obj['userID']

    sp = spotipy.Spotify(auth=token)

    resultDict = dict()
    for genre in GENRES:
        print('fetching information for', genre)
        categoryPlaylists = sp.category_playlists(category_id=genre, country='us', limit=10)
        
        results = list()
        for playlist in categoryPlaylists['playlists']['items']:
            id = playlist['id']
            print('    fetching information for', id)

            getReq = 'https://api.spotify.com/v1/playlists/' + id

            r = requests.get(url=getReq,  headers={'Authorization': 'Bearer ' + token})

            tracks = r.json()['tracks']['items']

            for track in tracks:
                trackDict = dict()
                try:
                    trackData = track['track']

                    audioFeatures = sp.audio_features(tracks=[trackData['id']])

                    trackDict['title'] = trackData['name']
                    trackDict['artist'] = trackData['artists'][0]['name']

                    artistID = trackData['artists'][0]['id']

                    artistInfo = sp.artist(artistID)

                    genres = artistInfo['genres']

                    trackDict['genre'] = genre
                    trackDict['imageURL'] = trackData['album']['images'][1]['url']
                    trackDict['trackID'] = trackData['id']
                    trackDict['features'] = audioFeatures

                    results.append(trackDict)
                except:
                    continue

        resultDict[genre] = results

        print('downloading images for', genre)
        for track in results:
            try:
                imageURL = track['imageURL']
                title = track['title'].lower()
                artist = track['artist'].lower()
                genre = track['genre'].lower()
                urllib.request.urlretrieve(
                    imageURL, 'covers/'+genre+'/'+artist+' - '+title+'.jpg'
                )
            except:
                continue

    output = open('dataByCategory.json', 'w')

    pprint.pprint(resultDict, output)

if __name__=='__main__':
    main()
