//
//  StandupFormView.swift
//  Standups
//
//  Created by Lisandro Falconi on 10/08/2023.
//

import SwiftUI

struct StandupFormView: View {
    var attendees: [Attendee] = []
    @State var text: String = ""
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $text)
                HStack {
                    Slider(value: 5, in: 5...30) {
                        Text("Length")
                    }
                    Spacer()
                    Text("5 min")
                }
                //ThemePicker(selection: .bubblegum)
            } header: {
                Text("Standup Info")
            }
            
            Section {
                ForEach(attendees) { $attendee in
                    TextField("Name", text: $attendee.name)
                }
                .onDelete(perform: { indexSet in
                    
                })
                
                Button("Add attendee") {
                    
                }
            } header: {
                Text("Attendees")
            }
        }
    }
}

#Preview {
    StandupFormView()
}
