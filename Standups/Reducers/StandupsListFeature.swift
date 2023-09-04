//
//  StandupsListFeature.swift
//  Standups
//
//  Created by Lisandro Falconi on 09/08/2023.
//

import ComposableArchitecture
import Foundation

struct StandupsListFeature: Reducer {
    struct State {
        @PresentationState var addStandup: StandupFormFeature.State?
        var standups: IdentifiedArrayOf<Standup> = []
    }
    
    enum Action {
        case addButtonTapped
        case addStandup(PresentationAction<StandupFormFeature.Action>)
    }
    
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addStandup = StandupFormFeature.State(standup: Standup(id: self.uuid()))
                return .none
            case .addStandup:
                return .none
            }
        }
        .ifLet(\.$addStandup, action: /Action.addStandup) {
            StandupFormFeature()
        }
    }
}

