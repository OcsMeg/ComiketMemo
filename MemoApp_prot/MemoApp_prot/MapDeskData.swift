import CoreGraphics

// MARK: - 列挙型

/// スペース種別: a=机の半分(左/上), b=机の半分(右/下), ab=机全体
enum SpaceType: String, CaseIterable, Hashable {
    case a, b, ab
}

/// サークル種別（島サー / 壁サー）
enum CircleType {
    case island // 島サー
    case wall   // 壁サー
}

/// a/b の分割方向
enum SplitDirection {
    case horizontal // 左右分割: a=左, b=右
    case vertical   // 上下分割: a=上, b=下
}

/// 机の並び方向
enum LayoutDirection {
    case horizontal // X方向に増加
    case vertical   // Y方向に増加
}

/// 折り返し前の列・行を配置する側
enum FirstLinePosition {
    case leading  // 横並びなら上、縦並びなら左
    case trailing // 横並びなら下、縦並びなら右
}

/// 通路の向き
enum AisleDirection: Equatable {
    case horizontal
    case vertical
}

// MARK: - 机データ

/// 1つの机を表すデータ（A-01 のように番号単位）
struct DeskData: Identifiable {
    let id: String              // 表示・ForEach用のユニークID
    let canonicalId: String     // メモ照合用の本来のID（例: "東3-A-01"）
    let hall: String            // 例: "東3"
    let block: String           // 例: "A"
    let number: String          // 例: "01"（2桁表記）
    let circleType: CircleType
    let position: CGPoint       // 机の左上座標
    let size: CGFloat           // 1辺のサイズ（正方形）
    let rotationDegrees: Double
    let splitDirection: SplitDirection
    let availableSpaces: [SpaceType]
}

// MARK: - ブロック生成設定

/// 1ブロック分の机を一括生成するための設定
struct BlockLayoutConfig {
    let hall: String
    let block: String
    let startNumber: Int
    let endNumber: Int
    let origin: CGPoint         // 先頭の机の左上座標
    let deskSize: CGFloat
    let spacing: CGFloat        // 机と机の間隔
    let layoutDirection: LayoutDirection
    let circleType: CircleType
    let splitDirection: SplitDirection
    let availableSpaces: [SpaceType]
    let rotationDegrees: Double
    let foldAfterNumber: Int?   // この机番号の後で折り返す（例: 19ならA-19の後にA-20から2列目へ。nil=折り返しなし）
    let foldGap: CGFloat        // 折り返し後の列/行との隙間
    let firstLinePosition: FirstLinePosition
    let firstLineReversed: Bool
    let foldedLineReversed: Bool
}

/// 壁サーの一列配置を生成するための設定
/// - 壁は机数が固定でないため、numberGroupsで番号のまとまりを明示する
struct WallLayoutConfig {
    let hall: String
    let block: String
    let numberGroups: [[Int]]
    let origin: CGPoint
    let deskSize: CGFloat
    let spacing: CGFloat
    let groupSpacing: CGFloat
    let layoutDirection: LayoutDirection
    let isReversed: Bool
    let splitDirection: SplitDirection
    let availableSpaces: [SpaceType]
    let rotationDegrees: Double
    let labelAfterGroupIndex: Int?
}

/// 生成済みの地図レイアウト
/// - View側で配列から外枠を再計算しないように、生成処理側でまとめて作る
struct BlockMapLayout {
    let desks: [DeskData]
    let canvasSize: CGSize
    let outerFrame: CGRect
    let blockLabel: String
    let blockLabelPosition: CGPoint
}

// MARK: - 通路データ

/// 通路を生成するための設定
/// - position: 通路を挿入するX座標またはY座標
/// - spanStart / spanLength: 通路が伸びる範囲
/// - showsIslandLabels: trueの場合、島名をこの通路の中央へ表示する
struct AisleLayoutConfig: Identifiable {
    let id: String
    let direction: AisleDirection
    let position: CGFloat
    let width: CGFloat
    let spanStart: CGFloat
    let spanLength: CGFloat
    let showsIslandLabels: Bool
}

/// 描画用に生成された通路
struct AisleData: Identifiable {
    let id: String
    let frame: CGRect
}

/// 机ブロックと通路を合成した地図全体のレイアウト
struct ComposedMapLayout {
    let blockLayouts: [BlockMapLayout]
    let aisles: [AisleData]
    let canvasSize: CGSize
}

// MARK: - メモ状態（表示用）

/// 1スペースのメモ状態（表示側が受け取るデータ）
struct DeskMemoState {
    let deskId: String          // 例: "東3-A-05"
    let space: SpaceType        // .a, .b, または .ab
    let isPurchased: Bool
}
