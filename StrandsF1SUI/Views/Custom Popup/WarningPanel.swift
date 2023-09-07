//
//  WarningPanel.swift
//  ParisForecast (iOS)
//
//  Created by Christopher Alford on 22/2/22.
//

import SwiftUI

struct WarningPanel: View {

    static let MIN_HEIGHT: CGFloat = 52
    static let MAX_HEIGHT: CGFloat = 90

    @State private var height = CGFloat(MAX_HEIGHT)

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("Not connected")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.top, 18)
                .padding(.bottom, -4)
                HStack {
                    Spacer()
                    Text("Using saved info.")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding(.top, 30)
            .frame(height: height)
            .background(Color.red)
            .mask(CustomShape(radius: 25))
            .shadow(color: .gray, radius: 5, x: 0, y: 5)
            .edgesIgnoringSafeArea(.top)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        height = max(WarningPanel.MIN_HEIGHT, height + value.translation.height)
                        print(height)
                    }
            )
            Spacer()

        }

    }
}

struct WarningPanel_Previews: PreviewProvider {
    static var previews: some View {
        WarningPanel() //headline: "🤖 Danger Will Robinson", text: "Wildly waving arms")
    }
}
