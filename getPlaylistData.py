import sys
import spotipy
import json
import pprint
import requests

'''
In order to use this file, provide the following in credentials.json:

{
    "user" : <user : string>, 
    "userID" : <userID : int>,
    "token" : <token : string>
}

'''

def main():
    f = open("./credentials.json")
    obj = json.load(f)

    token = obj['token']
    userID = obj['userID']

    sp = spotipy.Spotify(auth=token)
    topPlaylists = sp.category_playlists(category_id='toplists', country='us')
    
    resultDict = dict()
    results = list()
    for playlist in topPlaylists['playlists']['items']:
        id = playlist['id']

        getReq = 'https://api.spotify.com/v1/playlists/' + id

        r = requests.get(url=getReq, 
                        headers={
                            'Authorization': 'Bearer ' + token
                        }
                    )

        tracks = r.json()['tracks']['items']

        for track in tracks:
            trackDict = dict()
            trackData = track['track']
            
            audioFeatures = sp.audio_features(tracks=[trackData['id']])
            
            trackDict['title'] = trackData['name']
            trackDict['artist'] = trackData['artists'][0]['name']

            artistID = trackData['artists'][0]['id']

            artistInfo = sp.artist(artistID)
            genres = artistInfo['genres']

            trackDict['genres'] = genres
            trackDict['imageURL'] = trackData['album']['images'][1]['url']
            trackDict['trackID'] = trackData['id']
            trackDict['features'] = audioFeatures

            results.append(trackDict)

    resultDict['results'] = results

    with open('result.json', 'w') as fp:
        json.dump(results, fp)

if __name__=='__main__':
    main()
