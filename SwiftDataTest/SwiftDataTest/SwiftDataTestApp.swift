//
//  SwiftDataTestApp.swift
//  SwiftDataTest
//
//  Created by Omeir on 09/06/2023.
//

import SwiftUI

@main
struct SwiftDataTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Person.self)
    }
}
