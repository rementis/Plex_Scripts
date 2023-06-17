#!/usr/bin/env python
# Be sure to pip install plexapi
import os 
import sys
import plexapi

from plexapi.server import PlexServer
baseurl = 'http://192.168.2.5:32400'
token = '<YOUR PLEX TOKEN>'
plex = PlexServer(baseurl, token)
library = plex.library.section("Movies")
video = library.get(title="<MOVIE NAME")
updates = {"addedAt.value": "2018-08-21 11:19:43"}

video.edit(**updates)
