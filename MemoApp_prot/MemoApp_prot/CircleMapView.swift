import SwiftUI

// マップ画面
struct CircleMapView: View {
    let circles: [CircleInfo]
    let onClose: () -> Void

    var body: some View {
        Color(.systemBackground)
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("マップ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("閉じる") { onClose() }
                }
            }
    }
}
