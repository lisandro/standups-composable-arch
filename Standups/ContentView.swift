//
//  ContentView.swift
//  Standups
//
//  Created by Lisandro Falconi on 09/08/2023.
//
import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    var store: StoreOf<StandupsListFeature>
    var body: some View {
        WithViewStore(self.store, observe: \.standups) { viewStore in
            List {
                ForEach(viewStore.state) { standup in
                    CardView(standup: standup)
                        .listRowBackground(standup.theme.mainColor)
                }
            }
            .navigationTitle("Daily Standups")
            .toolbar {
                ToolbarItem {
                    Button("Add") {
                        viewStore.send(.addButtonTapped)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView(store: Store(initialState: StandupsListFeature.State(standups: [.mock]), reducer: {
                StandupsListFeature()
            }))
        }
    }
}

