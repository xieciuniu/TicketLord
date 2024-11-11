//
//  EventDetailModel.swift
//  TicketLord
//
//  Created by Hubert Wojtowicz on 09/11/2024.
//

import Foundation

struct EventDetails: Codable {
    let name: String
    let dates: EventDate
    let embedded: EmbeddedEventDetail
    let classifications: [Classiffication]
    let priceRanges: [PriceRange]?
    let ticketing: Ticketing?
    let images: [EventDetailImage]
    let seatmap: Seatmap?
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case dates
        case embedded = "_embedded"
        case classifications
        case priceRanges
        case ticketing
        case images
        case seatmap
        case url
    }
}

struct EventDate: Codable {
    let start: EventStart
}

struct EventStart : Codable {
    let localDate: String?
    let localTime: String?
    
    var date: String? {
        let dateFormatter = DateFormatter()
        if let date = localDate, let time = localTime {
            dateFormatter.dateFormat = "HH:mm:ss yyyy-MM-dd"
            let dateDate = dateFormatter.date(from: "\(time) \(date)")!
            dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
            return dateFormatter.string(from: dateDate)
        } else if let date = localDate {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateDate = dateFormatter.date(from: date)!
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: dateDate)
        }
        return nil
    }
}

struct Seatmap: Codable {
//    let staticURL: String?
    let staticUrl: String?
}

struct EventDetailImage: Codable {
    let url: String
    let fallback: Bool
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
    let attractions: [Attraction]
}

struct Attraction: Codable {
    let name: String
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
    let subGenre: Genre?
    let primary: Bool
}

struct Segment: Codable {
    let name: String
}

struct Genre: Codable {
    let name: String
}

