//
//  iOSApp2App.swift
//  iOSApp2
//
//  Created by MD FAIAZ on 2026-06-08.
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
