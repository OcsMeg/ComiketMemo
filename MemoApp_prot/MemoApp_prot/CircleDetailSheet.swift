import SwiftUI

// 一覧表示セルをタップした時に表示する詳細表示UI

struct CircleDetailSheet: View {
    let circle: CircleInfo
    let onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(circle.place)
                    .font(.title2.bold())
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            KeyValueRow(key: "作家名", value: circle.artistName)
            KeyValueRow(key: "ホール", value: circle.direction)
            KeyValueRow(key: "優先度", value: circle.priority)
            
            // URLが本物のURLなら開けるように（"11"などならそのまま表示）
            if let url = URL(string: circle.url), url.scheme != nil {
                HStack {
                    Text("URL").foregroundColor(.secondary)
                    Spacer()
                    Link("開く", destination: url)
                }
            } else {
                KeyValueRow(key: "URL/番号", value: circle.url)
            }
            
            Spacer(minLength: 0)
        }
        .padding()
    }
}

struct KeyValueRow: View {
    let key: String
    let value: String
    
    var body: some View {
        HStack {
            Text(key).foregroundColor(.secondary)
            Spacer()
            Text(value).bold()
        }
    }
}
