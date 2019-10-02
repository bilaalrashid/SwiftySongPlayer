//
//  SwiftySongPlayer.swift
//  SwiftySongPlayer
//
//  Created by Bilaal Rashid on 05/07/2019.
//  Copyright © 2019 Bilaal Rashid. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

/// Interface for playing a queue of songs
/// - Note: Implemented as a singleton accesible from `SwiftySongPlayer.shared`
public class SwiftySongPlayer: NSObject, AVAudioPlayerDelegate {
	
	// MARK: - Properties
	
	/// Shared singleton instance
	static public let shared = SwiftySongPlayer()
	
	/// Single audio track player
	private let audioPlayer = SingleSongPlayer()
	
	/// List of all previously and soon to be played songs
	private var songQueue: Array<Song> = []
	
	/// Index of the current song in the `songQueue`
	private var currentSong = 0
	
	/// Settings for the Audio Player
	private var settings = PlayerSettings()
	
	/// Have the player controls already been setup
	private var hasBeenSetup = false
	
	// MARK: - Constructor
	
	/// Prevents an instance being created
	private override init() {}
	
	// MARK: - Public methods
	
	/// Creates a `SwiftySongPlayer` with optional settings
	/// - Parameter settings: Optional instance of `SwiftyPlayerSettings` to override default settings
	public func setup(settings: PlayerSettings = PlayerSettings()) {
		if !self.hasBeenSetup {
			self.settings = settings
			setupSystemAudioControls()
			self.hasBeenSetup = true
		}
	}
	
	/// Adds a song to the song queue
	/// - Parameter song: Song to add to the queue
	public func addSong(song: Song) {
		self.songQueue.append(song)
	}
	
	/// Starts playing the song queue
	/// - Note: To resume previously started playback, `resumeQueue()` should be used in favour
	public func playQueue() throws {
		if !self.songQueue.isEmpty {
			let song = getCurrentSong()
			try playSong(song: song)
		}
	}
	
	/// Pauses playback of the song queue
	public func pauseQueue() {
		self.audioPlayer.pauseSong()
	}
	
	/// Resumes playback of the song queue
	/// - Note: Should be used in favour of `playQueue()` when resuming playback
	public func resumeQueue() {
		self.audioPlayer.playSong()
	}
	
	/// Plays a lined up song in the song queue
	/// - Parameter amount: Number of songs to skip forwards
	public func skipForwardsInQueue(by amount: Int) throws {
		self.audioPlayer.stopSong()
		self.currentSong += amount
		
		if self.currentSong > (self.songQueue.count - 1) {
			self.currentSong = self.songQueue.count - 1
		}
		
		let song = getCurrentSong()
		try playSong(song: song)
	}
	
	/// Plays a previously played song in the song queue
	/// - Parameter amount: Number of songs to skip back
	public func skipBackwardsInQueue(by amount: Int) throws {
		self.audioPlayer.stopSong()
		self.currentSong -= amount
		
		if self.currentSong < 0 {
			currentSong = 0
		}
		
		let song = getCurrentSong()
		try playSong(song: song)
	}
	
	/// Fast forwards the currently playing song
	/// - Parameter amount: Number of seconds to fast forward
	public func fastFordwardPlayingSong(by amount: Double) {
		self.audioPlayer.fastForwardSong(by: amount)
	}
	
	/// Rewinds the currntly playing song
	/// - Parameter amount: Number of seconds to rewind
	public func rewindPlayingSong(by amount: Double) {
		self.audioPlayer.rewindSong(by: amount)
	}
	
	/// Skips to a position in the currently playing song
	/// - Parameter position: Number of seconds from start of song
	public func seekToPositionInPlayingSong(position: Double) {
		self.audioPlayer.seekTo(position: position)
	}
	
	/// Stops playing any song and empties the song queue
	public func clearQueue() {
		self.songQueue = []
		self.currentSong = 0
		
		if isPlaying() {
			self.audioPlayer.stopSong()
		}
	}
	
	/// Gets if a song is currently being played
	/// - Returns: Playing status
	public func isPlaying() -> Bool {
		return self.audioPlayer.isPlaying()
	}
	
	/// Gets the playback position of the current song in the queue
	/// - Returns: The playback position of the current song in the queue
	public func getCurrentSongPlaybackPosition() -> Double {
		return self.audioPlayer.getPlaybackPosition()
	}
	
	/// Gets all songs lined up in the queue
	/// - Returns: All songs lined up to be played, including the currently playing song
	public func getAllSongsToPlay() -> [Song] {
		return Array(self.songQueue.dropFirst(self.currentSong))
	}
	
	// MARK: - Private methods
	
	/// Gets the current song in the queue
	/// - Returns: The current song in the queue
	private func getCurrentSong() -> Song {
		let song: Song
		
		// Prevents currentSong pointing to index outside of array
		if self.currentSong < 0 {
			song = self.songQueue[0]
		} else if self.currentSong > (self.songQueue.count - 1) {
			song = self.songQueue[self.songQueue.count - 1]
		} else {
			song = self.songQueue[self.currentSong]
		}
		
		return song
	}
	
	/// Plays a song
	/// - Parameter song: The song to be played
	private func playSong(song: Song) throws {
		try self.audioPlayer.loadSong(song: song, mode: song.settings.mode, sender: self)
		self.audioPlayer.playSong()
	}
	
	/// Configures the OS control center audio controls
	/// - Bug: Controls setup means that only one instance of the class can be used per app
	private func setupSystemAudioControls() {
		let commandCenter = MPRemoteCommandCenter.shared()
		
		// Play
		if self.settings.playEnabled {
			commandCenter.playCommand.isEnabled = true
			commandCenter.playCommand.addTarget { event in
				self.resumeQueue()
				self.controlCenterUsed()
				return .success
			}
		} else {
			commandCenter.playCommand.isEnabled = false
		}
		
		// Pause
		if self.settings.pauseEnabled {
			commandCenter.pauseCommand.isEnabled = true
			commandCenter.pauseCommand.addTarget { event in
				self.pauseQueue()
				self.controlCenterUsed()
				return .success
			}
		} else {
			commandCenter.pauseCommand.isEnabled = false
		}
		
		// Next track
		if self.settings.nextTrackEnabled {
			commandCenter.nextTrackCommand.isEnabled = true
			commandCenter.nextTrackCommand.addTarget { event in
				try? self.skipForwardsInQueue(by: 1)
				self.controlCenterUsed()
				return .success
			}
		} else {
			commandCenter.nextTrackCommand.isEnabled = false
		}
		
		// Previous track
		if self.settings.previousTrackEnabled {
			commandCenter.previousTrackCommand.isEnabled = true
			commandCenter.previousTrackCommand.addTarget { event in
				try? self.skipBackwardsInQueue(by: 1)
				self.controlCenterUsed()
				return .success
			}
		} else {
			commandCenter.previousTrackCommand.isEnabled = false
		}
		
		// 15 sec skip forwards
		if self.settings.fastForwardEnabled {
			commandCenter.skipForwardCommand.isEnabled = true
			commandCenter.skipForwardCommand.addTarget { event in
				self.fastFordwardPlayingSong(by: 15.0)
				self.controlCenterUsed()
				return .success
			}
		} else {
			commandCenter.skipForwardCommand.isEnabled = false
		}
		
		// 15 sec skip backwards
		if self.settings.rewindEnabled {
			commandCenter.skipBackwardCommand.isEnabled = true
			commandCenter.skipBackwardCommand.addTarget { event in
				self.rewindPlayingSong(by: 15.0)
				self.controlCenterUsed()
				return .success
			}
		} else {
			commandCenter.skipBackwardCommand.isEnabled = false
		}
		
		// Progress seek bar
		if self.settings.scrubBarEnabled {
			commandCenter.changePlaybackPositionCommand.isEnabled = true
			commandCenter.changePlaybackPositionCommand.addTarget { event in
				if let commandEvent = event as? MPChangePlaybackPositionCommandEvent {
					self.seekToPositionInPlayingSong(position: commandEvent.positionTime)
					self.controlCenterUsed()
					return .success
				}
				
				return .commandFailed
			}
		} else {
			commandCenter.changePlaybackPositionCommand.isEnabled = false
		}
	}
	
	/// Send a `NotificationCenter` notification when control center is used to edit playback if enabled in settings
	private func controlCenterUsed() {
		if self.settings.updatePlaybackNotificationEnabled {
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SSPControlCenterUpdate"), object: nil)
		}
	}
	
	// MARK: - Delegate methods
	
	/// Plays next song in queue when current song is finished playing
	/// - Note: Runs when `AVAudioPlayer` finishes playing audio
	/// - Note: Public scope is required for `AVAudioPlayerDelegate` to access it
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		if flag == true {
			controlCenterUsed()
			self.audioPlayer.updateNowPlayingInfo()
			
			if !self.songQueue.isEmpty && self.settings.autoStartNextTrackEnabled {
				if (self.currentSong + 1) < self.songQueue.count {
					self.currentSong += 1
					let song = getCurrentSong()
					try? playSong(song: song)
				} else {
					// Sets index to 1 larger than the size of array in preparation for adding another item to queue
					self.currentSong = self.songQueue.count
				}
			}
		}
	}
}
