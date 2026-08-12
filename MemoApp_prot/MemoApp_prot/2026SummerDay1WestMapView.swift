import SwiftUI

// C107Map_w12_B4.pdf をもとにした西1・西2のプロトタイプ配置。
// 座標はPDFそのものの座標ではなく、アプリ内マップ用に読みやすく調整した値。
private let westDeskSize: CGFloat = 28

// 西館の島サーは列ごとに机数が違うため、列名・位置・終了番号だけを個別指定する。
private struct WestIslandSpec {
    let hall: String
    let block: String
    let origin: CGPoint
    let endNumber: Int
}

private func westIslandConfig(_ spec: WestIslandSpec) -> BlockLayoutConfig {
    // 西館の島も2列折り返しで表示する。endNumberの半分を折り返し位置にして、
    // 26机・28机・52机の列を同じ生成処理で扱えるようにしている。
    let foldAfterNumber = max(1, spec.endNumber / 2)

    return BlockLayoutConfig(
        hall: spec.hall,
        block: spec.block,
        startNumber: 1,
        endNumber: spec.endNumber,
        origin: spec.origin,
        deskSize: westDeskSize,
        spacing: 2,
        layoutDirection: .vertical,
        circleType: .island,
        splitDirection: .vertical,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        foldAfterNumber: foldAfterNumber,
        foldGap: 8,
        firstLinePosition: .trailing,
        firstLineReversed: true,
        foldedLineReversed: false
    )
}

// PDF上段の西1島サー。配列順は画面左から右への並び。
private let west1TopIslandSpecs: [WestIslandSpec] = [
    WestIslandSpec(hall: "西1", block: "ふ", origin: CGPoint(x: 220, y: 120), endNumber: 52),
    WestIslandSpec(hall: "西1", block: "ひ", origin: CGPoint(x: 316, y: 120), endNumber: 52),
    WestIslandSpec(hall: "西1", block: "は", origin: CGPoint(x: 412, y: 120), endNumber: 52),
    WestIslandSpec(hall: "西1", block: "の", origin: CGPoint(x: 508, y: 120), endNumber: 52),
    WestIslandSpec(hall: "西1", block: "ね", origin: CGPoint(x: 604, y: 120), endNumber: 52),
    WestIslandSpec(hall: "西1", block: "め", origin: CGPoint(x: 724, y: 120), endNumber: 26),
    WestIslandSpec(hall: "西1", block: "に", origin: CGPoint(x: 820, y: 120), endNumber: 26),
    WestIslandSpec(hall: "西1", block: "な", origin: CGPoint(x: 940, y: 120), endNumber: 28),
    WestIslandSpec(hall: "西1", block: "と", origin: CGPoint(x: 1_036, y: 120), endNumber: 28),
    WestIslandSpec(hall: "西1", block: "て", origin: CGPoint(x: 1_156, y: 120), endNumber: 28),
    WestIslandSpec(hall: "西1", block: "つ", origin: CGPoint(x: 1_252, y: 120), endNumber: 28)
]

// PDF下段の西1島サー。上段とはY座標だけでなく列数も異なる。
private let west1BottomIslandSpecs: [WestIslandSpec] = [
    WestIslandSpec(hall: "西1", block: "む", origin: CGPoint(x: 220, y: 940), endNumber: 52),
    WestIslandSpec(hall: "西1", block: "み", origin: CGPoint(x: 316, y: 940), endNumber: 52),
    WestIslandSpec(hall: "西1", block: "ま", origin: CGPoint(x: 412, y: 940), endNumber: 52),
    WestIslandSpec(hall: "西1", block: "ほ", origin: CGPoint(x: 508, y: 940), endNumber: 52),
    WestIslandSpec(hall: "西1", block: "へ", origin: CGPoint(x: 604, y: 940), endNumber: 52)
]

// PDF上段の西2島サー。西1と同じ生成処理を使い、hallだけ西2に変える。
private let west2TopIslandSpecs: [WestIslandSpec] = [
    WestIslandSpec(hall: "西2", block: "ち", origin: CGPoint(x: 1_520, y: 120), endNumber: 28),
    WestIslandSpec(hall: "西2", block: "た", origin: CGPoint(x: 1_616, y: 120), endNumber: 28),
    WestIslandSpec(hall: "西2", block: "そ", origin: CGPoint(x: 1_736, y: 120), endNumber: 28),
    WestIslandSpec(hall: "西2", block: "せ", origin: CGPoint(x: 1_832, y: 120), endNumber: 28),
    WestIslandSpec(hall: "西2", block: "す", origin: CGPoint(x: 1_952, y: 120), endNumber: 26),
    WestIslandSpec(hall: "西2", block: "し", origin: CGPoint(x: 2_048, y: 120), endNumber: 26),
    WestIslandSpec(hall: "西2", block: "さ", origin: CGPoint(x: 2_168, y: 120), endNumber: 52),
    WestIslandSpec(hall: "西2", block: "こ", origin: CGPoint(x: 2_264, y: 120), endNumber: 52),
    WestIslandSpec(hall: "西2", block: "け", origin: CGPoint(x: 2_360, y: 120), endNumber: 52),
    WestIslandSpec(hall: "西2", block: "く", origin: CGPoint(x: 2_456, y: 120), endNumber: 52),
    WestIslandSpec(hall: "西2", block: "き", origin: CGPoint(x: 2_552, y: 120), endNumber: 52)
]

// PDF下段の西2島サー。
private let west2BottomIslandSpecs: [WestIslandSpec] = [
    WestIslandSpec(hall: "西2", block: "か", origin: CGPoint(x: 2_168, y: 940), endNumber: 52),
    WestIslandSpec(hall: "西2", block: "お", origin: CGPoint(x: 2_264, y: 940), endNumber: 52),
    WestIslandSpec(hall: "西2", block: "え", origin: CGPoint(x: 2_360, y: 940), endNumber: 52),
    WestIslandSpec(hall: "西2", block: "う", origin: CGPoint(x: 2_456, y: 940), endNumber: 52)
]

private let westIslandLayouts = (
    west1TopIslandSpecs
    + west1BottomIslandSpecs
    + west2TopIslandSpecs
    + west2BottomIslandSpecs
).map {
    DeskLayoutGenerator.generateLayout(from: westIslandConfig($0))
}

// 西館の壁サーはコの字の外周に沿って並ぶ。
// numberGroupsはPDFで離れて見える机のまとまりを表し、groupSpacingで間隔を空ける。
private let westWallConfigs: [WallLayoutConfig] = [
    WallLayoutConfig(
        hall: "西1",
        block: "め",
        numberGroups: [
            Array(40...45),
            Array(46...48),
            Array(49...51),
            Array(52...57)
        ],
        origin: CGPoint(x: 220, y: 24),
        deskSize: westDeskSize,
        spacing: 3,
        groupSpacing: 56,
        layoutDirection: .horizontal,
        isReversed: false,
        splitDirection: .horizontal,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        labelAfterGroupIndex: 0
    ),
    WallLayoutConfig(
        hall: "西1",
        block: "め",
        numberGroups: [
            Array(21...37),
            Array(16...20)
        ],
        origin: CGPoint(x: 64, y: 180),
        deskSize: westDeskSize,
        spacing: 3,
        groupSpacing: 96,
        layoutDirection: .vertical,
        isReversed: false,
        splitDirection: .vertical,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        labelAfterGroupIndex: nil
    ),
    WallLayoutConfig(
        hall: "西1",
        block: "め",
        numberGroups: [
            Array(1...15)
        ],
        origin: CGPoint(x: 180, y: 1_650),
        deskSize: westDeskSize,
        spacing: 3,
        groupSpacing: 0,
        layoutDirection: .horizontal,
        isReversed: false,
        splitDirection: .horizontal,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        labelAfterGroupIndex: nil
    ),
    WallLayoutConfig(
        hall: "西2",
        block: "あ",
        numberGroups: [
            Array(40...42),
            Array(43...45),
            Array(46...48),
            Array(49...51),
            Array(52...57)
        ],
        origin: CGPoint(x: 2_580, y: 24),
        deskSize: westDeskSize,
        spacing: 3,
        groupSpacing: 56,
        layoutDirection: .horizontal,
        isReversed: true,
        splitDirection: .horizontal,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        labelAfterGroupIndex: 0
    ),
    WallLayoutConfig(
        hall: "西2",
        block: "あ",
        numberGroups: [
            Array(21...37),
            Array(16...20)
        ],
        origin: CGPoint(x: 2_760, y: 180),
        deskSize: westDeskSize,
        spacing: 3,
        groupSpacing: 96,
        layoutDirection: .vertical,
        isReversed: false,
        splitDirection: .vertical,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        labelAfterGroupIndex: nil
    ),
    WallLayoutConfig(
        hall: "西2",
        block: "あ",
        numberGroups: [
            Array(1...15)
        ],
        origin: CGPoint(x: 2_120, y: 1_650),
        deskSize: westDeskSize,
        spacing: 3,
        groupSpacing: 0,
        layoutDirection: .horizontal,
        isReversed: false,
        splitDirection: .horizontal,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        labelAfterGroupIndex: nil
    )
]

private let westWallLayouts = westWallConfigs.map {
    WallLayoutGenerator.generateLayout(from: $0)
}

// 西1・西2それぞれの中央横通路と、館の境目になる縦通路。
private let westAisleConfigs: [AisleLayoutConfig] = [
    AisleLayoutConfig(
        id: "west1-center-horizontal",
        direction: .horizontal,
        position: 820,
        width: 96,
        spanStart: 160,
        spanLength: 1_160,
        showsIslandLabels: false
    ),
    AisleLayoutConfig(
        id: "west2-center-horizontal",
        direction: .horizontal,
        position: 820,
        width: 96,
        spanStart: 1_480,
        spanLength: 1_200,
        showsIslandLabels: false
    ),
    AisleLayoutConfig(
        id: "west-center-vertical",
        direction: .vertical,
        position: 1_360,
        width: 120,
        spanStart: 0,
        spanLength: 1_760,
        showsIslandLabels: false
    )
]

private let westComposedMapLayout = AisleLayoutGenerator.generate(
    blockLayouts: westWallLayouts + westIslandLayouts,
    aisleConfigs: westAisleConfigs
)

/// 2026年夏 1日目 西1・西2ホールのマップ
/// - 通常の列ラベルはBlockMapLayout側で描画する
/// - 「西1」「西2」の館名だけは全体の位置関係を示すため、このViewで重ねている
struct Summer2026Day1WestMapView: View {
    static let composedLayout = westComposedMapLayout
    static let blockLayouts = westComposedMapLayout.blockLayouts

    let memos: [DeskMemoState]

    var body: some View {
        ComposedMapLayoutView(
            layout: Self.composedLayout,
            memos: memos
        )
        .overlay(alignment: .topLeading) {
            Text("西1")
                .font(.largeTitle.bold())
                .foregroundStyle(Color.primary.opacity(0.45))
                .position(x: 880, y: 790)

            Text("西2")
                .font(.largeTitle.bold())
                .foregroundStyle(Color.primary.opacity(0.45))
                .position(x: 1_920, y: 790)
        }
    }
}
