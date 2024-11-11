//
//  EventsModel.swift
//  TicketLord
//
//  Created by Hubert Wojtowicz on 09/11/2024.
//

import Foundation

struct APIEventResponse: Codable {
    let embedded: Embedded
    let page: Page
    
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case page
    }
}

struct Page: Codable {
    let size: Int
    let totalElements: Int
    let totalPages: Int
    let number: Int
}

struct Embedded: Codable {
    let events: [Event]
}

struct Event: Codable, Identifiable, Equatable {
    let name: String
    let id: String
    let images: [Images]
    let dates: EventDates
    let embeddedEvent: EmbeddedEvent
    
    enum CodingKeys: String, CodingKey {
        case name, id, images, dates, embeddedEvent = "_embedded"
    }
    
    static func ==(lhs:Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}

struct EventDates: Codable {
    let start: StartDate
}

struct StartDate: Codable {
    let localDate: String
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: localDate) ?? Date.now
    }
}

struct Images: Codable {
    let height: Int
    let width: Int
    let url: String
    let fallback: Bool
}

struct EmbeddedEvent: Codable {
    let venues: [Venue]
}

struct Venue: Codable {
    let name: String
    let city: City
}

struct City: Codable {
    let name: String
}
