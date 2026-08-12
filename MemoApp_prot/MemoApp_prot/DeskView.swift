import SwiftUI

/// 1つの机を描画する View
/// - 机データと、その机に紐づくメモ状態を受け取って表示する
/// - ab が存在する場合は机全体を優先表示
/// - splitDirection に従い左右 or 上下に a/b を分割
struct DeskView: View {
    let desk: DeskData
    let memos: [DeskMemoState]

    // MARK: - メモ取得

    private var abMemo: DeskMemoState? { memos.first { $0.space == .ab } }
    private var aMemo:  DeskMemoState? { memos.first { $0.space == .a  } }
    private var bMemo:  DeskMemoState? { memos.first { $0.space == .b  } }

    // MARK: - 色の決定

    /// メモ状態に応じた塗り色を返す
    /// - nil（未登録）: 白
    /// - 未購入: 赤
    /// - 購入済み: グレー
    private func spaceColor(_ memo: DeskMemoState?) -> Color {
        guard let memo else { return .white }
        return memo.isPurchased ? Color(.systemGray4) : Color.red.opacity(0.55)
    }

    // MARK: - 分割線

    private var divider: some View {
        Group {
            switch desk.splitDirection {
            case .horizontal:
                Color.black.opacity(0.3).frame(width: 0.5)
            case .vertical:
                Color.black.opacity(0.3).frame(height: 0.5)
            }
        }
    }

    // MARK: - 机番号

    private var numberFontSize: CGFloat {
        min(15, max(11, desk.size * 0.46))
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            if let ab = abMemo {
                // ab 優先: 机全体を1色で塗る
                Rectangle().fill(spaceColor(ab))
            } else {
                switch desk.splitDirection {
                case .horizontal:
                    HStack(spacing: 0) {
                        Rectangle().fill(spaceColor(aMemo))
                        Rectangle().fill(spaceColor(bMemo))
                    }
                    .overlay(divider)

                case .vertical:
                    VStack(spacing: 0) {
                        Rectangle().fill(spaceColor(aMemo))
                        Rectangle().fill(spaceColor(bMemo))
                    }
                    .overlay(divider)
                }
            }

            Text(desk.number)
                .font(
                    .system(
                        size: numberFontSize,
                        weight: .semibold,
                        design: .monospaced
                    )
                )
                .foregroundStyle(Color.black)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(width: desk.size - 4, height: desk.size - 4)
                .allowsHitTesting(false)
        }
        .frame(width: desk.size, height: desk.size)
        .overlay(Rectangle().stroke(Color.black, lineWidth: 0.5))
        .rotationEffect(Angle(degrees: desk.rotationDegrees))
        .accessibilityLabel("\(desk.block)-\(desk.number)")
    }
}
