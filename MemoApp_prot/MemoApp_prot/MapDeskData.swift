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
    let foldedLineReversed: Bool // trueなら端で折り返すように2列目/2行目を逆向きに並べる
}

/// 壁サーの一列配置を生成するための設定
/// - 壁は机数が固定でないため、numbersで机番号を明示する
struct WallLayoutConfig {
    let hall: String
    let block: String
    let numbers: [Int]
    let origin: CGPoint
    let deskSize: CGFloat
    let spacing: CGFloat
    let layoutDirection: LayoutDirection
    let splitDirection: SplitDirection
    let availableSpaces: [SpaceType]
    let rotationDegrees: Double
    let labelOffset: CGPoint
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

// MARK: - メモ状態（表示用）

/// 1スペースのメモ状態（表示側が受け取るデータ）
struct DeskMemoState {
    let deskId: String          // 例: "東3-A-05"
    let space: SpaceType        // .a, .b, または .ab
    let isPurchased: Bool
}
