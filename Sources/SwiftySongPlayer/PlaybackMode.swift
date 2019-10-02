//
//  PlaybackMode.swift
//  SwiftySongPlayer
//
//  Created by Bilaal Rashid on 04/07/2019.
//  Copyright © 2019 Bilaal Rashid. All rights reserved.
//

import Foundation

/// Routing mode for playing audio
public enum PlaybackMode {
	/// Routes audio to system default route e.g. bluetooth speaker
	case normal
	
	/// Routes audio through device earspeaker
	case earspeaker
	
	/// Routes audio through devices main speakers (including earspeaker surround sound on iPhone 7 and above)
	/// - Bug: Routing issues when plugging in and unpluging headphones
	case loudspeaker
}
