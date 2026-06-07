import SwiftUI

// マップ画面
// - ドラッグでパン，ピンチで拡大縮小，2本指で回転
// - BlockMapView で生成した机配置を表示する
struct CircleMapView: View {
    private static let initialScale: CGFloat = 0.65

    let circles: [CircleInfo]
    let onClose: () -> Void

    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var scale: CGFloat = initialScale
    @State private var lastScale: CGFloat = initialScale
    @State private var rotation: Angle = .zero
    @State private var lastRotation: Angle = .zero

    private var mapMemos: [DeskMemoState] {
        CircleMapMemoMapper.makeMemoStates(
            from: circles,
            layouts: sampleMapLayouts
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color(.systemBackground)

                ZStack(alignment: .topLeading) {
                    ForEach(sampleMapLayouts.indices, id: \.self) { index in
                        BlockMapView(
                            layout: sampleMapLayouts[index],
                            memos: mapMemos
                        )
                    }
                }
                .scaleEffect(scale, anchor: .topLeading)
                .rotationEffect(rotation)
                .offset(offset)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = CGSize(
                            width: lastOffset.width + value.translation.width,
                            height: lastOffset.height + value.translation.height
                        )
                    }
                    .onEnded { _ in
                        lastOffset = offset
                    }
            )
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = max(0.35, min(6.0, lastScale * value))
                    }
                    .onEnded { _ in
                        lastScale = scale
                    }
            )
            .simultaneousGesture(
                RotationGesture()
                    .onChanged { value in
                        rotation = lastRotation + value
                    }
                    .onEnded { _ in
                        lastRotation = rotation
                    }
            )
        }
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
