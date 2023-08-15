//
//  StandupFormTest.swift
//  StandupsTests
//
//  Created by Lisandro Falconi on 15/08/2023.
//

import ComposableArchitecture
import XCTest
@testable import Standups

@MainActor
final class StandupFormTests: XCTestCase {
    func testAddDeleteAttendee() async {
        let store = TestStore(initialState: StandupFormFeature.State(focus: nil,
                                                                     standup: .init(id: UUID(), attendees: [Attendee(id: UUID())])
                                                                    )
        ) {
            StandupFormFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.addAttendeeButtonTapped) {
            let id = UUID(0)
            $0.focus = .attendee(Attendee(id: id).id)
            $0.standup.attendees.append(Attendee(id: id))
        }
        
        await store.send(.deleteAttendees(atOffsets: [1])) {
            $0.focus = .attendee($0.standup.attendees[0].id)
            $0.standup.attendees.remove(atOffsets: [1])
        }
    }
}
