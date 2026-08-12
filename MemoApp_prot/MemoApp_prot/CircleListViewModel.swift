import Foundation
import Combine
import SwiftUI

// 「今どのシートを出しているか」を1つにまとめる
enum ActiveSheet: Identifiable, Equatable {
    case add
    case detail(CircleInfo)

    var id: String {
        switch self {
        case .add:
            return "add"
        case .detail(let circle):
            return "detail-\(circle.id.uuidString)"
        }
    }
}

// 今どの画面を出すかの状態管理と操作
@MainActor
final class CircleListViewModel: ObservableObject {
    @Published var circles: [CircleInfo] = sampleData
    @Published var activeSheet: ActiveSheet? = nil
    @Published var showMap: Bool = false

    func openAdd() {
        activeSheet = .add
    }

    func openDetail(_ circle: CircleInfo) {
        activeSheet = .detail(circle)
    }

    func openMap() {
        showMap = true
    }

    func closeSheet() {
        activeSheet = nil
    }

    func closeMap() {
        showMap = false
    }
    
    func sortByPriority() {
        let priorityOrder = ["高", "中", "低"]
        circles.sort {
            guard let i0 = priorityOrder.firstIndex(of: $0.priority),
                  let i1 = priorityOrder.firstIndex(of: $1.priority) else { return false }
            return i0 < i1
        }
    }
    
    func delete(at offsets: IndexSet) {
        circles.remove(atOffsets: offsets)
    }
}
