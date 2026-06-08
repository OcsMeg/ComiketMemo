import SwiftUI

// 館ごとの固定レイアウト定義。
// 机の生成・通路の挿入・描画は別ファイルに分け、このファイルでは
// 「2026年夏 1日目 東1-3」の会場データだけを持つ。
private let east123BlockOrigin = CGPoint(x: 64, y: 82)
private let east123BlockPitch: CGFloat = 96
private let east123DeskSize: CGFloat = 28

// 島サーの列名。配列順が画面上の左から右への並びになる。
private let east123IslandBlocks = [
    "ヨ", "ユ", "ヤ",
    "モ", "メ", "ム", "ミ", "マ",
    "ホ", "ヘ", "フ", "ヒ", "ハ",
    "ノ", "ネ", "ヌ", "ニ", "ナ",
    "ト", "テ", "ツ", "チ", "タ",
    "ソ", "セ", "ス", "シ", "サ",
    "コ", "ケ", "ク", "キ", "カ",
    "オ", "エ", "ウ", "イ"
]

private func east123IslandConfig(block: String, columnIndex: Int) -> BlockLayoutConfig {
    // 東館の島は1列あたり66机。右下を01として上方向に増え、
    // 33の後に折り返して左列へ並ぶため、firstLinePositionをtrailingにしている。
    BlockLayoutConfig(
        hall: "東3",
        block: block,
        startNumber: 1,
        endNumber: 66,
        origin: CGPoint(
            x: east123BlockOrigin.x + CGFloat(columnIndex) * east123BlockPitch,
            y: east123BlockOrigin.y
        ),
        deskSize: east123DeskSize,
        spacing: 2,
        layoutDirection: .vertical,
        circleType: .island,
        splitDirection: .vertical,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        foldAfterNumber: 33,
        foldGap: 6,
        firstLinePosition: .trailing,
        firstLineReversed: true,
        foldedLineReversed: false
    )
}

// ブロック名と列番号だけを渡し、共通の島サー生成処理で机データを作る。
private let east123IslandLayouts = east123IslandBlocks.enumerated().map { index, block in
    DeskLayoutGenerator.generateLayout(
        from: east123IslandConfig(block: block, columnIndex: index)
    )
}

// 壁サーは机数や間隔が場所ごとに変わるため、numberGroupsでまとまりを明示する。
// ここでは右壁・上壁・左壁に分けて、ア列の壁サー配置を構成している。
private let east123WallConfigs: [WallLayoutConfig] = [
    WallLayoutConfig(
        hall: "東3",
        block: "ア",
        numberGroups: [
            Array(1...3),
            Array(4...7),
            Array(8...11),
            Array(12...15),
            Array(16...19),
            Array(20...22)
        ],
        origin: CGPoint(x: 3_680, y: 1_042),
        deskSize: east123DeskSize,
        spacing: 3,
        groupSpacing: 52,
        layoutDirection: .vertical,
        isReversed: true,
        splitDirection: .vertical,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        labelAfterGroupIndex: nil
    ),
    WallLayoutConfig(
        hall: "東3",
        block: "ア",
        numberGroups: [
            Array(23...24),
            [25],
            Array(26...27),
            Array(28...29),
            Array(30...32),
            Array(33...34),
            Array(35...37),
            Array(38...39),
            Array(40...41),
            Array(42...44),
            Array(45...46),
            Array(47...49),
            Array(50...51),
            Array(52...54),
            Array(55...56),
            Array(57...58),
            Array(59...61),
            Array(62...63),
            Array(64...66),
            Array(67...68),
            Array(69...71),
            Array(72...73)
        ],
        origin: CGPoint(x: 3_680, y: 20),
        deskSize: east123DeskSize,
        spacing: 3,
        groupSpacing: 72,
        layoutDirection: .horizontal,
        isReversed: true,
        splitDirection: .horizontal,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        labelAfterGroupIndex: 10
    ),
    WallLayoutConfig(
        hall: "東3",
        block: "ア",
        numberGroups: [
            Array(74...76),
            Array(77...80),
            Array(81...84),
            Array(85...88),
            Array(89...92),
            Array(93...95)
        ],
        origin: CGPoint(x: 20, y: 82),
        deskSize: east123DeskSize,
        spacing: 3,
        groupSpacing: 52,
        layoutDirection: .vertical,
        isReversed: false,
        splitDirection: .vertical,
        availableSpaces: [.a, .b, .ab],
        rotationDegrees: 0,
        labelAfterGroupIndex: nil
    )
]

private let east123WallLayouts = east123WallConfigs.map {
    WallLayoutGenerator.generateLayout(from: $0)
}

// 通路は机を直接消すのではなく、指定位置以降の机を押し出して作る。
// 真ん中の太い通路だけ島名ラベルを載せるため showsIslandLabels を true にしている。
private let east123AisleConfigs: [AisleLayoutConfig] = [
    AisleLayoutConfig(
        id: "east123-horizontal-1",
        direction: .horizontal,
        position: east123BlockOrigin.y + 8 * (east123DeskSize + 2),
        width: 36,
        spanStart: 50,
        spanLength: 3_650,
        showsIslandLabels: false
    ),
    AisleLayoutConfig(
        id: "east123-horizontal-2",
        direction: .horizontal,
        position: east123BlockOrigin.y + 16 * (east123DeskSize + 2),
        width: 72,
        spanStart: 50,
        spanLength: 3_650,
        showsIslandLabels: true
    ),
    AisleLayoutConfig(
        id: "east123-horizontal-3",
        direction: .horizontal,
        position: east123BlockOrigin.y + 24 * (east123DeskSize + 2),
        width: 36,
        spanStart: 50,
        spanLength: 3_650,
        showsIslandLabels: false
    )
]

private let east123ComposedMapLayout = AisleLayoutGenerator.generate(
    blockLayouts: east123WallLayouts + east123IslandLayouts,
    aisleConfigs: east123AisleConfigs
)

/// 2026年夏 1日目 東1-3ホールのマップ
struct Summer2026Day1East123MapView: View {
    static let composedLayout = east123ComposedMapLayout
    static let blockLayouts = east123ComposedMapLayout.blockLayouts

    let memos: [DeskMemoState]

    var body: some View {
        ComposedMapLayoutView(
            layout: Self.composedLayout,
            memos: memos
        )
    }
}
