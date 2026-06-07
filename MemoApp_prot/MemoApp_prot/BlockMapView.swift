import SwiftUI

// MARK: - サンプルデータ

private let sampleBlockOrigin = CGPoint(x: 64, y: 82)
private let sampleBlockPitch: CGFloat = 96
private let sampleDeskSize: CGFloat = 28
private let sampleIslandBlocks = [
    "ヨ", "ユ", "ヤ",
    "モ", "メ", "ム", "ミ", "マ",
    "ホ", "ヘ", "フ", "ヒ", "ハ",
    "ノ", "ネ", "ヌ", "ニ", "ナ",
    "ト", "テ", "ツ", "チ", "タ",
    "ソ", "セ", "ス", "シ", "サ",
    "コ", "ケ", "ク", "キ", "カ",
    "オ", "エ", "ウ", "イ"
]

/// 東3ホールの島サーブロック設定
/// - 01〜66，縦並び，33の後で折り返して2列，上下分割
private func sampleBlockConfig(block: String, columnIndex: Int) -> BlockLayoutConfig {
    BlockLayoutConfig(
        hall: "東3",
        block: block,
        startNumber: 1,
        endNumber: 66,
        origin: CGPoint(
            x: sampleBlockOrigin.x + CGFloat(columnIndex) * sampleBlockPitch,
            y: sampleBlockOrigin.y
        ),
        deskSize: sampleDeskSize,
        spacing: 2,
        layoutDirection: .vertical,
        circleType: .island,
        splitDirection: .vertical,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        foldAfterNumber: 33,
        foldGap: 6,
        foldedLineReversed: true
    )
}

let sampleBlockLayouts = sampleIslandBlocks.enumerated().map { index, block in
    DeskLayoutGenerator.generateLayout(
        from: sampleBlockConfig(block: block, columnIndex: index)
    )
}

private let sampleWallConfigs: [WallLayoutConfig] = [
    WallLayoutConfig(
        hall: "東3",
        block: "WA",
        numbers: Array(1...12),
        origin: CGPoint(x: 64, y: 20),
        deskSize: sampleDeskSize,
        spacing: 3,
        layoutDirection: .horizontal,
        splitDirection: .horizontal,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        labelOffset: CGPoint(x: 0, y: 34)
    ),
    WallLayoutConfig(
        hall: "東3",
        block: "WB",
        numbers: Array(1...8),
        origin: CGPoint(x: 480, y: 20),
        deskSize: sampleDeskSize,
        spacing: 3,
        layoutDirection: .horizontal,
        splitDirection: .horizontal,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        labelOffset: CGPoint(x: 0, y: 34)
    ),
    WallLayoutConfig(
        hall: "東3",
        block: "WC",
        numbers: Array(1...10),
        origin: CGPoint(x: 20, y: 96),
        deskSize: sampleDeskSize,
        spacing: 3,
        layoutDirection: .vertical,
        splitDirection: .vertical,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        labelOffset: CGPoint(x: -26, y: 0)
    )
]

let sampleWallLayouts = sampleWallConfigs.map {
    WallLayoutGenerator.generateLayout(from: $0)
}

let sampleMapLayouts = sampleWallLayouts + sampleBlockLayouts

// MARK: - BlockMapView

/// 1ブロック分の机配置を表示する View
/// - 机データのX/Y座標に従って机を配置する
/// - スクロールやジェスチャーは持たず、描画のみを担当する
struct BlockMapView: View {
    let layout: BlockMapLayout
    let memos: [DeskMemoState]

    // MARK: - ヘルパー

    private func memos(for desk: DeskData) -> [DeskMemoState] {
        memos.filter { $0.deskId == desk.canonicalId }
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .topLeading) {
            // キャンバスの広さを確保する透明なビュー
            Color.clear
                .frame(width: layout.canvasSize.width, height: layout.canvasSize.height)

            // 机
            ForEach(layout.desks) { desk in
                DeskView(desk: desk, memos: memos(for: desk))
                    .position(
                        x: desk.position.x + desk.size / 2,
                        y: desk.position.y + desk.size / 2
                    )
            }

            Text(layout.blockLabel)
                .font(.headline)
                .foregroundColor(.primary)
                .position(layout.blockLabelPosition)
        }
    }
}
