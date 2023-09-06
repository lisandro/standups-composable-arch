//
//  StandupDetailView.swift
//  StandupsTests
//
//  Created by Lisandro Falconi on 06/09/2023.
//

import ComposableArchitecture
import XCTest
@testable import Standups

@MainActor
final class StandupDetailView: XCTestCase {
    func testEditStandup() async {
        var standup = Standup.mock
        
        let store = TestStore(
            initialState: StandupDetailFeature.State(standup: standup)
        ) {
            StandupDetailFeature()
        }
        store.exhaustivity = .off
        
        await store.send(.editButtonTapped) {
            $0.editStandup = StandupFormFeature.State(standup: standup)
        }
        
        standup.title = "Lisandro's Daily standup meeting"
        
        await store.send(.editStandup(.presented(.set(\.$standup, standup)))) {
            $0.editStandup?.standup.title = "Lisandro's Daily standup meeting"
        }
        
        await store.send(.saveStandupButtonTapped) {
            $0.standup.title = "Lisandro's Daily standup meeting"
        }
        
    }
}
