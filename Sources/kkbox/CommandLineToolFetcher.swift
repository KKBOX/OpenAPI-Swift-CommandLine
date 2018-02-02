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

	var runloopRunning = false
	var hasError = false

	func reset() {
		runloopRunning = true
		hasError = false
	}

	func run(_ fetchCommand: @autoclosure () throws -> URLSessionTask?) {
		reset()
		let task = try? fetchCommand()
		while task != nil && self.runloopRunning {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
		}
	}

	func callback<T>(successHandler: @escaping (T) -> ()) -> (KKAPIResult<T>) -> () {
		return { result in
			switch result {
			case .error(let error):
				self.hasError = true
				Renderer.render(error: error)
			case .success(let object):
				self.hasError = false
				successHandler(object)
			}
			self.runloopRunning = false
		}
	}

	func fetchToken() -> Bool {
		run(try API?.fetchAccessTokenByClientCredential(callback: callback { _ in }))
		return !hasError
	}

	func fetchFeaturedPlaylist() {
		run(try API?.fetchFeaturedPlaylists(callback: callback { Renderer.render(playlistList: $0) }))
	}

	func fetchFeaturedPlaylistCategories() {
		run(try API?.fetchFeaturedPlaylistCategories(callback: callback { Renderer.render(featuredPlaylistCategories: $0) }))
	}

	func fetchFeaturedPlaylist(inCategory category: String) {
		run(try API?.fetchFeaturedPlaylist(inCategory: category, callback: callback { Renderer.render(featuredPlaylistCategory: $0) }))
	}

	func fetchCharts() {
		run(try API?.fetchCharts(callback: callback { Renderer.render(playlistList: $0) }))
	}

	func fetch(track ID: String) {
		run(try API?.fetch(track: ID, callback: callback { Renderer.render(track: $0) }))
	}

	func fetch(album ID: String) {
		run(try API?.fetch(album: ID, callback: callback { Renderer.render(album: $0) }))
		if hasError { return }
		run(try API?.fetch(tracksInAlbum: ID, callback: callback { Renderer.render(tracks: $0) }))
	}

	func fetch(artist ID: String) {
		run(try API?.fetch(artist: ID, callback: callback { Renderer.render(artist: $0) }))
	}

	func fetch(artistAlbum ID: String) {
		run(try API?.fetch(albumsBelongToArtist: ID, callback: callback { Renderer.render(albums: $0) }))
	}

	func fetch(playlist ID: String) {
		run(try API?.fetch(playlist: ID, callback: callback { Renderer.render(playlist: $0) }))
		if hasError { return }
		run(try API?.fetch(tracksInPlaylist: ID, callback: callback { Renderer.render(tracks: $0) }))
	}

	func fetchMoodStations() {
		run(try API?.fetchMoodStations(callback: callback { Renderer.render(stations: $0) }))
	}

	func fetch(moodStation ID: String) {
		run(try API?.fetch(tracksInMoodStation: ID, callback: callback { Renderer.render(station: $0) }))
	}

	func fetchGenreStations() {
		run(try API?.fetchGenreStations(callback: callback { Renderer.render(stations: $0) }))
	}

	func fetch(genreStation ID: String) {
		run(try API?.fetch(tracksInGenreStation: ID, callback: callback { Renderer.render(station: $0) }))
	}

	func fetchNewReleaseCategories() {
		run(try API?.fetchNewReleaseAlbumsCategories(callback: callback { Renderer.render(newReleaseAlbumsCategories: $0) }))
	}

	func fetch(newReleaseCategory ID: String) {
		run(try API?.fetch(newReleasedAlbumsUnderCategory: ID, callback: callback { Renderer.render(newReleaseAlbumsCategory: $0) }))
	}

	func fetchNewHitsPlaylists() {
		run(try API?.fetchNewHitsPlaylists(callback: callback { Renderer.render(playlistList: $0) } ))
	}

	func searchTrack(keyword: String) {
		run(try API?.search(with: keyword, types: .track, callback: callback {
			if let tracks = $0.trackResults {
				Renderer.render(tracks: tracks)
			}
		}))
	}

	func searchAlbum(keyword: String) {
		run(try API?.search(with: keyword, types: .album, callback: callback {
			if let albums = $0.albumResults {
				Renderer.render(albums: albums)
			}
		}))
	}

	func searchArtist(keyword: String) {
		run(try API?.search(with: keyword, types: .artist, callback: callback {
			if let artists = $0.artistResults {
				Renderer.render(artists: artists)
			}
		}))
	}

	func searchPlaylist(keyword: String) {
		run(try API?.search(with: keyword, types: .playlist, callback: callback {
			if let playlists = $0.playlistsResults {
				Renderer.render(playlistList: playlists)
			}
		}))
	}

}
