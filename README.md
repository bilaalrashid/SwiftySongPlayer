# SwiftySongPlayer

Library for playing a queue of songs.

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
