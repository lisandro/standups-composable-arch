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
        var standups: IdentifiedArrayOf<Standup> = []
    }
    
    enum Action {
        case addButtonTapped
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.standups.append(Standup(id: UUID(), theme: .allCases.randomElement()!))
                return .none
            }
        }
    }
}

