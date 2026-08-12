import SwiftUI

/// 机が配置されない通路をグレーで表示する
struct AisleView: View {
    let aisle: AisleData

    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.28))
            .frame(width: aisle.frame.width, height: aisle.frame.height)
            .position(x: aisle.frame.midX, y: aisle.frame.midY)
            .accessibilityLabel("通路")
    }
}
