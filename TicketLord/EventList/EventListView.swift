//
//  EventListView.swift
//  TicketLord
//
//  Created by Hubert Wojtowicz on 09/11/2024.
//

import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel = EventListViewModel()
    
    
    var body: some View {
        NavigationView {
            VStack {

                        
                    HStack {
                        Image("ticketLord")
                            .resizable()
                            .frame(width: 100, height: 60)
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 28))
                            .padding(.leading, 12)
                            .padding(.top, 10)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "cart")
                                .foregroundStyle(.white)
                                .padding()
                        }
                        Button(action: {}) {
                            Image(systemName: "person")
                                .foregroundStyle(.white)
                                .padding()
                        }
                    }
                    .frame(height: 80)
//                    .background(Color(red: 20, green: 21, blue: 18))
                    .background(Color(red: 20/255, green: 21/255, blue: 18/255))
                    .padding(.top, -20)
                
                HStack {
                    Text("Sortuj według:")
                        .padding(.leading, 12)
                    Spacer()
                    Picker("Sortuj", selection: $viewModel.sortOption) {
                        ForEach(viewModel.sortingOptions.sorted(by: { $0.value < $1.value }), id: \.key) {
                            Text($0.value)
                                .tag($0.key)
                        }
                    }
                    .padding(.trailing)
//                    Spacer()
                }
                
                ScrollView {
                    LazyVStack{
                        ForEach(viewModel.events) { event in
                            
                            VStack{
                                HStack {
                                    ZStack {
                                        AsyncImage(url: URL(string: viewModel.getImageURL(event: event))) { image in
                                            image
                                                .resizable()
                                                .frame(width: 120, height: 90)
                                                .scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 120, height: 90)
                                        }
                                    }
                                    .padding(.trailing, 5)
                                    .padding(.leading, 12)
                                    
                                    Spacer()
                                    
                                    VStack{
                                        HStack {
                                            Text(event.name)
                                                .padding(.trailing, 10)
                                                .font(.system(size: 16))
                                            Spacer()
                                        }
                                        
                                        Spacer()
                                        
                                        HStack{
                                            Text(viewModel.datePlace(event: event))
                                                .fontWeight(.light)
                                                .font(.system(size: 12))
                                                .foregroundStyle(Color.gray)
                                            Spacer()
                                        }
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .padding([.top, .bottom], 5)
                            Divider()
                                .onAppear {
                                    if event == viewModel.events.last {
                                        Task {
                                            await viewModel.loadEvents()
                                        }
                                    }
                                }
                            
                        }
                    }
                }
                .onAppear {
                    Task {
                        await viewModel.loadEvents(reset: true)
                    }
                }
                .onChange(of: viewModel.sortOption) {
                    Task {
                        await viewModel.loadEvents(reset: true)
                    }
                }
            }
        }
    }
}

#Preview {
    EventListView()
}
