//
//  AppleMusicWidgetApp.swift
//  AppleMusicWidget
//
//  Main app entry point
//

import SwiftUI

@main
struct AppleMusicWidgetApp: App {
    @StateObject private var musicPlayer = MusicPlayerManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(musicPlayer)
                .frame(minWidth: 400, minHeight: 500)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
