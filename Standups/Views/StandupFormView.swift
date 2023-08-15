//
//  StandupFormView.swift
//  Standups
//
//  Created by Lisandro Falconi on 10/08/2023.
//
import ComposableArchitecture
import SwiftUI

struct StandupFormView: View {
    let store: StoreOf<StandupFormFeature>
    @FocusState var focus: StandupFormFeature.State.Field?
    // TODO: Simplify with iOS 17
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    TextField("Title", text: viewStore.$standup.title).focused(self.$focus, equals: .title)
                    HStack {
                        Slider(value: viewStore.$standup.duration.minutes, in: 5...30) {
                            Text("Length")
                        }
                        Spacer()
                        Text(viewStore.standup.duration.formatted(.units()))
                    }
                    ThemePicker(selection: viewStore.$standup.theme)
                } header: {
                    Text("Standup Info")
                }
                
                Section {
                    ForEach(viewStore.$standup.attendees) { $attendee in
                        TextField("Name", text: $attendee.name)
                            .focused(self.$focus, equals: .attendee(attendee.id))
                    }
                    .onDelete(perform: { indexSet in
                        viewStore.send(.deleteAttendees(atOffsets: indexSet))
                    })
                    
                    Button("Add attendee") {
                        viewStore.send(.addAttendeeButtonTapped)
                    }
                } header: {
                    Text("Attendees")
                }
            }
            .bind(viewStore.$focus, to: self.$focus)
        }
    }
}

extension Duration {
    fileprivate var minutes: Double {
        get { Double(self.components.seconds / 60 ) }
        set { self = .seconds(newValue * 60)}
    }
}

#Preview {
    StandupFormView(store: Store(initialState: StandupFormFeature.State(standup: .mock), reducer: {
        StandupFormFeature()
    }))
}
