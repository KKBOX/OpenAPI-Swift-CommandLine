import KKBOXOpenAPISwift
import Foundation

private class Renderer {
	enum OutputType {
		case error
		case standard
	}

	static func writeMessage(_ message: String, to: OutputType = .standard) {
		switch to {
		case .standard:
			print("\(message)")
		case .error:
			fputs("Error: \(message)\n", stderr)
		}
	}

	static func render(error: Error) {
		self.writeMessage(error.localizedDescription, to: .error)
	}

	static func render(playlistList: KKPlaylistList) {
		let message = "PLAYLIST ID".padding(toLength: 18, withPad: " ", startingAt: 0) + "\t" +
			"UPDATE AT".padding(toLength: 25, withPad: " ", startingAt: 0) + "\t" +
			"PLAYLIST NAME".padding(toLength: 30, withPad: " ", startingAt: 0)
			writeMessage(message)
		for playlist in playlistList.playlists {
			let message = playlist.ID.padding(toLength: 18, withPad: " ", startingAt: 0) + "\t" +
				"\(playlist.lastUpdateDate)".padding(toLength: 25, withPad: " ", startingAt: 0) + "\t" +
				playlist.title.padding(toLength: 30, withPad: " ", startingAt: 0)
			writeMessage(message)
		}
	}
}

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
}

enum Commands: String {
	case featuredPlaylists = "featured_playlists"
}

public final class CommandLineTool {
	private let arguments: [String]
	public init(arguments: [String] = CommandLine.arguments) {
		self.arguments = arguments
	}
	public func run() throws {
		if CommandLineToolFetcher.shared.fetchToken() {
			CommandLineToolFetcher.shared.fetchFeaturedPlaylist()
		}
	}
}
