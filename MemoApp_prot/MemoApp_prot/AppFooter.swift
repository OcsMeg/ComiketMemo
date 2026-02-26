import SwiftUI

// 画面下のフッター表示について
struct AppFooter: View {
    let onMemo: () -> Void
    let onMap: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: onMemo) {
                Image(systemName: "note.text")
                    .font(.title2)
            }
            Spacer()
            Button(action: onMap) {
                Image(systemName: "map")
                    .font(.title2)
            }
            Spacer()
        }
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.bottom))
    }
}
