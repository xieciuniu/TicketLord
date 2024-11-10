//
//  EventDetalisViewModel.swift
//  TicketLord
//
//  Created by Hubert Wojtowicz on 09/11/2024.
//

import Foundation

@MainActor
class EventDetailsViewModel: ObservableObject {
    private let eventAPIService = EventAPIService()
    @Published var eventDetails: EventDetails?
    
    
    func loadEventDetails(eventID: String) async {
        do {
            eventDetails = try await eventAPIService.fetchEventDetails(eventID: eventID)
//            eventDetails?.embedded
            
        } catch {
            print("Error fetching event details: \(error)")
        }
    }
    
}
