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
    private let eventAPIService = EventAPIService()
    @Published var sortOption: String = "date,asc"
    let sortingOptions: [String:String] = ["name,asc":"Nazwa rosnąco", "name,desc":"Nazwa malejąco", "date,asc":"Data rosnąco", "date,desc":"Data malejąco", "relevance,asc":"Znaczeni rosnąco", "relevance,desc":"Znaczeni malejąco","name,date,asc":"Nazwa i data rosnąco", "name,date,desc":"Nazwa i data malejąco", "random": "Losowo"]
    
    private var currentPage: Int = 0
    private var pageSize: Int = 10
    /// true while loadEvents work, secure that system won't start second loadEvents() while its downloading content
    private var isLoading: Bool = false
    
    /// end function if all events from API has been downloaded
    private var canLoadMore: Bool = true
    
    
    func dateFormatted(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    /// return formatted date and place of event
    func datePlace(event: Event) -> String {
        let place = event.embeddedEvent.venues.first?.name ?? "Unknown"
        let city = event.embeddedEvent.venues.first?.city.name ?? "Unknown"
        let date = event.dates.start.date
        return dateFormatted(date: date) + ", " + city + ", " + place
    }

    // Output String of URL of first event image with ration 4:3, if there aren't any output first image url, if there aren't any then empty string
    func getImageURL(event: Event) -> String {
        if let imageFourThree = event.images.first(where: {$0.width / $0.height == 4/3 && !$0.fallback}) {
            return imageFourThree.url
        } else {
            return event.images.first?.url ?? ""
        }
    }
    
    
    /// Format API call, then add response to event array,
    /// - Parameter reset: reset currentPage, events array and canLoadMore to ensure correct event list order when changing sort parameter
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
            let apiEventResponse = try await eventAPIService.fetchEvents(pageSize: pageSize, page: currentPage, sort: sortOption)
                        
            events.append(contentsOf: apiEventResponse.embedded.events)
            currentPage += 1
            
            if apiEventResponse.page.totalPages < currentPage {
                canLoadMore = false
            }
        } catch {
            print("Error fetching events: \(error)")
        }
        
        isLoading = false
    }
}
