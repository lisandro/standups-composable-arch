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
            AppView(store: Store(initialState: AppFeature.State()){
                AppFeature()
            })
        }
    }
}
