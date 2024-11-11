//
//  EventAPIService.swift
//  TicketLord
//
//  Created by Hubert Wojtowicz on 09/11/2024.
//

import Foundation

struct EventAPIService {
    func fetchEvents(pageSize: Int, page: Int, sort: String) async throws -> APIEventResponse {
        let urlString = "https://app.ticketmaster.com/discovery/v2/events.json?size=\(pageSize)&page=\(page)&sort=\(sort)&countryCode=PL&apikey=oxIfm7pdbGgmzbAZqb7LaqTQGFwdClWS"
        guard let url = URL(string: urlString) else { throw URLError(.badURL)}
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(APIEventResponse.self, from: data)
        
    }
    
    func fetchEventDetails(eventID: String) async throws -> EventDetails {
        let urlString = "https://app.ticketmaster.com/discovery/v2/events/\(eventID).json?domain=&apikey=oxIfm7pdbGgmzbAZqb7LaqTQGFwdClWS"
        guard let url = URL(string: urlString) else { throw URLError(.badURL)}
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(EventDetails.self, from: data)
    }
}
