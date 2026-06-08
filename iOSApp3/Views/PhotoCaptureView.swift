//
//  PhotoCaptureView.swift
//  iOSApp3
//
//  Created by MD FAIAZ on 2026-06-08.
//

import SwiftUI
import PhotosUI

struct PhotoCaptureView: View {
    @EnvironmentObject var vm: HuntVM
    let itemID: UUID
    let onSaved: () -> Void

    @State private var selection: PhotosPickerItem?
    @State private var isSaving = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("Add Photo Proof").font(.title3).bold()
            Text("Choose a photo of the found item to mark this location as found.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            PhotosPicker(selection: $selection, matching: .images) {
                HStack {
                    Image(systemName: "photo.on.rectangle.angled")
                    Text("Choose Photo").bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            if isSaving { ProgressView("Saving…") }
            if let errorMessage { Text(errorMessage).foregroundStyle(.red) }
        }
        .onChange(of: selection) { _, newValue in
            guard let newValue else { return }
            isSaving = true
            Task {
                do {
                    if let data = try await newValue.loadTransferable(type: Data.self) {
                        vm.savePhoto(data, for: itemID)
                        onSaved()
                    } else {
                        errorMessage = "Couldn’t read image data."
                    }
                } catch {
                    errorMessage = error.localizedDescription
                }
                isSaving = false
            }
        }
    }
}
