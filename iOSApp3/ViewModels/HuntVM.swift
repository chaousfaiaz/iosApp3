//
//  HuntVM.swift
//  iOSApp2
//
//  Created by Kenneth Plumstead on 2025-10-02.
//

import Foundation
import Combine
import UIKit

final class HuntVM: ObservableObject {
    @Published var items: [HuntItem] = sampleItems
    private let store = FoundStore()

    init() {
        // Rehydrate from disk on launch
        let found = store.foundIDs
        for i in items.indices {
            if found.contains(items[i].id),
               let image = store.loadPhoto(for: items[i].id),
               let data = image.jpegData(compressionQuality: 0.9) {
                items[i].photoData = data
            }
        }
    }

    var foundCount: Int { items.filter { $0.isFound }.count }

    enum Reward { case none, tenPercent, twentyPercent, twentyPlusDraw }

    func reward() -> Reward {
        switch foundCount {
        case 10: return .twentyPlusDraw
        case 7...9: return .twentyPercent
        case 5...6: return .tenPercent
        default: return .none
        }
    }

    func rewardMessage(for reward: Reward) -> String {
        switch reward {
        case .twentyPlusDraw:
            return "Congrats! You earned a 20% discount and you're entered into the $5000 grand prize draw!"
        case .twentyPercent:
            return "Congrats! You earned a 20% discount code!"
        case .tenPercent:
            return "Congrats! You earned a 10% discount code!"
        case .none:
            return "Keep going! Find at least 5 items to unlock a discount."
        }
    }

    func savePhoto(_ data: Data, for id: HuntItem.ID) {
        do {
            try store.savePhoto(data, for: id)
            if let idx = items.firstIndex(where: { $0.id == id }) {
                items[idx].photoData = data
            }
        } catch {
            if let idx = items.firstIndex(where: { $0.id == id }) {
                items[idx].photoData = data
            }
        }
    }

    func item(with id: HuntItem.ID) -> HuntItem? {
        items.first(where: { $0.id == id })
    }
}
