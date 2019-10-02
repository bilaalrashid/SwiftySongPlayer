//
//  Song.swift
//  SwiftySongPlayer
//
//  Created by Bilaal Rashid on 04/07/2019.
//  Copyright © 2019 Bilaal Rashid. All rights reserved.
//

import Foundation
import MediaPlayer

/// Song for use with `SwiftySongPlayer`
struct Song: Equatable {
	
	//
	// MARK: - Properties
	//
	
	/// Song display name
	private(set) var name: String? = nil
	
	/// Artist name
	private(set) var artist: String? = nil
	
	/// Album name
	private(set) var album: String? = nil
	
	/// Album artwork for song
	private(set) var artwork: MPMediaItemArtwork? = nil
	
	/// Audio file URL
	private(set) var url: URL
	
	/// Audio settings
	private(set) var settings: SongSettings
	
	//
	// MARK: - Constructors
	//
	
	/// Creates a new `Song`
	/// - Parameters:
	/// 	- name: Song display name
	/// 	- artist: Artist name
	/// 	- album: Album name
	/// 	- artwork: Apple Music album artwork
	/// 	- url: Audio file URL
	init(name: String?, artist: String?, album: String?, artwork: MPMediaItemArtwork?, url: URL, settings: SongSettings = SongSettings()) {
		self.name = name
		self.artist = artist
		self.album = album
		self.artwork = artwork
		self.url = url
		self.settings = settings
	}
	
	/// Creates a new `Song`
	/// - Parameters:
	/// 	- name: Song display name
	/// 	- artist: Artist name
	/// 	- album: Album name
	/// 	- image: Album artwork image
	/// 	- url: Audio file URL
	init(name: String?, artist: String?, album: String?, image: UIImage?, url: URL, settings: SongSettings = SongSettings()) {
		self.name = name
		self.artist = artist
		self.album = album
		if image == nil {
			self.artwork = nil
		} else {
			self.artwork = MPMediaItemArtwork.init(boundsSize: image!.size, requestHandler: { (size) -> UIImage in
				return image!
			})
		}
		self.url = url
		self.settings = settings
	}
	
	/// Creates a new `Song`
	/// - Parameters:
	/// 	- name: Song display name
	/// 	- artist: Artist name
	/// 	- album: Album name
	/// 	- artwork: Apple Music album artwork
	/// 	- fileName: Locally bundled audio file name
	/// 	- fileExt: Locally bundled audio file extension
	init(name: String?, artist: String?, album: String?, artwork: MPMediaItemArtwork?, fileName: String, fileExt: String, settings: SongSettings = SongSettings()) {
		self.name = name
		self.artist = artist
		self.album = album
		self.artwork = artwork
		self.url = URL.init(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: fileExt)!)
		self.settings = settings
	}
	
	/// Creates a new `Song`
	/// - Parameters:
	/// 	- name: Song display name
	/// 	- artist: Artist name
	/// 	- album: Album name
	/// 	- image: Album artwork image
	/// 	- fileName: Locally bundled audio file name
	/// 	- fileExt: Locally bundled audio file extension
	init(name: String?, artist: String?, album: String?, image: UIImage?, fileName: String, fileExt: String, settings: SongSettings = SongSettings()) {
		self.name = name
		self.artist = artist
		self.album = album
		if image == nil {
			self.artwork = nil
		} else {
			self.artwork = MPMediaItemArtwork.init(boundsSize: image!.size, requestHandler: { (size) -> UIImage in
				return image!
			})
		}
		self.url = URL.init(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: fileExt)!)
		self.settings = settings
	}
}
