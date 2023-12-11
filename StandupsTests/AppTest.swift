//
//  AppTest.swift
//  StandupsTests
//
//  Created by Lisandro Falconi on 11/12/2023.
//
import ComposableArchitecture
import XCTest
@testable import Standups

@MainActor
final class AppTest: XCTestCase {
    func testEdit() async {
        let standup = Standup.mock
        let store = TestStore(initialState: AppFeature.State(standupsList: .init(standups: [standup]))) {
            AppFeature()
        }
        
        await store.send(.path(.push(id: 0, state: .detail(.init(standup: standup))))) { state in
            state.path[id: 0] = .detail(.init(standup: standup))
        }
        
        await store.send(.path(.element(id: 0, action: .detail(.editButtonTapped)))) { state in
            state.path[id: 0, case: /AppFeature.Path.State.detail]?.editStandup = StandupFormFeature.State(standup: standup)
        }
        
        var editedStandup = standup
        editedStandup.title = "Modified standup sync"
        
        await store.send(.path(.element(id: 0, action: .detail(.editStandup(.presented(.set(\.$standup, editedStandup))))))) { state in
            state.path[id: 0, case: /AppFeature.Path.State.detail]?.editStandup?.standup.title = "Modified standup sync"
        }
        
        
        await store.send(.path(.element(id: 0, action: .detail(.saveStandupButtonTapped)))) { state in
            state.path[id: 0, case: /AppFeature.Path.State.detail]?.editStandup = nil
            state.path[id: 0, case: /AppFeature.Path.State.detail]?.standup.title = "Modified standup sync"
        }
        
        await store.receive(.path(.element(id: 0, action: .detail(.delegate(.standupUpdated(editedStandup)))))) {
            $0.standupsList.standups[0].title = "Modified standup sync"
        }
    }
    
    
    func testEdit_NonExhaustive() async {
        let standup = Standup.mock
        let store = TestStore(initialState: AppFeature.State(standupsList: .init(standups: [standup]))) {
            AppFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.path(.push(id: 0, state: .detail(.init(standup: standup))))) { state in
            state.path[id: 0] = .detail(.init(standup: standup))
        }
        
        await store.send(.path(.element(id: 0, action: .detail(.editButtonTapped)))) { state in
            state.path[id: 0, case: /AppFeature.Path.State.detail]?.editStandup = StandupFormFeature.State(standup: standup)
        }
        
        var editedStandup = standup
        editedStandup.title = "Modified standup sync"
        
        await store.send(.path(.element(id: 0, action: .detail(.editStandup(.presented(.set(\.$standup, editedStandup)))))))
        await store.send(.path(.element(id: 0, action: .detail(.saveStandupButtonTapped))))
        await store.receive(.path(.element(id: 0, action: .detail(.delegate(.standupUpdated(editedStandup)))))) {
            $0.standupsList.standups[0].title = "Modified standup sync"
        }
    }
    
    func testEdit_NonExhaustive_Alternative() async {
        let standup = Standup.mock
        let store = TestStore(initialState: AppFeature.State(standupsList: .init(standups: [standup]))) {
            AppFeature()
        }
        
        store.exhaustivity = .off
        
        await store.send(.path(.push(id: 0, state: .detail(.init(standup: standup))))) { state in
            state.path[id: 0] = .detail(.init(standup: standup))
        }
        
        await store.send(.path(.element(id: 0, action: .detail(.editButtonTapped)))) { state in
            state.path[id: 0, case: /AppFeature.Path.State.detail]?.editStandup = StandupFormFeature.State(standup: standup)
        }
        
        var editedStandup = standup
        editedStandup.title = "Modified standup sync"
        
        await store.send(.path(.element(id: 0, action: .detail(.editStandup(.presented(.set(\.$standup, editedStandup)))))))
        await store.send(.path(.element(id: 0, action: .detail(.saveStandupButtonTapped))))
        await store.skipReceivedActions()
        store.assert { state in
            state.standupsList.standups[0].title = "Modified standup sync"
        }
    }
    
}
