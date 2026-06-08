import SwiftUI

/// 1ブロック分の机配置を表示する View
/// - 机データのX/Y座標に従って机を配置する
/// - スクロールやジェスチャーは持たず、描画のみを担当する
struct MapBlockLayoutView: View {
    let layout: BlockMapLayout
    let memos: [DeskMemoState]

    private func memos(for desk: DeskData) -> [DeskMemoState] {
        memos.filter { $0.deskId == desk.canonicalId }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
                .frame(width: layout.canvasSize.width, height: layout.canvasSize.height)

            ForEach(layout.desks) { desk in
                DeskView(desk: desk, memos: memos(for: desk))
                    .position(
                        x: desk.position.x + desk.size / 2,
                        y: desk.position.y + desk.size / 2
                    )
            }

            if !layout.blockLabel.isEmpty {
                Text(layout.blockLabel)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .position(layout.blockLabelPosition)
            }
        }
    }
}
