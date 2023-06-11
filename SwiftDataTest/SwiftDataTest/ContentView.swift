//
//  ContentView.swift
//  SwiftDataTest
//
//  Created by Omeir on 09/06/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment (\.modelContext) private var context
    
    @Query(FetchDescriptor(
        predicate: #Predicate { $0.isLiked == true },
        sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]),
        animation: .snappy) private var favourites: [Person]
    @Query(FetchDescriptor(
        predicate: #Predicate { $0.isLiked == false },
        sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]),
        animation: .snappy) private var notFavourites: [Person]
    var body: some View {
        NavigationStack {
            List {
                DisclosureGroup("Favourites") {
                    ForEach(favourites) { person in
                        HStack {
                            Text(person.name)
                            Spacer()
                            Button {
                                person.isLiked.toggle()
                                //try? context.save()
                            } label: {
                                Image(systemName: "suit.heart.fill")
                                    .tint(.red)
                            }
                        }
                        .swipeActions {
                            Button {
                                context.delete(person)
                                try? context.save()
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                            .tint(.red)

                        }
                    }
                }
                
                DisclosureGroup("Not Favourites") {
                    ForEach(notFavourites) { person in
                        HStack {
                            Text(person.name)
                            Spacer()
                            Button {
                                person.isLiked.toggle()
                                try? context.save()
                            } label: {
                                Image(systemName: "suit.heart.fill")
                                    .tint(.gray)
                            }
                        }
                        .swipeActions {
                            Button {
                                context.delete(person)
                                try? context.save()
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                            .tint(.red)

                        }
                    }
                }
            }
            .navigationTitle("Swift Data")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Item") {
                        let person = Person(name: "User \(UUID().uuidString.prefix(10))")
                        context.insert(person)
                        do {
                            try context.save()
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }
            })
        }
    }
}

#Preview {
    ContentView()
}

@Model
class Person {
    let name: String
    var isLiked: Bool
    let dateAdded: Date
    
    init(name: String, isLiked: Bool = false, dateAdded: Date = .init()) {
        self.name = name
        self.isLiked = isLiked
        self.dateAdded = dateAdded
        
    }
}
