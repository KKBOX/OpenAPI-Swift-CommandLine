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


	static func render(paging: KKPagingInfo) {
		let message = "------------------------------------------------------------\n" +
		"offset:\(paging.offset) limit:\(paging.limit) previous:\(String(describing: paging.previous)) next:\(String(describing: paging.next))"
		self.writeMessage(message)
	}

	static func render(summary: KKSummary) {
		let message = "total: \(summary.total)"
		self.writeMessage(message)
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
		self.render(paging: playlistList.paging)
		self.render(summary: playlistList.summary)
	}

	static func render(track: KKTrackInfo) {
		let message = """
Track ID	\(track.ID)
Track Name	\(track.name)
URL			\(track.url?.absoluteString ?? "N/A")
Durtation	\(track.duration)
Album ID	\(track.album?.ID ?? "N/A")
Album Name	\(track.album?.name ?? "N/A")
Album ID	\(track.album?.ID ?? "N/A")
Artist ID	\(track.album?.artist?.ID ?? "N/A")
Artist Name	\(track.album?.artist?.name ?? "N/A")
Order Index	\(track.trackOrderInAlbum)
"""
		self.writeMessage(message)
	}

	static func renderHelp() {
		let help = """
Usage:

	$ kkbox COMMAND

	A commandline tool to access KKBOX's Open API.

Commands:

	featured_playlists	Fetch features playlists.
	track (TRACK_ID)	Fetch a track.
	version			Print version of the tool.
"""
		writeMessage(help)
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
}

enum Commands: String {
	case featuredPlaylists = "featured_playlists"
	case track = "track"
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

			}
		case .version:
			Renderer.writeMessage("kkbox 0.0.1")
		default:
			break
		}
	}
}
