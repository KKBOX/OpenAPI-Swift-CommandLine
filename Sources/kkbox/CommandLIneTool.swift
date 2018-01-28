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

	func fetch(track ID: String) {
		var runloopRunning = true
		let task = try? API.fetch(track: ID) { result in
			switch result {
			case .error(let error):
				Renderer.render(error: error)
			case .success(let track):
				Renderer.render(track: track)
				break
			}
			runloopRunning = false
		}
		if task != nil && runloopRunning {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
		}
	}

	func fetch(album ID: String) {
		var runloopRunning = true
		let task = try? API.fetch(album: ID) { result in
			switch result {
			case .error(let error):
				Renderer.render(error: error)
			case .success(let track):
				Renderer.render(album: track)
				break
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
	case track = "track"
	case album = "album"
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
		case .version:
			Renderer.writeMessage("kkbox 0.0.1")
		default:
			break
		}
	}
}
