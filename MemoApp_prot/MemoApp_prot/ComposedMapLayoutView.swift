import SwiftUI

/// 通路と複数ブロックを合成した地図全体を描画する View
struct ComposedMapLayoutView: View {
    let layout: ComposedMapLayout
    let memos: [DeskMemoState]

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
                .frame(width: layout.canvasSize.width, height: layout.canvasSize.height)

            ForEach(layout.aisles) { aisle in
                AisleView(aisle: aisle)
            }

            ForEach(layout.blockLayouts.indices, id: \.self) { index in
                MapBlockLayoutView(
                    layout: layout.blockLayouts[index],
                    memos: memos
                )
            }
        }
    }
}
