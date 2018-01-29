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
		for playlist in playlistList.playlists {
			self.render(playlist: playlist)
			writeMessage("")
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

	static func render(tracks: KKTrackList) {
		self.writeMessage("\n")
		for track in tracks.tracks {
			self.render(track: track)
			self.writeMessage("\n")
		}
		self.render(paging: tracks.paging)
		self.render(summary: tracks.summary)
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

	static func render(albums: KKAlbumList) {
		self.writeMessage("\n")
		for album in albums.albums {
			self.render(album: album)
			self.writeMessage("\n")
		}
		self.render(paging: albums.paging)
		self.render(summary: albums.summary)
	}

	static func render(artist: KKArtistInfo) {
		let message = """
Artist ID	\(artist.ID)
Artist Name	\(artist.name)
Artist URL	\(artist.url?.absoluteString ?? "N/A")
Artist Images	\(String(describing: artist.images))
"""
		self.writeMessage(message)
	}

	static func render(playlist: KKPlaylistInfo) {
		let message = """
Playlist ID	\(playlist.ID)
Playlist Name	\(playlist.title)
Playlist URL	\(playlist.url?.absoluteString ?? "N/A")
Playlist Images	\(String(describing: playlist.images))
Updated at	\(playlist.lastUpdateDate)
Curator		\(playlist.owner.ID) \(playlist.owner.name)
"""
		self.writeMessage(message)
	}

	static func renderHelp() {
		let help = """
Usage:

	$ kkbox COMMAND

	A commandline tool to access KKBOX's Open API.

Commands:

	featured_playlists		Fetch features playlists.
	track (TRACK_ID)		Fetch a track.
	album (ALBUM_ID)		Fetch an album.
	artist (ARTIST_ID)		Fetch an artist.
	artist_albums (ARTIST_ID)	Fetch albums of an artist.
	playlist (PLAYLSIT_ID)		Fetch a playlist.
	version				Print version of the tool.
"""
		writeMessage(help)
	}
}
