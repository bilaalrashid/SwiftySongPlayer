//
//  AudioPlayerSettings.swift
//  SwiftySongPlayer
//
//  Created by Bilaal Rashid on 04/07/2019.
//  Copyright © 2019 Bilaal Rashid. All rights reserved.
//

import Foundation

/// Optional settings for `SwiftySongPlayer`
struct PlayerSettings {
	/// Toggle to enable OS control center play button
	var playEnabled = true
	
	/// Toggle to enable OS control center pause button
	var pauseEnabled = true
	
	/// Toggle to enable OS control center skip to next track button
	var nextTrackEnabled = true
	
	/// Toggle to enable OS control center skip to previous track button
	var previousTrackEnabled = true
	
	/// Toggle to enable OS control center fast forward button
	var fastForwardEnabled = false
	
	/// Toggle to enable OS control center rewind button
	var rewindEnabled = false
	
	/// Toggle to enable scrubbing in OS control center playback progress bar
	var scrubBarEnabled = true
	
	/// Toggle to enable `NotificationCenter` notification when control center player controls are used
	var updatePlaybackNotificationEnabled = false
	
	/// Toggle to enable the next song in the queue to be played when the previous song finishes
	var autoStartNextTrackEnabled = true
}
