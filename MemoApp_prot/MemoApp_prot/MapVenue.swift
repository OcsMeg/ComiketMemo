/// マップ画面で切り替えられる館。
/// 新しい館を追加するときはcaseを増やし、titleとblockLayoutsに対応Viewを紐づける。
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
        // メモ照合にも使うため、表示Viewとは別に生成済みレイアウト配列を公開する。
        switch self {
        case .east123:
            return Summer2026Day1East123MapView.blockLayouts
        case .west:
            return Summer2026Day1WestMapView.blockLayouts
        }
    }
}
