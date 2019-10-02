//
//  SongSettings.swift
//  SwiftySongPlayer
//
//  Created by Bilaal Rashid on 09/07/2019.
//  Copyright © 2019 Bilaal Rashid. All rights reserved.
//

import Foundation

/// Optional settings for a `Song` played in a `SwiftySongPlayer`
public struct SongSettings: Equatable {
	
	// MARK: - Properties
	
	/// Routing mode for playing audio
	public var mode: PlaybackMode = .normal
	
	// MARK: - Constructor
	
	/// Constructor
	public init() {}
	
}
