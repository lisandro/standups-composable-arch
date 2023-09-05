//
//  StandupsApp.swift
//  Standups
//
//  Created by Lisandro Falconi on 09/08/2023.
//
import ComposableArchitecture
import SwiftUI

@main
struct StandupsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(
                    store: Store(initialState: StandupsListFeature.State(
                        //Useful for deeplink addStandup: StandupFormFeature.State(focus: .attendee(Standup.mock.attendees[2].id), standup: .mock)
                    ),
                                 reducer: {
                                     StandupsListFeature()
                                 }))
            }
        }
    }
}
