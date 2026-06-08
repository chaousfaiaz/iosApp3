//
//  ContentView.swift
//  iOSApp2
//
//  Created by Kenneth Plumstead on 2025-10-02.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: HuntVM
    private let svc = LocationService()

    @State private var loading = false
    @State private var loadError: String?

    var body: some View {
        NavigationStack {
            List {
                if let loadError {
                    Text(loadError).foregroundStyle(.red)
                }
                Section {
                    ForEach(vm.items) { item in
                        NavigationLink(value: item) {
                            HStack(spacing: 12) {
                                Image(systemName: item.isFound ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(item.isFound ? .green : .secondary)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name).font(.headline)
                                    Text(item.clue).lineLimit(1).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(item.isFound ? "Found" : "Find")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                } header: {
                    Text("Progress: \(vm.foundCount)/\(vm.items.count) found")
                }
            }
            .navigationTitle("Scavenger Hunt")
            .navigationDestination(for: HuntItem.self) { item in
                ClueDetailView(item: item)
            }
            .refreshable {
                loading = true
                defer { loading = false }
                do {
                    vm.items = try svc.loadFromBundle() // optional JSON bundle
                } catch {
                    loadError = "Couldn’t load locations."
                }
            }
            .overlay { if loading { ProgressView("Refreshing…") } }
            .safeAreaInset(edge: .bottom) {
                SubmitBar()
            }
        }
    }
}

private struct SubmitBar: View {
    @EnvironmentObject var vm: HuntVM
    @State private var showing = false
    @State private var message = ""

    var body: some View {
        Button {
            let r = vm.reward()
            message = vm.rewardMessage(for: r)
            showing = true
        } label: {
            HStack {
                Image(systemName: "paperplane.fill")
                Text("Submit Results").bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .buttonStyle(.borderedProminent)
        .padding(.horizontal)
        .padding(.top, 8)
        .background(.thinMaterial)
        .alert("Results", isPresented: $showing) {
            Button("OK", role: .cancel) { }
        } message: { Text(message) }
    }
}

#Preview {
    ContentView()
        .environmentObject(HuntVM())
}
