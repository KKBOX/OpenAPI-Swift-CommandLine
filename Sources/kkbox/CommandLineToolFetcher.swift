import Foundation
import KKBOXOpenAPISwift

class CommandLineToolFetcher {
	static let shared = CommandLineToolFetcher()
	var API: KKBOXOpenAPI? = {
		guard let clientID = UserDefaults.standard.string(forKey: clientIDKey),
		      let clientSecret = UserDefaults.standard.string(forKey: clientSecretKey) else {
			return nil
		}
		return KKBOXOpenAPI(clientID: clientID, secret: clientSecret)
	}()

	func fetchToken() -> Bool {
		var hasAccessToken = false
		var runloopRunning = true
		let task = try? API?.fetchAccessTokenByClientCredential { result in
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
		let task = try? API?.fetchFeaturedPlaylists { result in
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
		let task = try? API?.fetchFeaturedPlaylistCategories { result in
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

	func fetchFeaturedPlaylist(inCategory category: String) {
		var runloopRunning = true
		let task = try? API?.fetchFeaturedPlaylist(inCategory: category) { result in
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
		let task = try? API?.fetch(track: ID) { result in
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
		var task = try? API?.fetch(album: ID) { result in
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
		task = try? API?.fetch(tracksInAlbum: ID) { result in
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
		let task = try? API?.fetch(artist: ID) { result in
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
		let task = try? API?.fetch(albumsBelongToArtist: ID) { result in
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
		var task = try? API?.fetch(playlist: ID) { result in
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
		task = try? API?.fetch(tracksInPlaylist: ID) { result in
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
