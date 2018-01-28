import KKBOXOpenAPISwift
import Foundation

internal class Renderer {
	enum OutputType {
		case error
		case standard
	}

	static func writeMessage(_ message: String, to: OutputType = .standard) {
		switch to {
		case .standard:
			print("\(message)")
		case .error:
			fputs("\u{001B}[0;31mError:\u{001B}[;m \(message)\n", stderr)
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
URL		\(track.url?.absoluteString ?? "N/A")
Durtation	\(track.duration)
Album ID	\(track.album?.ID ?? "N/A")
Album Name	\(track.album?.name ?? "N/A")
Album URL	\(track.album?.url?.absoluteString ?? "N/A")
Album Images	\(String(describing: track.album?.images))
Artist ID	\(track.album?.artist?.ID ?? "N/A")
Artist Name	\(track.album?.artist?.name ?? "N/A")
Artist URL	\(track.album?.artist?.url?.absoluteString ?? "N/A")
Artist Images	\(String(describing: track.album?.artist?.images))
Order Index	\(track.trackOrderInAlbum)
"""
		self.writeMessage(message)
	}

	static func render(album: KKAlbumInfo) {
		let message = """
Album ID	\(album.ID)
Album Name	\(album.name)
Album URL	\(album.url?.absoluteString ?? "N/A")
Album Images	\(album.images)
Released At	\(album.releaseDate ?? "N/A ")
Artist ID	\(album.artist?.ID ?? "N/A")
Artist Name	\(album.artist?.name ?? "N/A")
Artist URL	\(album.artist?.url?.absoluteString ?? "N/A")
Artist Images	\(String(describing: album.artist?.images))
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
	album (ALBUM_ID)	Fetch an album.
	version			Print version of the tool.
"""
		writeMessage(help)
	}
}
