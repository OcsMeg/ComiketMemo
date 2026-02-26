import SwiftUI

// 一覧画面の上部に表示するヘッダーについて

struct HeaderBar: View {
    let onSort: () -> Void
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onSort) {
                Image(systemName: "arrow.up.arrow.down")
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
        }
        .padding(.top, 8)
    }
}
