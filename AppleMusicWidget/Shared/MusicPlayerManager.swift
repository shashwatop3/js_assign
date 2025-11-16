//
//  MusicPlayerManager.swift
//  AppleMusicWidget
//
//  Music Player Manager for controlling Apple Music
//

import Foundation
import AppKit
import Combine

class MusicPlayerManager: ObservableObject {
    @Published var currentTrack: MusicTrack?
    @Published var isPlaying: Bool = false
    @Published var artwork: NSImage?

    private var timer: Timer?

    init() {
        startMonitoring()
        updateCurrentTrack()
    }

    deinit {
        timer?.invalidate()
    }

    // MARK: - Monitoring

    private func startMonitoring() {
        // Update every 2 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateCurrentTrack()
        }
    }

    func updateCurrentTrack() {
        guard let music = getMusicApp() else {
            currentTrack = nil
            isPlaying = false
            artwork = nil
            return
        }

        // Check if Music is running
        if !music.isRunning {
            currentTrack = nil
            isPlaying = false
            artwork = nil
            return
        }

        // Get current track info via AppleScript
        let script = """
        tell application "Music"
            if player state is not stopped then
                set trackName to name of current track
                set artistName to artist of current track
                set albumName to album of current track
                set playerState to player state as string
                return trackName & "|||" & artistName & "|||" & albumName & "|||" & playerState
            else
                return "stopped"
            end if
        end tell
        """

        if let result = runAppleScript(script) {
            if result == "stopped" {
                currentTrack = nil
                isPlaying = false
                artwork = nil
            } else {
                let components = result.components(separatedBy: "|||")
                if components.count >= 4 {
                    let track = MusicTrack(
                        title: components[0],
                        artist: components[1],
                        album: components[2]
                    )
                    currentTrack = track
                    isPlaying = components[3] == "playing"

                    // Get artwork
                    getArtwork()
                }
            }
        }
    }

    private func getArtwork() {
        let script = """
        tell application "Music"
            if player state is not stopped then
                try
                    set artworkData to data of artwork 1 of current track
                    return artworkData
                on error
                    return missing value
                end try
            end if
        end tell
        """

        if let artworkData = runAppleScriptForData(script) {
            artwork = NSImage(data: artworkData)
        } else {
            artwork = nil
        }
    }

    // MARK: - Playback Control

    func play() {
        let script = """
        tell application "Music"
            play
        end tell
        """
        runAppleScript(script)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateCurrentTrack()
        }
    }

    func pause() {
        let script = """
        tell application "Music"
            pause
        end tell
        """
        runAppleScript(script)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateCurrentTrack()
        }
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func nextTrack() {
        let script = """
        tell application "Music"
            next track
        end tell
        """
        runAppleScript(script)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateCurrentTrack()
        }
    }

    func previousTrack() {
        let script = """
        tell application "Music"
            previous track
        end tell
        """
        runAppleScript(script)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateCurrentTrack()
        }
    }

    // MARK: - Helper Methods

    private func getMusicApp() -> NSRunningApplication? {
        let runningApps = NSWorkspace.shared.runningApplications
        return runningApps.first { $0.bundleIdentifier == "com.apple.Music" }
    }

    @discardableResult
    private func runAppleScript(_ script: String) -> String? {
        var error: NSDictionary?
        let appleScript = NSAppleScript(source: script)
        let eventDescriptor = appleScript?.executeAndReturnError(&error)

        if let error = error {
            print("AppleScript Error: \(error)")
            return nil
        }

        return eventDescriptor?.stringValue
    }

    private func runAppleScriptForData(_ script: String) -> Data? {
        var error: NSDictionary?
        let appleScript = NSAppleScript(source: script)
        let eventDescriptor = appleScript?.executeAndReturnError(&error)

        if let error = error {
            print("AppleScript Error: \(error)")
            return nil
        }

        guard let descriptor = eventDescriptor else { return nil }

        // Convert descriptor to data
        let dataCount = descriptor.numberOfItems
        var bytes = [UInt8]()

        for i in 1...dataCount {
            if let item = descriptor.atIndex(i) {
                let byte = UInt8(item.int32Value)
                bytes.append(byte)
            }
        }

        return Data(bytes)
    }
}
