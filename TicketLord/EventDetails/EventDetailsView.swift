//
//  EventDetailsView.swift
//  TicketLord
//
//  Created by Hubert Wojtowicz on 09/11/2024.
//

import SwiftUI

struct EventDetailsView: View {
    let eventID: String
    @StateObject var viewModel = EventDetailsViewModel()
    
    var body: some View {
        VStack {
            if let details = viewModel.eventDetails {
                Text(details.name)
                ForEach(details.embedded.attractions, id: \.name) {
                    Text($0.name)
                }
                Text(details.dates.start.dataTimeString)
                
                
                ForEach(details.embedded.venues, id: \.name) { venue in
                    Text(venue.country.name)
                    HStack {
                        Text(venue.city.name)
                        Text(venue.address.line1)
                    }
                    Text(venue.name)
                }
                
                
                ForEach(details.classifications, id: \.genre.name){ classific in
                    HStack{
                        Text(classific.segment.name + "/" + classific.genre.name)
                    }
                }
                
                
                if let priceRanges = details.priceRanges {
                    ForEach(priceRanges, id: \.type) { price in
                        HStack{
                            Text(price.type)
                            Text(" -> " + String(price.min) + " - " + String(price.max))
                        }
                    }
                }
                
                Link("Open in webbrowser", destination: URL(string: details.url)!)
                
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .onAppear {
            Task {
                await viewModel.loadEventDetails(eventID: eventID)
            }
        }
    }
}

//#Preview {
//    EventDetailsView()
//}
