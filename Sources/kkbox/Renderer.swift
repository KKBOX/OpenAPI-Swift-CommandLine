import KKBOXOpenAPISwift
import Foundation

internal class Renderer {
	enum OutputType {
		case error
		case standard
	}

	static func write(message: String, to: OutputType = .standard) {
		switch to {
		case .standard:
			print("\(message)")
		case .error:
			fputs("\u{001B}[0;31mError:\u{001B}[;m \(message)\n", stderr)
		}
	}

	static func render(error: Error) {
		self.write(message: error.localizedDescription, to: .error)
	}

	static func render(paging: KKPagingInfo) {
		let message = "------------------------------------------------------------\n" +
				"offset:\(paging.offset) limit:\(paging.limit) previous:\(String(describing: paging.previous)) next:\(String(describing: paging.next))"
		self.write(message: message)
	}

	static func render(summary: KKSummary) {
		let message = "total: \(summary.total)"
		self.write(message: message)
	}

	static func render(playlistList: KKPlaylistList) {
		for playlist in playlistList.playlists {
			self.render(playlist: playlist)
			self.write(message: "")
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
		self.write(message: message)
	}

	static func render(tracks: KKTrackList) {
		self.write(message: "\n")
		for track in tracks.tracks {
			self.render(track: track)
			self.write(message: "\n")
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
		self.write(message: message)
	}

	static func render(albums: KKAlbumList) {
		self.write(message: "\n")
		for album in albums.albums {
			self.render(album: album)
			self.write(message: "\n")
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
		self.write(message: message)
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
		self.write(message: message)
	}

	static func render(featuredPlaylistCategories :KKFeaturedPlaylistCategoryList) {
		for category in featuredPlaylistCategories.categories {
			let message = "\(category.ID) \(category.title)"
			self.write(message: message)
		}
		self.render(paging: featuredPlaylistCategories.paging)
		self.render(summary: featuredPlaylistCategories.summary)
	}

	static func render(featuredPlaylistCategory :KKFeaturedPlaylistCategory) {
		self.write(message: featuredPlaylistCategory.ID)
		self.write(message: featuredPlaylistCategory.title)
		self.write(message: "\(featuredPlaylistCategory.images)")

		guard let playlists = featuredPlaylistCategory.playlists else {
			return
		}
		for playlist in playlists.playlists {
			self.render(playlist: playlist)
			self.write(message: "")
		}
		self.render(paging: playlists.paging)
		self.render(summary: playlists.summary)
	}

	static func renderHelp() {
		let help = """
Usage:

	$ kkbox COMMAND

	A commandline tool to access KKBOX's Open API.

Commands:

	set_client_id (ID) (SECRET)		Set client ID and secret.
	get_client_id (ID) (SECRET)		Get client ID and secret.
	featured_playlists			Fetch features playlists.
	featured_playlists_categories		Fetch features playlist categories.
	featured_playlists_category (ID)	Fetch playlists in a category.
	track (TRACK_ID)			Fetch a track.
	album (ALBUM_ID)			Fetch an album.
	artist (ARTIST_ID)			Fetch an artist.
	artist_albums (ARTIST_ID)		Fetch albums of an artist.
	playlist (PLAYLSIT_ID)			Fetch a playlist.
	version					Print version of the tool.
	help					This help.
"""
		write(message: help)
	}
}
