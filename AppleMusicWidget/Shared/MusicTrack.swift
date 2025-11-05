//
//  MusicTrack.swift
//  AppleMusicWidget
//
//  Data model for music track information
//

import Foundation

struct MusicTrack: Codable, Identifiable {
    let id = UUID()
    let title: String
    let artist: String
    let album: String

    var displayTitle: String {
        title.isEmpty ? "No Title" : title
    }

    var displayArtist: String {
        artist.isEmpty ? "Unknown Artist" : artist
    }

    var displayAlbum: String {
        album.isEmpty ? "Unknown Album" : album
    }

    enum CodingKeys: String, CodingKey {
        case title, artist, album
    }
}
