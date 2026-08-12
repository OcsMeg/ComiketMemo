import SwiftUI

// マップ画面
// - ドラッグでパン，ピンチで拡大縮小，2本指で回転
// - 選択中の館の机配置を表示する
struct CircleMapView: View {
    private static let initialScale: CGFloat = 0.65

    let circles: [CircleInfo]
    let onClose: () -> Void

    @State private var selectedVenue: MapVenue = .east123
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var scale: CGFloat = initialScale
    @State private var lastScale: CGFloat = initialScale
    @State private var rotation: Angle = .zero
    @State private var lastRotation: Angle = .zero

    private var mapMemos: [DeskMemoState] {
        // 選択中の館の机一覧だけを渡すことで、同じ「西-め-01a」のようなメモでも
        // 現在表示している館に存在する机だけが赤くなる。
        CircleMapMemoMapper.makeMemoStates(
            from: circles,
            layouts: selectedVenue.blockLayouts
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color(.systemBackground)

                ZStack(alignment: .topLeading) {
                    // 館ごとのViewは固定レイアウトを持ち、パン/ズーム/回転はこの親Viewで一括管理する。
                    switch selectedVenue {
                    case .east123:
                        Summer2026Day1East123MapView(memos: mapMemos)
                    case .west:
                        Summer2026Day1WestMapView(memos: mapMemos)
                    }
                }
                .scaleEffect(scale, anchor: .topLeading)
                .rotationEffect(rotation)
                .offset(offset)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
            .contentShape(Rectangle())
            .overlay(alignment: .bottomTrailing) {
                venueToggle
                    .padding(.trailing, 16)
                    .padding(.bottom, 18)
            }
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
        .onChange(of: selectedVenue) { _, _ in
            resetViewport()
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

    private var venueToggle: some View {
        Picker("館", selection: $selectedVenue) {
            ForEach(MapVenue.allCases) { venue in
                Text(venue.title).tag(venue)
            }
        }
        .pickerStyle(.segmented)
        .frame(width: 160)
        .padding(8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: Color.black.opacity(0.12), radius: 8, y: 2)
    }

    private func resetViewport() {
        // 館を切り替えたときに前のズーム・回転位置を引き継ぐと迷いやすいため初期視点に戻す。
        offset = .zero
        lastOffset = .zero
        scale = Self.initialScale
        lastScale = Self.initialScale
        rotation = .zero
        lastRotation = .zero
    }
}
