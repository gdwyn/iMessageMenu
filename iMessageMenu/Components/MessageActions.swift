//
//  ActionMenuView.swift
//  iMessageMenu
//
//  Created by Godwin IE on 19/04/2025.
//


import SwiftUI

struct MessageActions: View {
    var onReply: () -> Void
    var onCopy: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onReply) {
                HStack {
                    Text("Reply")
                    Spacer()
                    Image(systemName: "arrowshape.turn.up.left")
                }
                .padding()
            }
            .background(Color(.systemGray6))

            Divider()

            Button(action: onCopy) {
                HStack {
                    Text("Copy")
                    Spacer()
                    Image(systemName: "square.on.square")
                }
                .padding()
            }
            .background(Color(.systemGray6))
        }
        .foregroundStyle(.textBlack)
        .frame(width: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
//        .shadow(radius: 4)
    }
}
