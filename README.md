# KKBOX Open API Swift Command Line Tool


[![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)&nbsp;
[![License Apache](https://img.shields.io/badge/license-Apache-green.svg?style=flat)](https://raw.githubusercontent.com/KKBOX/OpenAPI-Swift/master/LICENSE)&nbsp;
[![Git Version](https://img.shields.io/github/release/KKBOX/OpenAPI-Swift-CommandLine.svg)](https://github.com/KKBOX/OpenAPI-Swift-CommandLine/releases)&nbsp;
[![Build Status](https://travis-ci.org/KKBOX/OpenAPI-Swift-CommandLine.svg?branch=master)](https://travis-ci.org/KKBOX/OpenAPI-Swift-CommandLine)

Access KKBOX's Open API using a command line tool with the Swift SDK.

## Introduction

The project turns [KKBOX Open API Swift SDK](https://github.com/KKBOX/OpenAPI-Swift) into a command line tool. You can use the tool to fetch data of KKBOX's playlists, charts, albums and so on. The project demonstrates how to use the Swift SDK as well.

## Requirement

- Swift 4.0
- Xcode 9.2
- macOS 10.12 Sierra or above.

The command line tool currently runs on macOS only. You can run Swift code on Linux, but KKBOX's Swift SDK uses NSURLSession, which is not ported to Linux yet, for fetching data on the Internet.

## Installation

### Using Mint

You can run the tool by using [Mint](https://github.com/yonaskolb/mint)

    $ mint run KKBOX/OpenAPI-Swift-CommandLine kkbox

### From Source Code

What you need to do is to checkout the project, change to the folder where the project is located at, and input

    $ make

The command "kkbox" will be installed to /usr/local/bin

## Usage

### Set-up Client ID and Secret

To use the tool, you need a client ID and secret at first. You can register a new app and obtain its client ID and secret on KKBOX's [developer site](https://developer.kkbox.com).

Then, set the client ID and secret by calling

    kkbox set_client_id (CLIENT_ID) (SECRET)

### Commands

The tool supports following commands

- `set_client_id (ID) (SECRET)` - Set client ID and secret.
- `get_client_id (ID) (SECRET)` - Get client ID and secret.
- `featured_playlists` - Fetch features playlists.
- `featured_playlists_categories` - Fetch features playlist categories.
- `featured_playlists_category (ID)` - Fetch playlists in a category.
- `new_hits_playlists` - Fetch new hits playlists.
- `charts` - Fetch charts.
- `track (TRACK_ID)` - Fetch a track.
- `album (ALBUM_ID)` - Fetch an album.
- `artist (ARTIST_ID)` - Fetch an artist.
- `artist_albums (ARTIST_ID)` - Fetch albums of an artist.
- `playlist (PLAYLIST_ID)` - Fetch a playlist.
- `mood_stations` - Fetch mood stations.
- `mood_station (STATION_ID)` - Fetch a mood station.
- `genre_stations` - Fetch genre stations.
- `genre_station (STATION_ID)` - Fetch a genre station.
- `new_release_categories`- Fetch new released album categories.
- `new_release_category (ID)` - Fetch albums in a new released album category
- `search_track (KEYWORD)` - Search for tracks.
- `search_album (KEYWORD)` - Search for albums.
- `search_artist (KEYWORD)` - Search for artists.
- `search_playlist (KEYWORD)` - Search for playlists.

## License

Copyright 2018 KKBOX Technologies Limited

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
