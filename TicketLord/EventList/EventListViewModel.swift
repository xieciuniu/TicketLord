//
//  EventListViewModel.swift
//  TicketLord
//
//  Created by Hubert Wojtowicz on 09/11/2024.
//

import Foundation

@MainActor
class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var sortOption: String = "date,asc"
    private let eventAPIService = EventAPIService()
    
    private var currentPage: Int = 0
    private var pageSize: Int = 10
    private var isLoading: Bool = false
    private var canLoadMore: Bool = true
    let sortingOptions: [String:String] = ["name,asc":"Nazwa rosnąco", "name,desc":"Nazwa malejąco", "date,asc":"Data rosnąco", "date,desc":"Data malejąco", "relevance,asc":"Znaczeni rosnąco", "relevance,desc":"Znaczeni malejąco","name,date,asc":"Nazwa i data rosnąco", "name,date,desc":"Nazwa i data malejąco", "random": "Losowo"]
    
    func dateFormatted(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    func datePlace(event: Event) -> String {
        let place = event.embeddedEvent.venues.first?.name ?? "Unknown"
        let city = event.embeddedEvent.venues.first?.city.name ?? "Unknown"
        let date = event.dates.start.date
        
        return dateFormatted(date: date) + ", " + city + ", " + place
    }
    
    func getImageURL(event: Event) -> String {
        if let imageFourThree = event.images.first(where: {$0.width / $0.height == 4/3 }) {
            return imageFourThree.url
        } else {
            return event.images.first?.url ?? ""
        }
    }
    
    
    func loadEvents(reset: Bool = false) async {
        if isLoading { return }
        isLoading = true
        
        if reset {
            currentPage = 0
            canLoadMore = true
            events = []
        }
        
        guard canLoadMore else { return }
        
        do {
            let apiEventResponse = try await eventAPIService.fetchEvents(page: currentPage, sort: sortOption)
            
            if apiEventResponse.page.totalPages < pageSize {
                canLoadMore = false
            }
            
            events.append(contentsOf: apiEventResponse.embedded.events)
            currentPage += 1
        } catch {
            print("Error fetching events: \(error)")
        }
        
        isLoading = false
    }
}
