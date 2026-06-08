//
//  LocationService.swift
//  iOSApp2
//
//  Created by Kenneth Plumstead on 2025-10-09.
//

import Foundation
import CoreLocation

struct RemoteLocation: Decodable {
    let name: String
    let clue: String
    let lat: Double
    let lon: Double
}

enum LocationServiceError: Error { case notFound, decode }

struct LocationService {
    func loadFromBundle() throws -> [HuntItem] {
        guard let url = Bundle.main.url(forResource: "locations", withExtension: "json")
        else { throw LocationServiceError.notFound }
        let data = try Data(contentsOf: url)
        let decoded = try JSONDecoder().decode([RemoteLocation].self, from: data)
        return decoded.map {
            HuntItem(name: $0.name,
                     clue: $0.clue,
                     coordinate: CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon))
        }
    }
}
