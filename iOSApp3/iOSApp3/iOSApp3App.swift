//
//  iOSApp2App.swift
//  iOSApp2
//
//  Created by Kenneth Plumstead on 2025-10-02.
//

import SwiftUI

@main
struct iOSApp2App: App {
    @StateObject private var vm = HuntVM()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}
