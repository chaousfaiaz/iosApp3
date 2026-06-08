//
//  FoundStore.swift
//  iOSApp3
//
//  Created by MD FAIAZ on 2026-06-08.
//

import Foundation
import UIKit

final class FoundStore {
    private let defaults = UserDefaults.standard
    private let keyFoundIDs = "found_item_ids"
    private let keyPhotoPathPrefix = "photo_path_" // + id.uuidString

    var foundIDs: Set<UUID> {
        get { Set((defaults.stringArray(forKey: keyFoundIDs) ?? []).compactMap(UUID.init(uuidString:))) }
        set { defaults.set(newValue.map(\.uuidString), forKey: keyFoundIDs) }
    }

    func photoPath(for id: UUID) -> String? {
        defaults.string(forKey: keyPhotoPathPrefix + id.uuidString)
    }
    private func setPhotoPath(_ path: String?, for id: UUID) {
        defaults.set(path, forKey: keyPhotoPathPrefix + id.uuidString)
    }

    func savePhoto(_ data: Data, for id: UUID) throws {
        let url = try write(data: data, fileName: "\(id.uuidString).jpg")
        setPhotoPath(url.lastPathComponent, for: id)
        foundIDs.insert(id)
    }

    func loadPhoto(for id: UUID) -> UIImage? {
        guard let name = photoPath(for: id) else { return nil }
        let url = docsURL().appendingPathComponent(name)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    private func docsURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    private func write(data: Data, fileName: String) throws -> URL {
        let url = docsURL().appendingPathComponent(fileName)
        try data.write(to: url, options: .atomic)
        return url
    }
}
