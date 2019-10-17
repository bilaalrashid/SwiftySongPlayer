# SwiftySongPlayer

Swift library for playing a queue of songs.

## Usage

A `Song` object must be created containing the audio and metadata to be played, it is then played using the `SwiftySongPlayer.shared` singleton instance.

### Creating a song

A `Song` has the following properties, which can be set in different ways using different constructors. The best way to do this would be to use Xcode autocomplete or to view the [source code](Sources/SwiftySongPlayer/Song.swift).

| Property  | Description                                             |
|-----------|---------------------------------------------------------|
| `name`    | The name of the song (Optional)                         |
| `artist`  | The name of the artist that created the song (Optional) |
| `album`   | The name of the album containing the song (Optional)    |
| `artwork` | The album artwork for the song (Optional)               |
| `url`     | The URL of the media to be played                       |
| `settings`| Settings for the specific song (Optional)               |

### Playing songs

Since there can only be one channel of audio playing at a time in an app, the library has been implemented as a singleton access via `SwiftySongPlayer.shared`. 

Before using the library, `public func setup(settings: PlayerSettings = PlayerSettings())` must be called. It can be called multiple times without any side effects, although it will not update the player settings for the song player.

Basic playback controls:

```swift
public func addSong(song: Song)
```
```swift
public func playQueue() throws
```
```swift
public func pauseQueue()
```
```swift
public func resumeQueue()
```
```swift
public func clearQueue()
```
Note that `resumeQueue()` will resume playback of the queue at the time position when paused and should be used in favour of `playQueue()` when resuming playback, which will restart the current song.

Advanced playback controls:
```swift
public func skipForwardsInQueue(by amount: Int) throws
```
```swift
public func skipBackwardsInQueue(by amount: Int) throws
```
```swift
public func fastFordwardPlayingSong(by amount: Double)
```
```swift
public func rewindPlayingSong(by amount: Double)
```
```swift
public func seekToPositionInPlayingSong(position: Double)
```

Accessors:
```swift
public func isPlaying() -> Bool
```
```swift
public func getCurrentSongPlaybackPosition() -> Double
```
```swift
public func getAllSongsToPlay() -> [Song]
```
