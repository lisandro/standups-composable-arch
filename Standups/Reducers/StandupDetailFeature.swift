//
//  StandupDetailFeature.swift
//  Standups
//
//  Created by Lisandro Falconi on 05/09/2023.
//

import ComposableArchitecture
import Foundation

struct StandupDetailFeature: Reducer {
    struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        @PresentationState var editStandup: StandupFormFeature.State?
        var standup: Standup
    }
    
    enum Action: Equatable {
        case alert(PresentationAction<Alert>)
        case cancelEditStandupButtonTapped
        case delegate(Delegate)
        case deleteButtonTapped
        case deleteMeetings(atOffsets: IndexSet)
        case editButtonTapped
        case editStandup(PresentationAction<StandupFormFeature.Action>)
        case saveStandupButtonTapped
        enum Delegate: Equatable {
         case standupUpdated(Standup)
        }
        enum Alert {
            case confirmDeletion
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            case .deleteButtonTapped:
                state.alert = AlertState(title: {
                    TextState("You sure?")
                }, actions: {
                    ButtonState(role: .destructive, action: .confirmDeletion) {
                        TextState("Delete")
                    }
                })
                return .none
            case .deleteMeetings(atOffsets: let indices):
                state.standup.meetings.remove(atOffsets: indices)
                return .none
            case .editButtonTapped:
                state.editStandup = StandupFormFeature.State(standup: state.standup)
                return .none
            case .editStandup:
                return .none
            case .cancelEditStandupButtonTapped:
                state.editStandup = nil
                return .none
            case .saveStandupButtonTapped:
                guard let standup = state.editStandup?.standup else { return .none }
                state.standup = standup
                state.editStandup = nil
                return .none
            case .alert(.presented(.confirmDeletion)):
                // TODO: Delete this standup
                return .none
            case .alert(.dismiss):
                return .none
            }
        }
        .ifLet(\.$editStandup, action: /Action.editStandup) {
            StandupFormFeature()
        }
        .onChange(of: \.standup) { oldValue, newValue in
            Reduce { state, action in
                    .send(.delegate(.standupUpdated(newValue)))
            }
        }
    }
    
}
