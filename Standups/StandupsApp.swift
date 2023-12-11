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
        var editedStandup = Standup.mock
        let _ = editedStandup.title += " Morning Sync"
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppFeature.State(
                        path: StackState([
                            .detail(StandupDetailFeature.State(
                                editStandup: StandupFormFeature.State(focus: .attendee(editedStandup.attendees[3].id),
                                                                      standup: editedStandup),
                                standup: .mock))
                        ]), standupsList: StandupsListFeature.State(standups: [.mock]))){
                            AppFeature()
                        })
        }
    }
}
