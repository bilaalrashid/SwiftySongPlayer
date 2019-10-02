//
//  SongPlayer.swift
//  SwiftySongPlayer
//
//  Created by Bilaal Rashid on 02/07/2019.
//  Copyright © 2019 Bilaal Rashid. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

/// Interface for playing a single audio file
class SongPlayer {
	
	// MARK: - Properties
	
	/// System audio player
	private var songPlayer = AVAudioPlayer()
	
	/// Tracks when the loaded song has been paused
	private var isSongPaused = false
	
	/// Tracks if a song has ever been played
	private var hasBeenPlayed = false
	
	/// Currently loaded song to play
	private var currentSong: Song?
	
	// MARK: - Public methods
	
	/// Loads a new song into the `AudioPlayer`
	/// - Parameters:
	///		- song: The song to be loaded
	///		- mode: Playback mode for the song
	///		- sender: Sender class for `AVAudioPlayerDelegate` to be assigned to
	public func loadSong(song: Song, mode: PlaybackMode, sender: AVAudioPlayerDelegate) throws {
		self.currentSong = song
		self.songPlayer = try AVAudioPlayer(contentsOf: song.url)
		self.songPlayer.prepareToPlay()
		
		// Used for firing audioPlayerDidFinishPlaying() when audio is finished playing
		self.songPlayer.delegate = sender
		
		try configurePlaybackMode(mode: mode)
	}
	
	/// Plays the currently loaded song
	public func playSong() {
		self.songPlayer.play()
		self.hasBeenPlayed = true
		updateNowPlayingInfo()
	}
	
	/// Pauses the currently playing song
	public func pauseSong() {
		if isPlaying() {
			self.songPlayer.pause()
			self.isSongPaused = true
		} else {
			self.isSongPaused = false
		}
		updateNowPlayingInfo()
	}
	
	/// Replays the currently playing song from the begining
	public func replaySong() {
		if isPlaying() || self.isSongPaused {
			self.songPlayer.stop()
			self.songPlayer.currentTime = 0
			self.songPlayer.play()
		} else  {
			self.songPlayer.play()
		}
		updateNowPlayingInfo()
	}
	
	/// Stops playing the currently playing song
	public func stopSong() {
		if isPlaying() {
			self.songPlayer.stop()
		}
		updateNowPlayingInfo()
	}
	
	/// Fast forrwards the currently playing song
	/// - Parameter increment: Number of seconds to fast forward by
	public func fastForwardSong(by increment: Double) {
		self.songPlayer.currentTime += increment
		updateNowPlayingInfo()
	}
	
	/// Rewinds the currently playing song
	/// - Parameter increment: Number of seconds to rewind by
	public func rewindSong(by increment: Double) {
		self.songPlayer.currentTime -= increment
		updateNowPlayingInfo()
	}
	
	/// Skips to a position in the currently playing song
	/// - Parameter time: Number of seconds from start of song
	public func seekTo(position time: Double) {
		self.songPlayer.currentTime = time
		updateNowPlayingInfo()
	}
	
	/// Gets if the loaded song is playing
	/// - Returns: Playing status
	public func isPlaying() -> Bool {
		// `self.songPlayer.isPlaying` crashes if a song has never been played
		return self.hasBeenPlayed && self.songPlayer.isPlaying
	}
	
	/// Gets the playback position of the song
	/// - Returns: The playback position of the song
	public func getPlaybackPosition() -> Double {
		// `self.songPlayer.currentTime` crashes if a song has never been played
		return self.hasBeenPlayed ? self.songPlayer.currentTime : 0.0
	}
	
	/// Updates the OS now playing song information
	public func updateNowPlayingInfo() {
		if let song = self.currentSong {
			// Define now playing info
			var nowPlayingInfo = [String: Any]()
			
			if let name = song.name {
				nowPlayingInfo[MPMediaItemPropertyTitle] = name
			}
			
			if let artwork = song.artwork {
				nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
			}
			
			if let artist = song.artist {
				nowPlayingInfo[MPMediaItemPropertyArtist] = artist
			}
			
			if let album = song.album {
				nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = album
			}
			
			nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.songPlayer.currentTime
			nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.songPlayer.duration
			
			if isPlaying() {
				nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.songPlayer.rate
			} else {
				nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0
			}
			
			// Send metadata to system
			MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
		}
	}
	
	// MARK: - Private methods
	
	/// Configures the playback mode for the song
	/// - Parameter mode: Playback mode for the song
	private func configurePlaybackMode(mode: PlaybackMode) throws {
		let audioSession = AVAudioSession.sharedInstance()
		
		switch mode {
		case .earspeaker:
			try audioSession.setCategory(.playAndRecord, mode: .default)
			try audioSession.overrideOutputAudioPort(.none)
			try audioSession.setActive(true)
		case .loudspeaker:
			try audioSession.setCategory(.playAndRecord, mode: .default)
			try audioSession.overrideOutputAudioPort(.speaker)
			try audioSession.setActive(true)
		default:
			try audioSession.setCategory(.playback, mode: .default)
		}
	}
	
}
