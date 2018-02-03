# KKBOX Open API Swift Command Line Tool

Access KKBOX's Open API using a command line tool with the Swift SDK.

## Introduction

The project turns [KKBOX Open API Swift SDK](https://github.com/KKBOX/OpenAPI-Swift) into a commadn line tool. You can use the tool to fetch data of KKBOX's playlists, charts, albums and so on. The project demontrates how to use the Swift SDK as well.

## Requirement

- Swift 4.0
- Xcode 9.2
- macOS 10.12 Sierra or above.

The command line tool currently runs on macOS only. You can run Swift code on Linux, but KKBOX's Swift SDK uses NSURLSession, which is not ported to Linux yet, for fetching data on the Internet.

## Installation

What you need to do is to checkout the project, change to the folder where the project is located at, and input

    make

The command "kkbox" will be installed to /usr/local/bin

## Usage

### Set-up Client ID and Secret

To use the tool, you need a client ID and secret at first. You can register a new app and obtain its client ID and secret on KKBOX's [developer site](https://developer.kkbox.com).

Then, set the client ID and secret by calling

    kkbox set_client_id (CLIENT_ID) (SECRET)

### Commands

The tool supports following copmmands

* `set_client_id (ID) (SECRET)` - Set client ID and secret.
* `get_client_id (ID) (SECRET)` - Get client ID and secret.
* `featured_playlists` - Fetch features playlists.
* `featured_playlists_categories` - Fetch features playlist categories.
* `featured_playlists_category (ID)` - Fetch playlists in a category.
* `new_hits_playlists` - Fetch new hits playlists.
* `charts` - Fetch charts.
* `track (TRACK_ID)` - Fetch a track.
* `album (ALBUM_ID)` - Fetch an album.
* `artist (ARTIST_ID)` - Fetch an artist.
* `artist_albums (ARTIST_ID)` - Fetch albums of an artist.
* `playlist (PLAYLSIT_ID)` - Fetch a playlist.
* `mood_stations` - Fetch mood stations.
* `mood_station (STATION_ID)` - Fetch a mood station.
* `genre_stations` - Fetch genre stations.
* `grene_station (STATION_ID)` - Fetch a genre station.
* `new_release_categories`- Fetch new released album categories.
* `new_release_category (ID)` - Fetch albums in a new released album category
* `search_track (KEYWORD)` - Search for tracks.
* `search_album (KEYWORD)` - Search for albums.
* `search_artist (KEYWORD)` - Search for artists.
* `search_playlist (KEYWORD)` - Search for playlists.

