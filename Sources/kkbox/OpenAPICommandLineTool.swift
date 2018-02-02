import Foundation

let clientIDKey = "clientID"
let clientSecretKey = "clientSecret"

private enum Commands: String {
	case setClientID = "set_client_id"
	case getClientID = "get_client_id"
	case featuredPlaylists = "featured_playlists"
	case featuredPlaylistCategories = "featured_playlists_categories"
	case featuredPlaylistCategory = "featured_playlists_category"
	case newHitsPlaylists = "new_hits_playlists"
	case charts = "charts"
	case track = "track"
	case album = "album"
	case artist = "artist"
	case artistAlbums = "artist_albums"
	case playlist = "playlist"
	case moodStations = "mood_stations"
	case moodStation = "mood_station"
	case genreStations = "genre_stations"
	case genreStation = "genre_station"
	case newReleaseCategories = "new_release_categories"
	case newReleaseCategory = "new_release_category"
	case searchTrack = "search_track"
	case searchAlbum = "search_album"
	case searchArtist = "search_artist"
	case searchPlaylist = "search_playlist"
	case version = "version"
	case help = "help"

	/// If the command requries an access token.
	var requireAccessToken: Bool {
		switch self {
		case .setClientID, .getClientID, .version, .help:
			return false
		default:
			return true
		}
	}
}

enum OpenAPICommandLineError: Error {
	case noClientID
	case clientIDFormatInvalid
	case failedToFetchAccessToken
	case noCategoryID
	case noTrackID
	case noArtistID
	case noAlbumID
	case noPlaylistID
	case noStationID
	case noKeyword

	var localizedDescription: String {
		switch self {
		case .noClientID:
			return "You did not input your client ID yet. Please input your client ID and secret by: kkbox set_client_id <client_id> <secret>"
		case .clientIDFormatInvalid:
			return "Please input your client ID and secret by: kkbox set_client_id <client_id> <secret>."
		case .failedToFetchAccessToken:
			return "Failed to fetch an access token."
		case .noCategoryID:
			return "No category ID specified."
		case .noTrackID:
			return "No track ID specified."
		case .noArtistID:
			return "No artist ID specified."
		case .noAlbumID:
			return "No album ID specified."
		case .noPlaylistID:
			return "No playlist ID specified."
		case .noStationID:
			return "No station ID specified."
		case .noKeyword:
			return "No keyword specified."
		}
	}
}

public final class OpenAPICommandLineTool {
	private let arguments: [String]

	public init(arguments: [String] = CommandLine.arguments) {
		self.arguments = arguments
	}

	public func run() throws {
		if self.arguments.count <= 1 {
			Renderer.renderHelp()
			return
		}

		guard let command = Commands(rawValue: self.arguments[1]) else {
			Renderer.renderHelp()
			return
		}

		let fetcher = CommandLineToolFetcher.shared

		if command.requireAccessToken {
			if fetcher.API == nil {
				throw OpenAPICommandLineError.noClientID
			}
			if fetcher.fetchToken() == false {
				throw OpenAPICommandLineError.failedToFetchAccessToken
			}
		}

		func requestParameter(for commandOperation: (String) -> (), error: OpenAPICommandLineError) throws {
			if self.arguments.count <= 2 {
				throw error
			} else {
				commandOperation(self.arguments[2])
			}
		}

		switch command {
		case .featuredPlaylists:
			fetcher.fetchFeaturedPlaylist()
		case .featuredPlaylistCategories:
			fetcher.fetchFeaturedPlaylistCategories()
		case .featuredPlaylistCategory:
			try requestParameter(for: {
				fetcher.fetchFeaturedPlaylist(inCategory: $0)
			}, error: .noCategoryID)
		case .newHitsPlaylists:
			fetcher.fetchNewHitsPlaylists()
		case .charts:
			fetcher.fetchCharts()
		case .track:
			try requestParameter(for: {
				fetcher.fetch(track: $0)
			}, error: .noTrackID)
		case .album:
			try requestParameter(for: {
				fetcher.fetch(album: $0)
			}, error: .noAlbumID)
		case .artist:
			try requestParameter(for: {
				fetcher.fetch(artist: $0)
			}, error: .noArtistID)
		case .artistAlbums:
			try requestParameter(for: {
				fetcher.fetch(artistAlbum: $0)
			}, error: .noArtistID)
		case .playlist:
			try requestParameter(for: {
				fetcher.fetch(playlist: $0)
			}, error: .noPlaylistID)
		case .moodStations:
			fetcher.fetchMoodStations()
		case .moodStation:
			try requestParameter(for: {
				fetcher.fetch(moodStation: $0)
			}, error: .noStationID)
		case .genreStations:
			fetcher.fetchGenreStations()
		case .genreStation:
			try requestParameter(for: {
				fetcher.fetch(genreStation: $0)
			}, error: .noStationID)
		case .newReleaseCategories:
			fetcher.fetchNewReleaseCategories()
		case .newReleaseCategory:
			try requestParameter(for: {
				fetcher.fetch(newReleaseCategory: $0)
			}, error: .noCategoryID)
		case .setClientID:
			if self.arguments.count < 4 {
				throw OpenAPICommandLineError.clientIDFormatInvalid
			}
			let clientID = self.arguments[2]
			let clientSecret = self.arguments[3]
			UserDefaults.standard.set(clientID, forKey: clientIDKey)
			UserDefaults.standard.set(clientSecret, forKey: clientSecretKey)
		case .searchTrack:
			try requestParameter(for: {
				fetcher.searchTrack(keyword: $0)
			}, error: .noKeyword)
		case .searchAlbum:
			try requestParameter(for: {
				fetcher.searchAlbum(keyword: $0)
			}, error: .noKeyword)
		case .searchArtist:
			try requestParameter(for: {
				fetcher.searchArtist(keyword: $0)
			}, error: .noKeyword)
		case .searchPlaylist:
			try requestParameter(for: {
				fetcher.searchPlaylist(keyword: $0)
			}, error: .noKeyword)
		case .getClientID:
			guard let clientID = UserDefaults.standard.string(forKey: clientIDKey),
			      let clientSecret = UserDefaults.standard.string(forKey: clientSecretKey) else {
				throw OpenAPICommandLineError.noClientID
			}
			Renderer.write(message: "Client ID: \(clientID)")
			Renderer.write(message: "Client Secret: \(clientSecret)")
		case .version:
			Renderer.write(message: "kkbox 0.0.1")
		case .help:
			Renderer.renderHelp()
		}
	}
}
