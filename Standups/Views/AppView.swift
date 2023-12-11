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
        var path = StackState<Path.State>()
        var standupsList = StandupsListFeature.State()
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case standupsList(StandupsListFeature.Action)
    }
    
    //Features that can be added to the stack
    struct Path: Reducer {
        enum State {
            case detail(StandupDetailFeature.State)
        }
        
        enum Action {
            case detail(StandupDetailFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.detail, action: /Action.detail) {
                StandupDetailFeature()
            }
        }
    }
    
    
    var body: some ReducerOf<Self> {
        Scope(state: \.standupsList, action: /Action.standupsList) {
            StandupsListFeature()
        }
        
        Reduce { state, action in
            switch action {
            // Not ideal way, because we need to know much about the child
                /*
            case let .path(.element(id: id, action: .detail(.saveStandupButtonTapped))):
                guard case let .some(.detail(detailState)) = state.path[id:id] else { return .none }
                state.standupsList.standups[id: detailState.standup.id] = detailState.standup
                return .none
                 */
            case let .path(.element(id: _, action: .detail(.delegate(action)))):
                switch action {
                case let .standupUpdated(standup):
                    state.standupsList.standups[id: standup.id] = standup
                    return .none
                }
            case .path:
                return .none
            case .standupsList:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: { childAction in
                .path(childAction)
        }), root: {
            StandupsListView(
                store: store.scope(
                    state: \.standupsList,
                    action: { childAction in
                            .standupsList(childAction)
                    }))
        }, destination: { initialState in
            // This way will change in iOS 17 and a new version of TCA
            switch initialState {
            case .detail :
                CaseLet(/AppFeature.Path.State.detail, action: AppFeature.Path.Action.detail) { store in
                    StandupDetailView(store: store)
                }
            }
        })
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State(standupsList: StandupsListFeature.State(standups: [.mock]))){
        AppFeature()
            ._printChanges()
    })
}
