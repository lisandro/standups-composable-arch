//
//  ContentView.swift
//  Standups
//
//  Created by Lisandro Falconi on 09/08/2023.
//
import ComposableArchitecture
import SwiftUI

struct StandupsListView: View {
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
            .sheet(
                store: self.store.scope(
                    state: \.$addStandup,
                    action: { .addStandup($0) }
                ),
                content: { store in
                    NavigationStack {
                        StandupFormView(store: store)
                            .navigationTitle("New standup")
                            .toolbar {
                                ToolbarItem {
                                    Button("Save") {
                                        viewStore.send(.saveStandupButtonTapped)
                                    }
                                }
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancel") {
                                        viewStore.send(.cancelStandupButtonTapped)
                                    }
                                }
                            }
                    }
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            StandupsListView(store: Store(initialState: StandupsListFeature.State(standups: [.mock]), reducer: {
                StandupsListFeature()
            }))
        }
    }
}

