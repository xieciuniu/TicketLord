//
//  TicketLordTests.swift
//  TicketLordTests
//
//  Created by Hubert Wojtowicz on 07/11/2024.
//

import Testing
@testable import TicketLord
import Foundation

struct TicketLordTests {

    @Test func dateStringOutput() async throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let testDateInput = formatter.date(from: "2024/11/12")
        let date = await EventListViewModel().dateFormatted(date: testDateInput!)
        let expectedDate = "12.11.2024"
        #expect(date == expectedDate)
    }
    
    let sampleEvent = Event(name: "Lansdowne",
                              id: "Z698xZQpZaa8a", images: [Images(height: 639, width: 1136, url: "https://s1.ticketm.net/dam/a/d1b/3d3c0fde-2bba-4bc3-9456-06f6e6d6bd1b_RETINA_LANDSCAPE_16_9.jpg", fallback: false), Images(height: 1024, width: 579, url: "https://s1.ticketm.net/dam/a/d1b/3d3c0fde-2bba-4bc3-9456-06f6e6d6bd1b_TABLET_LANDSCAPE_16_9.jpg", fallback: false), Images(height: 3545, width: 3648, url: "https://s1.ticketm.net/dam/a/d1b/3d3c0fde-2bba-4bc3-9456-06f6e6d6bd1b_SOURCE", fallback: false)], dates: EventDates(start: StartDate(localDate: "2024-11-12")), embeddedEvent: EmbeddedEvent(venues: [Venue(name: "Voodoo Club", city: City(name: "Warsaw"))]))
    
    @Test func datePlaceStringOutput() async throws {
        let datePlace = await EventListViewModel().datePlace(event: sampleEvent)
        let expectedDatePlace = "12.11.2024, Warsaw, Voodoo Club"
        #expect(datePlace == expectedDatePlace)
    }
    
    @Test func datePlaceStringOutputWithNoVenue() async throws {
        let sampleEventWithoutVenue = Event(name: "Lansdowne",id: "Z698xZQpZaa8a", images: [Images(height: 639, width: 1136, url: "https://s1.ticketm.net/dam/a/d1b/3d3c0fde-2bba-4bc3-9456-06f6e6d6bd1b_RETINA_LANDSCAPE_16_9.jpg", fallback: false), Images(height: 1024, width: 579, url: "https://s1.ticketm.net/dam/a/d1b/3d3c0fde-2bba-4bc3-9456-06f6e6d6bd1b_TABLET_LANDSCAPE_16_9.jpg", fallback: false), Images(height: 3545, width: 3648, url: "https://s1.ticketm.net/dam/a/d1b/3d3c0fde-2bba-4bc3-9456-06f6e6d6bd1b_SOURCE", fallback: false)], dates: EventDates(start: StartDate(localDate: "2024-11-12")), embeddedEvent: EmbeddedEvent(venues: []))
        let datePlace = await EventListViewModel().datePlace(event: sampleEventWithoutVenue)
        let expectedDatePlace = "12.11.2024, Unknown, Unknown"
        #expect(datePlace == expectedDatePlace)
    }
}
