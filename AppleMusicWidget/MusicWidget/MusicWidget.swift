//
//  MusicWidget.swift
//  MusicWidget
//
//  Apple Music widget with glass theme
//

import WidgetKit
import SwiftUI
import AppKit

struct Provider: TimelineProvider {
    let musicPlayer = MusicPlayerManager()

    func placeholder(in context: Context) -> MusicEntry {
        MusicEntry(
            date: Date(),
            track: MusicTrack(title: "Song Title", artist: "Artist Name", album: "Album Name"),
            isPlaying: false,
            artwork: nil
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (MusicEntry) -> ()) {
        musicPlayer.updateCurrentTrack()
        let entry = MusicEntry(
            date: Date(),
            track: musicPlayer.currentTrack,
            isPlaying: musicPlayer.isPlaying,
            artwork: musicPlayer.artwork
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MusicEntry>) -> ()) {
        musicPlayer.updateCurrentTrack()
        let currentDate = Date()
        let entry = MusicEntry(
            date: currentDate,
            track: musicPlayer.currentTrack,
            isPlaying: musicPlayer.isPlaying,
            artwork: musicPlayer.artwork
        )

        // Update every 5 seconds
        let nextUpdate = Calendar.current.date(byAdding: .second, value: 5, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct MusicEntry: TimelineEntry {
    let date: Date
    let track: MusicTrack?
    let isPlaying: Bool
    let artwork: NSImage?
}

struct MusicWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.2),
                    Color(red: 0.2, green: 0.1, blue: 0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 12) {
                // Artwork
                if let artwork = entry.artwork {
                    Image(nsImage: artwork)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(Color.white.opacity(0.3), lineWidth: 1.5)
                        )
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                } else {
                    // Placeholder
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.purple.opacity(0.6),
                                        Color.blue.opacity(0.6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)

                        Image(systemName: "music.note")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 1.5)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                }

                // Track info
                VStack(spacing: 4) {
                    Text(entry.track?.displayTitle ?? "No Music Playing")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(entry.track?.displayArtist ?? "Open Apple Music")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(1)
                }
                .padding(.horizontal, 8)

                // Controls
                HStack(spacing: 20) {
                    // Previous button
                    Link(destination: URL(string: "music-widget://previous")!) {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color.white.opacity(0.3),
                                                        Color.white.opacity(0.05)
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    )
                                    .overlay(
                                        Circle()
                                            .strokeBorder(Color.white.opacity(0.5), lineWidth: 0.5)
                                    )
                            )
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                    }

                    // Play/Pause button
                    Link(destination: URL(string: "music-widget://toggle")!) {
                        Image(systemName: entry.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color.white.opacity(0.35),
                                                        Color.white.opacity(0.1)
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    )
                                    .overlay(
                                        Circle()
                                            .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }

                    // Next button
                    Link(destination: URL(string: "music-widget://next")!) {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color.white.opacity(0.3),
                                                        Color.white.opacity(0.05)
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    )
                                    .overlay(
                                        Circle()
                                            .strokeBorder(Color.white.opacity(0.5), lineWidth: 0.5)
                                    )
                            )
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                }
            }
            .padding()
        }
        .widgetBackground()
    }
}

struct MusicWidget: Widget {
    let kind: String = "MusicWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MusicWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Apple Music Widget")
        .description("Control your Apple Music playback with a beautiful glass-themed widget.")
        .supportedFamilies([.systemMedium])
    }
}

// Widget background modifier
extension View {
    func widgetBackground() -> some View {
        if #available(macOS 14.0, *) {
            return self.containerBackground(for: .widget) {
                Color.clear
            }
        } else {
            return self.background(Color.clear)
        }
    }
}

#Preview(as: .systemMedium) {
    MusicWidget()
} timeline: {
    MusicEntry(
        date: .now,
        track: MusicTrack(title: "Song Title", artist: "Artist Name", album: "Album Name"),
        isPlaying: true,
        artwork: nil
    )
}
