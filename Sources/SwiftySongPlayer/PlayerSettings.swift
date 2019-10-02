//
//  AudioPlayerSettings.swift
//  SwiftySongPlayer
//
//  Created by Bilaal Rashid on 04/07/2019.
//  Copyright © 2019 Bilaal Rashid. All rights reserved.
//

import Foundation

/// Optional settings for `SwiftySongPlayer`
public struct PlayerSettings {
	
	// MARK: - Properties
	
	/// Toggle to enable OS control center play button
	public var playEnabled = true
	
	/// Toggle to enable OS control center pause button
	public var pauseEnabled = true
	
	/// Toggle to enable OS control center skip to next track button
	public var nextTrackEnabled = true
	
	/// Toggle to enable OS control center skip to previous track button
	public var previousTrackEnabled = true
	
	/// Toggle to enable OS control center fast forward button
	public var fastForwardEnabled = false
	
	/// Toggle to enable OS control center rewind button
	public var rewindEnabled = false
	
	/// Toggle to enable scrubbing in OS control center playback progress bar
	public var scrubBarEnabled = true
	
	/// Toggle to enable `NotificationCenter` notification when control center player controls are used
	public var updatePlaybackNotificationEnabled = false
	
	/// Toggle to enable the next song in the queue to be played when the previous song finishes
	public var autoStartNextTrackEnabled = true
	
	// MARK: - Constructor
	
	/// Constructor
	public init() {}
}
