//
//  ClueDetailView.swift
//  iOSApp2
//
//  Created by Kenneth Plumstead on 2025-10-02.
//

import SwiftUI
import MapKit

struct ClueDetailView: View {
    @EnvironmentObject var vm: HuntVM
    @Environment(\.dismiss) private var dismiss

    let item: HuntItem
    @State private var flipped = false

    private func mapsURL(for item: HuntItem) -> URL {
        let q = "\(item.coordinate.latitude),\(item.coordinate.longitude)"
        return URL(string: "http://maps.apple.com/?daddr=\(q)&dirflg=w")! // walking directions
    }

    var body: some View {
        let current = vm.item(with: item.id) ?? item

        ScrollView {
            FlippableCard(flipped: $flipped) {
                // FRONT (map + clue + coordinates + directions)
                VStack(alignment: .leading, spacing: 16) {
                    BusinessMap(coordinate: current.coordinate)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(current.name).font(.title2).bold()
                        Text(current.clue).foregroundStyle(.secondary)
                    }

                    // Show the raw coordinates (part of “location API” usage)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Coordinates")
                            .font(.subheadline).bold()
                        Text(String(format: "Lat: %.6f, Lon: %.6f",
                                    current.coordinate.latitude,
                                    current.coordinate.longitude))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    // Optional: open Apple Maps for directions (no tracking; user-initiated)
                    Link(destination: mapsURL(for: current)) {
                        Label("Get Directions", systemImage: "map")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    if current.isFound {
                        Label("Already Found", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                    } else {
                        Button {
                            flipped = true
                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                Text("Mark as Found (add photo)").bold()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }

            } back: {
                // BACK (photo picker)
                PhotoCaptureView(itemID: current.id) { dismiss() }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
        .navigationTitle("Clue")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
