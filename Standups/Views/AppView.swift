//
//  AppView.swift
//  Standups
//
//  Created by Lisandro Falconi on 11/12/2023.
//
import ComposableArchitecture
import SwiftUI

struct AppFeature: Reducer {
    struct State {
        var standupsList = StandupsListFeature.State()
    }
    
    enum Action {
        case standupsList(StandupsListFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.standupsList, action: /Action.standupsList) {
            StandupsListFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .standupsList:
                return .none
            }
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>
    var body: some View {
        NavigationStack {
            StandupsListView(
                store: store.scope(
                    state: \.standupsList,
                    action: { childAction in
                            .standupsList(childAction)
                    }))
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State()){
        AppFeature()
    })
}
