//
//  EventDetailModel.swift
//  TicketLord
//
//  Created by Hubert Wojtowicz on 09/11/2024.
//

import Foundation

struct APIEventDetailResponse: Codable {
    let name: String
    let dates: EventDate
    let embedded: EmbeddedEventDetail
    let classifications: [Classiffication]
    let priceRanges: [PriceRange]
    let ticketing: Ticketing
    let images: [EventDetailImage]
    let seatmap: Seatmap
    
    enum CodingKeys: String, CodingKey {
        case name
        case dates
        case embedded = "_embedded"
        case classifications
        case priceRanges
        case ticketing
        case images
        case seatmap
    }
}

struct EventDate: Codable {
    let start: EventStart
}

struct EventStart : Codable {
    let localDate: String
    let localTime: String
    var dataTimeString: String {
        return "\(localTime) \(localDate)"
    }
    var dateTime: Date {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dataFormatter.date(from: dataTimeString) ?? Date.now
    }
}

struct Seatmap: Codable {
    let staticURL: String
}

struct EventDetailImage: Codable {
    let url: String
    let attribution: String
}

struct Ticketing: Codable {
    let safeTix: SafeTix
}

struct SafeTix: Codable {
    let enabled: Bool
}

struct PriceRange: Codable {
    let type: String
    let currency: String
    let min: Double
    let max: Double
}

struct EmbeddedEventDetail: Codable {
    let venues: [VenuesDetail]
}

struct VenuesDetail: Codable {
    let name: String
    let country: Country
    let city: City
    let address: Address
}

struct Country: Codable {
    let name: String
}

struct Address: Codable {
    let line1: String
}

struct Classiffication: Codable {
    let segment: Segment
    let genre: Genre
    let subGenre: Genre
}

struct Segment: Codable {
    let name: String
}

struct Genre: Codable {
    let name: String
}

