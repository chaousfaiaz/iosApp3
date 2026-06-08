//
//  BusinessMap.swift
//  iOSApp3
//
//  Created by MD FAIAZ on 2026-06-08.
//

import SwiftUI
import MapKit

struct BusinessMap: View {
    let coordinate: CLLocationCoordinate2D

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate,
                           span: .init(latitudeDelta: 0.005, longitudeDelta: 0.005))
    }

    var body: some View {
        Map(initialPosition: .region(region)) {
            Marker("Location", coordinate: coordinate)
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(.secondary.opacity(0.25))
        }
    }
}
