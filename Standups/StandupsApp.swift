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
            ContentView(store: Store(initialState: StandupsListFeature.State(), reducer: {
                StandupsListFeature()
            }))
        }
    }
}
