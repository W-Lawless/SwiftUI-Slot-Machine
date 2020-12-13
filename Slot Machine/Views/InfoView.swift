//
//  InfoView.swift
//  Slot Machine
//
//  Created by W Lawless on 12/12/20.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            Spacer()
            Form {
                Section(header: Text("About the Application")) {
                    FormRowView(firstItem: "Developer", secondItem: "Lawless Sharpe")
                    FormRowView(firstItem: "Company Website", secondItem: "Aureus.us")
                }
            }
            .font(.system(.body, design: .rounded))
        } //:VSTQ
        .padding(.top, 40)
        .overlay(
        Button(action: {
            //Action
            audioPlayer?.stop()
            self.presentationMode.wrappedValue.dismiss()
        }) {
        Image(systemName: "xmark.circle")
        .font(.title)
        }
        .padding(.top, 10)
        .padding(.trailing, 20)
        .accentColor(Color.secondary)
        , alignment: .topTrailing
        )
        .onAppear(perform: {
            playSound(sound: "background-music", type: ".mp3")
        })
    } //: BODY
}

struct FormRowView: View {
    var firstItem: String
    var secondItem: String
    
    var body: some View {
        HStack {
            Text("\(firstItem)").foregroundColor(Color.gray)
            Spacer()
            Text("\(secondItem)")
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
