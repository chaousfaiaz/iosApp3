//
//  FlippableCard.swift
//  iOSApp2
//
//  Created by Kenneth Plumstead on 2025-10-02.
//

import SwiftUI

struct FlippableCard<Front: View, Back: View>: View {
    @Binding var flipped: Bool
    let front: Front
    let back: Back

    init(flipped: Binding<Bool>, @ViewBuilder front: () -> Front, @ViewBuilder back: () -> Back) {
        self._flipped = flipped
        self.front = front()
        self.back = back()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            ZStack {
                front.opacity(flipped ? 0 : 1)
                back.opacity(flipped ? 1 : 0)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
            .padding()
        }
        .rotation3DEffect(.degrees(flipped ? 180 : 0),
                          axis: (x: 0, y: 1, z: 0),
                          perspective: 0.75)
        .animation(.easeInOut(duration: 0.35), value: flipped)
    }
}
