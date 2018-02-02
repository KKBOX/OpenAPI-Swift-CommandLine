import KKBOXOpenAPISwift
import Foundation

private class CommandLineToolFetcher {
	static let shared = CommandLineToolFetcher()
	let API = KKBOXOpenAPI(clientID: "5fd35360d795498b6ac424fc9cb38fe7", secret: "8bb68d0d1c2b483794ee1a978c9d0b5d")

	func fetchToken() -> Bool {
		var hasAccessToken = false
		var runloopRunning = true
		let task = try? API.fetchAccessTokenByClientCredential { result in
			switch result {
			case .error(_):
				hasAccessToken = false
			case .success(_):
				hasAccessToken = true
			}
			runloopRunning = false
		}
		if task != nil && runloopRunning {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
		}
		return hasAccessToken
	}

	func fetchFeaturedPlaylist() {
		var runloopRunning = true
		let task = try? API.fetchFeaturedPlaylists { result in
			switch result {
			case .error(let error):
				Renderer.render(error: error)
			case .success(let playlistList):
				Renderer.render(playlistList: playlistList)
			}
			runloopRunning = false
		}
		if task != nil && runloopRunning {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
		}
	}

	func fetchFeaturedPlaylistCategories() {
		var runloopRunning = true
		let task = try? API.fetchFeaturedPlaylistCategories { result in
			switch result {
			case .error(let error):
				Renderer.render(error: error)
			case .success(let categories):
				Renderer.render(featuredPlaylistCategories: categories)
			}
			runloopRunning = false
		}
		if task != nil && runloopRunning {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
		}
	}

	func fetchFeaturedPlaylist(inCategory category:String) {
		var runloopRunning = true
		let task = try? API.fetchFeaturedPlaylist(inCategory: category) { result in
			switch result {
			case .error(let error):
				Renderer.render(error: error)
			case .success(let category):
				Renderer.render(featuredPlaylistCategory: category)
			}
			runloopRunning = false
		}
		if task != nil && runloopRunning {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
		}
	}

	func fetch(track ID: String) {
		var runloopRunning = true
		let task = try? API.fetch(track: ID) { result in
			switch result {
			case .error(let error):
				Renderer.render(error: error)
			case .success(let track):
				Renderer.render(track: track)
			}
			runloopRunning = false
		}
		if task != nil && runloopRunning {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
		}
	}

	func fetch(album ID: String) {
		var runloopRunning = true
		var hasError = false
		var task = try? API.fetch(album: ID) { result in
			switch result {
			case .error(let error):
				Renderer.render(error: error)
				hasError = true
			case .success(let album):
				Renderer.render(album: album)
			}
			runloopRunning = false
		}
		if task != nil && runloopRunning {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
		}
		if hasError {
			return
		}
		runloopRunning = true
		task = try? API.fetch(tracksInAlbum: ID) { result in
			switch result {
			case .error(let error):
				Renderer.render(error: error)
				hasError = true
			case .success(let tracks):
				Renderer.render(tracks: tracks)
			}
			runloopRunning = false
		}
		if task != nil && runloopRunning {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
		}
	}

	func fetch(artist ID: String) {
		var runloopRunning = true
		let task = try? API.fetch(artist: ID) { result in
			switch result {
			case .error(let error):
				Renderer.render(error: error)
			case .success(let artist):
				Renderer.render(artist: artist)
			}
			runloopRunning = false
		}
		if task != nil && runloopRunning {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
		}
	}

	func fetch(artistAlbum ID: String) {
		var runloopRunning = true
		let task = try? API.fetch(albumsBelongToArtist: ID) { result in
			switch result {
			case .error(let error):
				Renderer.render(error: error)
			case .success(let albums):
				Renderer.render(albums: albums)
			}
			runloopRunning = false
		}
		if task != nil && runloopRunning {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
		}
	}

	func fetch(playlist ID: String) {
		var runloopRunning = true
		var hasError = false
		var task = try? API.fetch(playlist: ID) { result in
			switch result {
			case .error(let error):
				Renderer.render(error: error)
				hasError = true
			case .success(let playlist):
				Renderer.render(playlist: playlist)
			}
			runloopRunning = false
		}
		if task != nil && runloopRunning {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
		}
		if hasError {
			return
		}
		runloopRunning = true
		task = try? API.fetch(tracksInPlaylist: ID) { result in
			switch result {
			case .error(let error):
				Renderer.render(error: error)
			case .success(let tracks):
				Renderer.render(tracks: tracks)
			}
			runloopRunning = false
		}
		if task != nil && runloopRunning {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
		}
	}
}

enum Commands: String {
	case featuredPlaylists = "featured_playlists"
	case featuredPlaylistCategories = "featured_playlists_categories"
	case featuredPlaylistCategory = "featured_playlists_category"
	case track = "track"
	case album = "album"
	case artist = "artist"
	case artistAlbums = "artist_albums"
	case playlist = "playlist"
	case version = "version"

	var requireAccessToken: Bool {
		if self == .version {
			return false
		}
		return true
	}
}

public final class CommandLineTool {
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

		if command.requireAccessToken {
			if CommandLineToolFetcher.shared.fetchToken() == false {
				Renderer.writeMessage("Failed to fetch an access token.", to: .error)
				return
			}
		}

		switch command {
		case .featuredPlaylists:
			CommandLineToolFetcher.shared.fetchFeaturedPlaylist()
		case .featuredPlaylistCategories:
			CommandLineToolFetcher.shared.fetchFeaturedPlaylistCategories()
		case .featuredPlaylistCategory:
			if self.arguments.count <= 2 {
				Renderer.writeMessage("No category ID specified.", to: .error)
			} else {
				CommandLineToolFetcher.shared.fetchFeaturedPlaylist(inCategory: self.arguments[2])
			}
		case .track:
			if self.arguments.count <= 2 {
				Renderer.writeMessage("No track ID specified.", to: .error)
			} else {
				CommandLineToolFetcher.shared.fetch(track: self.arguments[2])
			}
		case .album:
			if self.arguments.count <= 2 {
				Renderer.writeMessage("No album ID specified.", to: .error)
			} else {
				CommandLineToolFetcher.shared.fetch(album: self.arguments[2])
			}
		case .artist:
			if self.arguments.count <= 2 {
				Renderer.writeMessage("No artist ID specified.", to: .error)
			} else {
				CommandLineToolFetcher.shared.fetch(artist: self.arguments[2])
			}
		case .artistAlbums:
			if self.arguments.count <= 2 {
				Renderer.writeMessage("No artist ID specified.", to: .error)
			} else {
				CommandLineToolFetcher.shared.fetch(artistAlbum: self.arguments[2])
			}
		case .playlist:
			if self.arguments.count <= 2 {
				Renderer.writeMessage("No playlist ID specified.", to: .error)
			} else {
				CommandLineToolFetcher.shared.fetch(playlist: self.arguments[2])
			}
		case .version:
			Renderer.writeMessage("kkbox 0.0.1")
		default:
			break

		}

	}
}
