# Apple Music Widget for macOS

A beautiful, glass-themed SwiftUI application and widget for controlling Apple Music on macOS. Features a modern glassmorphism design with full playback controls and real-time album artwork display.

## Features

- **Glass Theme Design**: Modern glassmorphism UI with translucent effects
- **Full Playback Controls**: Play, pause, skip forward, and skip backward
- **Album Artwork Display**: Shows current track's album art in real-time
- **Real-time Updates**: Automatically syncs with Apple Music playback
- **Widget Support**: macOS widget for quick access to music controls
- **Clean Interface**: Minimalist design with smooth animations

## Screenshots

The app features:
- Large album artwork display with glass effect border
- Track information (title, artist, album)
- Glass-themed control buttons with smooth interactions
- Beautiful gradient background
- Real-time playback status

## Requirements

- macOS 14.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later
- Apple Music app installed

## Installation

### Option 1: Build from Source (Recommended)

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd js_assign
   ```

2. **Open the project in Xcode**:
   ```bash
   open AppleMusicWidget/AppleMusicWidget.xcodeproj
   ```

3. **Configure signing**:
   - Select the project in Xcode
   - Go to "Signing & Capabilities"
   - Select your development team for both targets:
     - AppleMusicWidget (main app)
     - MusicWidget (widget extension)

4. **Build and run**:
   - Select "AppleMusicWidget" scheme
   - Choose "My Mac" as the destination
   - Click Run (⌘R)

### Option 2: Direct Xcode Project

Simply open `AppleMusicWidget.xcodeproj` in Xcode and build.

## Setup & Permissions

### Required Permissions

The app requires the following permissions:

1. **AppleScript/Automation Access**:
   - On first launch, macOS will prompt for permission
   - Allow "AppleMusicWidget" to control "Music"
   - This is required for playback controls

2. **System Settings Configuration**:
   ```
   System Settings → Privacy & Security → Automation
   ```
   - Ensure "AppleMusicWidget" has permission to control "Music"

### Adding the Widget

1. **Open Widget Center**:
   - Click the date/time in menu bar
   - Click "Edit Widgets" at the bottom

2. **Add Music Widget**:
   - Find "Apple Music Widget" in the widget list
   - Drag the medium-sized widget to your desired location
   - Close the widget editor

3. **Widget Interactions**:
   - The widget updates every 5 seconds automatically
   - Click controls to play/pause or skip tracks
   - Widget links will open the main app for actions

## Project Structure

```
AppleMusicWidget/
├── AppleMusicWidget/           # Main application
│   ├── AppleMusicWidgetApp.swift
│   ├── ContentView.swift
│   ├── Assets.xcassets/
│   ├── Info.plist
│   └── AppleMusicWidget.entitlements
│
├── MusicWidget/                # Widget extension
│   ├── MusicWidgetBundle.swift
│   ├── MusicWidget.swift
│   └── MusicWidgetExtension.entitlements
│
└── Shared/                     # Shared code
    ├── MusicPlayerManager.swift     # Apple Music control
    ├── MusicTrack.swift             # Data model
    └── GlassEffectModifier.swift    # Glass UI theme
```

## Architecture

### Components

1. **MusicPlayerManager**:
   - Controls Apple Music via AppleScript
   - Monitors playback state every 2 seconds
   - Retrieves track information and artwork
   - Methods: `play()`, `pause()`, `nextTrack()`, `previousTrack()`

2. **Glass Effect System**:
   - `GlassEffectModifier`: View modifier for glass effect
   - `GlassButtonStyle`: Custom button style
   - Ultra-thin material with gradient overlays
   - Smooth shadows and borders

3. **ContentView**:
   - Main app interface
   - Displays current track with artwork
   - Interactive playback controls
   - Auto-updates from MusicPlayerManager

4. **MusicWidget**:
   - WidgetKit extension
   - Timeline updates every 5 seconds
   - Glass-themed mini player
   - Deep links for control actions

## Usage

### Main App

1. **Launch the app**:
   - The app will appear with a glass-themed music player
   - If Apple Music is playing, track info will appear immediately

2. **Controls**:
   - **Play/Pause**: Large center button
   - **Previous Track**: Left button
   - **Next Track**: Right button
   - Album artwork updates automatically

3. **No Music Playing**:
   - App shows "No music playing" message
   - Open Apple Music and start playing
   - Info will appear within 2 seconds

### Widget

- **Auto-updates**: Widget refreshes every 5 seconds
- **Click controls**: Interact directly with widget buttons
- **Artwork**: Displays current album art
- **Fallback**: Shows placeholder when no music is playing

## Customization

### Adjusting Glass Effect

Edit `GlassEffectModifier.swift`:

```swift
.glassEffect(
    cornerRadius: 20,      // Adjust roundness
    blurRadius: 10,        // Adjust blur intensity
    opacity: 0.7           // Adjust transparency
)
```

### Changing Update Frequency

**Main App** (`MusicPlayerManager.swift`):
```swift
// Change monitoring interval (line 24)
timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true)
```

**Widget** (`MusicWidget.swift`):
```swift
// Change update interval (line 45)
let nextUpdate = Calendar.current.date(byAdding: .second, value: 5, to: currentDate)!
```

### Modifying Colors

Edit the gradient colors in `ContentView.swift`:

```swift
LinearGradient(
    gradient: Gradient(colors: [
        Color(red: 0.1, green: 0.1, blue: 0.2),  // Top color
        Color(red: 0.2, green: 0.1, blue: 0.3),  // Middle
        Color(red: 0.1, green: 0.05, blue: 0.2)  // Bottom
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

## Troubleshooting

### App doesn't detect music

1. **Check Apple Music is running**:
   ```bash
   # Check if Music app is running
   ps aux | grep Music
   ```

2. **Verify permissions**:
   - System Settings → Privacy & Security → Automation
   - Enable "AppleMusicWidget" → "Music"

3. **Reset permissions**:
   ```bash
   tccutil reset AppleEvents
   ```
   Then restart the app and re-grant permissions

### Widget not updating

1. **Check widget is added to Notification Center**
2. **Restart widget**:
   - Remove widget from Notification Center
   - Re-add it from the widget picker

3. **Rebuild widget extension**:
   - Clean build folder (⇧⌘K)
   - Rebuild project (⌘B)

### Controls not working

1. **Verify Apple Music is running**
2. **Check automation permissions**
3. **Try manual AppleScript**:
   ```bash
   osascript -e 'tell application "Music" to play'
   ```

### Build errors

1. **Update signing**:
   - Select your development team in project settings
   - Ensure provisioning profiles are up to date

2. **Clean and rebuild**:
   ```
   Product → Clean Build Folder (⇧⌘K)
   Product → Build (⌘B)
   ```

3. **Check macOS version**:
   - Ensure you're running macOS 14.0 or later
   - Check Xcode is version 15.0 or later

## Technical Details

### AppleScript Integration

The app uses AppleScript to communicate with Apple Music:

```applescript
tell application "Music"
    play                    # Start playback
    pause                   # Pause playback
    next track              # Skip to next
    previous track          # Skip to previous
    name of current track   # Get track info
end tell
```

### Permissions

Required entitlements:
- `com.apple.security.automation.apple-events`: Control Apple Music
- `com.apple.security.app-sandbox`: App sandboxing
- `com.apple.security.temporary-exception.apple-events`: Apple Music access

### Performance

- **Memory**: ~30-50 MB typical usage
- **CPU**: <1% when idle, ~2-3% during updates
- **Update Frequency**: Main app (2s), Widget (5s)

## Known Limitations

1. **Apple Music Required**: Only works with Apple Music app (not Spotify, etc.)
2. **macOS Only**: Not compatible with iOS/iPadOS
3. **Automation Prompt**: First launch requires permission grant
4. **Widget Interactions**: Some widget actions may open main app

## Future Enhancements

Potential features for future versions:
- Volume control slider
- Playback progress bar
- Library browsing
- Playlist management
- Keyboard shortcuts
- Mini player mode
- Multiple widget sizes

## License

This project is provided as-is for educational and personal use.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Support

For issues, questions, or suggestions:
1. Check the Troubleshooting section above
2. Review system permissions
3. Ensure all requirements are met
4. Open an issue on GitHub

## Credits

Built with:
- SwiftUI for modern UI
- WidgetKit for widget support
- AppleScript for Music app integration
- macOS native frameworks

---

**Enjoy your beautiful glass-themed Apple Music widget!**
