import SwiftUI

// サークル一覧表示のセルの表示について

struct CircleRow: View {
    let circle: CircleInfo
    
    var body: some View {
        HStack {
            Text(circle.place)
                .font(.headline)
                .frame(width: 80, alignment: .center)
                .padding(8)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(circle.artistName)
                    .font(.headline)
                Text(circle.direction)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(circle.priority)
                .font(.footnote)
                .foregroundColor(.blue)
        }
    }
}
