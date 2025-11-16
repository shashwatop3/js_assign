//
//  ContentView.swift
//  AppleMusicWidget
//
//  Main view with glass-themed music controls
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var musicPlayer: MusicPlayerManager

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.2),
                    Color(red: 0.2, green: 0.1, blue: 0.3),
                    Color(red: 0.1, green: 0.05, blue: 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                // Title
                Text("Apple Music Widget")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                    .padding(.top, 30)

                // Music Widget Card
                MusicWidgetCard()
                    .environmentObject(musicPlayer)
                    .padding(.horizontal, 30)

                Spacer()

                // Instructions
                if musicPlayer.currentTrack == nil {
                    VStack(spacing: 10) {
                        Text("No music playing")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))

                        Text("Open Apple Music and start playing a song")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

struct MusicWidgetCard: View {
    @EnvironmentObject var musicPlayer: MusicPlayerManager

    var body: some View {
        VStack(spacing: 25) {
            // Album Artwork
            ArtworkView(image: musicPlayer.artwork)
                .frame(width: 250, height: 250)

            // Track Info
            VStack(spacing: 8) {
                Text(musicPlayer.currentTrack?.displayTitle ?? "Not Playing")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(musicPlayer.currentTrack?.displayArtist ?? "No Artist")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(musicPlayer.currentTrack?.displayAlbum ?? "No Album")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.horizontal, 20)

            // Playback Controls
            HStack(spacing: 25) {
                // Previous Button
                Button(action: {
                    musicPlayer.previousTrack()
                }) {
                    Image(systemName: "backward.fill")
                }
                .buttonStyle(GlassButtonStyle(size: 50))

                // Play/Pause Button
                Button(action: {
                    musicPlayer.togglePlayPause()
                }) {
                    Image(systemName: musicPlayer.isPlaying ? "pause.fill" : "play.fill")
                }
                .buttonStyle(GlassButtonStyle(size: 65, isMain: true))

                // Next Button
                Button(action: {
                    musicPlayer.nextTrack()
                }) {
                    Image(systemName: "forward.fill")
                }
                .buttonStyle(GlassButtonStyle(size: 50))
            }
            .padding(.bottom, 10)
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 25)
        .glassEffect(cornerRadius: 30)
    }
}

struct ArtworkView: View {
    let image: NSImage?

    var body: some View {
        Group {
            if let image = image {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                // Default artwork placeholder
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.purple.opacity(0.6),
                            Color.blue.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Image(systemName: "music.note")
                        .font(.system(size: 80))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
        .frame(width: 250, height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.6),
                            Color.white.opacity(0.2)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
    }
}

#Preview {
    ContentView()
        .environmentObject(MusicPlayerManager())
}
