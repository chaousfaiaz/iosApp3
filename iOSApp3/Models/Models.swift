//
//  Models.swift
//  iOSApp2
//
//  Created by Kenneth Plumstead on 2025-10-02.
//

import Foundation
import CoreLocation

struct HuntItem: Identifiable {
    let id = UUID()
    let name: String
    let clue: String
    let coordinate: CLLocationCoordinate2D
    var photoData: Data? = nil

    var isFound: Bool { photoData != nil }
}

extension HuntItem: Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
extension HuntItem: Equatable {
    static func == (lhs: HuntItem, rhs: HuntItem) -> Bool { lhs.id == rhs.id }
}
