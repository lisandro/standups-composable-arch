//
//  StandupsListTests.swift
//  StandupsTests
//
//  Created by Lisandro Falconi on 05/09/2023.
//
import ComposableArchitecture
import XCTest
@testable import Standups

@MainActor
final class StandupsListTests: XCTestCase {
    
    func testAddStandup() async {
        let store = TestStore(initialState: StandupsListFeature.State(), reducer: {
            StandupsListFeature()
        }, withDependencies: {
            $0.uuid = .incrementing
        })
        
        var standup: Standup = Standup(
            id: UUID(0),
            attendees: [.init(id: UUID(1))]
        )
        await store.send(.addButtonTapped) {
            $0.addStandup = StandupFormFeature.State(
                standup: standup
            )
        }
        
        standup.title = "Lisandro's Team Morning Sync"
        await store.send(.addStandup(.presented(.set(\.$standup, standup)))) {
            $0.addStandup?.standup.title = "Lisandro's Team Morning Sync"
        }
        
        await store.send(.saveStandupButtonTapped) {
            $0.standups[0] = Standup(
                id: UUID(0),
                attendees: [.init(id: UUID(1))],
                title: "Lisandro's Team Morning Sync"
            )
            $0.addStandup = nil
        }
    }
    
    func testAddStandup_NonExhaustive() async {
        let store = TestStore(initialState: StandupsListFeature.State(), reducer: {
            StandupsListFeature()
        }, withDependencies: {
            $0.uuid = .incrementing
        })
        
        store.exhaustivity = .off(showSkippedAssertions: true)
        
        var standup: Standup = Standup(
            id: UUID(0),
            attendees: [.init(id: UUID(1))]
        )
        await store.send(.addButtonTapped)
        standup.title = "Lisandro's Team Morning Sync"
        await store.send(.addStandup(.presented(.set(\.$standup, standup))))
        await store.send(.saveStandupButtonTapped) {
            $0.standups[0] = Standup(
                id: UUID(0),
                attendees: [.init(id: UUID(1))],
                title: "Lisandro's Team Morning Sync"
            )
        }
    }
}
