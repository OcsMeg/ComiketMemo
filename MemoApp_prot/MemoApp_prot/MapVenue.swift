enum MapVenue: String, CaseIterable, Identifiable {
    case east123
    case west

    var id: String { rawValue }

    var title: String {
        switch self {
        case .east123:
            return "東館"
        case .west:
            return "西館"
        }
    }

    var blockLayouts: [BlockMapLayout] {
        switch self {
        case .east123:
            return Summer2026Day1East123MapView.blockLayouts
        case .west:
            return Summer2026Day1WestMapView.blockLayouts
        }
    }
}
