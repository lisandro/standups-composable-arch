//
//  StandupFormFeature.swift
//  Standups
//
//  Created by Lisandro Falconi on 14/08/2023.
//
import ComposableArchitecture
import Foundation

struct StandupFormFeature: Reducer {
    struct State: Equatable {
        @BindingState var focus: Field?
        @BindingState var standup: Standup //@BindingState to learn more
        
        enum Field: Hashable {
            case attendee(Attendee.ID)
            case title
        }
        
        init(focus: Field? = nil, standup: Standup) {
            self.focus = focus
            self.standup = standup
            
            if self.standup.attendees.isEmpty {
                @Dependency(\.uuid) var uuid
                self.standup.attendees.append(Attendee(id: uuid()))
            }
        }
    }
    
    enum Action: BindableAction {
        case addAttendeeButtonTapped
        case deleteAttendees(atOffsets: IndexSet)
        case binding(BindingAction<State>)
        /*
         binding to replace repetitive action cases
         case setTitle(String)
         case setDuration(Duration)
         case setTheme(Theme)
         */
    }
    
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<Self> {
        BindingReducer()
            .onChange(of: \.standup.title) { oldValue, newValue in
                // state mutation or effects
            }
        
        Reduce { state, action in
            switch action {
                
            case .addAttendeeButtonTapped:
                let id = uuid()
                state.standup.attendees.append(Attendee(id: id))
                state.focus = .attendee(id)
                return .none
            case let .deleteAttendees(atOffsets: indices):
                state.standup.attendees.remove(atOffsets: indices)
                if state.standup.attendees.isEmpty {
                    state.standup.attendees.append(Attendee(id: uuid()))
                }
                
                guard let firstIndex = indices.first else { return .none }
                
                let index = min(firstIndex, state.standup.attendees.count - 1)
                state.focus = .attendee(state.standup.attendees[index].id)
                return .none
            case .binding(_):
                // Manage by BindingReducer
                return .none
            }
        }
    }
}
