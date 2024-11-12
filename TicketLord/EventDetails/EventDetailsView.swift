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
                ScrollView {
                    VStack {
                        // Galeria zdjęć
                        TabView(selection: $viewModel.selectedImageIndex) {
                            ForEach(0..<details.images.count, id: \.self) { index in
                                AsyncImage(url: URL(string: details.images[index].url)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        .frame(height: 300)
                        .tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
                        
                        HStack{
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(details.name)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .padding(.bottom, 10)
                                    
                                    ForEach(details.embedded.attractions, id:\.name) { attraction in
                                        Text(attraction.name)
                                            .font(.title2)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    if let date = details.dates.start.date {
                                        HStack {
                                            Image(systemName: "calendar")
                                            Text(date)
                                        }
                                        .foregroundStyle(.blue)
                                    }
                                    
                                    // Location section
                                    VStack(alignment: .leading) {
                                        Text("Lokalizacja")
                                            .font(.headline)
                                        
                                        ForEach(details.embedded.venues, id:\.name){ venue in
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(venue.name)
                                                    .font(.title3)
                                                    .fontWeight(.bold)
                                                Text(venue.address.line1)
                                                Text(venue.city.name + ", " + venue.country.name)
                                            }
                                            .foregroundStyle(.secondary)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        VStack(alignment: .leading) {
                                            Text("Gatunek")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                            ForEach(details.classifications, id: \.genre.name) { classification in
                                                if classification.primary {
                                                    HStack{
                                                        Text(classification.segment.name + "/" + classification.genre.name)
                                                    }
                                                }
                                            }
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Ceny")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                            ForEach(details.priceRanges ?? [], id:\.type) { price in
                                                HStack{
                                                    Text(price.type + ": \(price.min) - \(price.max) PLN")
                                                }
                                            }
                                        }
                                    }
                                    
                                    //SeatMap
                                    if let staticURL = details.seatmap?.staticUrl {
                                        VStack(alignment: .leading) {
                                            Text("Plan miejsc*")
                                                .font(.headline)
                                            Text("Zdjęcie poglądowe")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            AsyncImage(url: URL(string: staticURL)) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(maxWidth: .infinity)
                                        }
                                    }
                                }
                                .padding()
                            }
                            Spacer()
                        }
                    }
                }
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

#Preview {
    EventDetailsView(eventID: "Z698xZQpZaFrK")
        
}
