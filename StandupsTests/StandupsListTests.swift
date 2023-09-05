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
        
        
        await store.send(.addButtonTapped) {
            $0.addStandup = StandupFormFeature.State(
                standup: Standup(id: UUID(0),
                                 attendees: [.init(id: UUID(1))]
                                )
            )
        }
    }
    
}
