import SwiftUI

//データ形式を定義
struct CircleInfo: Identifiable {
    let id = UUID() //データの一意なID
    let place: String //場所
    let artistName: String //作家名
    let url: String //URLの代わり
    let direction: String //方角
    let priority: String //優先度
}

// データを格納するリスト
let sampleData: [CircleInfo] = [
    CircleInfo(place: "A-11a", artistName: "関本健治郎", url: "11", direction: "東", priority: "高"),
    CircleInfo(place: "B-12b", artistName: "キルパクン", url: "12", direction: "南", priority: "中"),
    CircleInfo(place: "C-32ab", artistName: "かみみみ", url: "23", direction: "西", priority: "低"),
]

struct ContentView: View {
    @State private var circles: [CircleInfo] = sampleData
    @State private var showingAddSheet = false
    
    // ★追加：タップされた行
    @State private var selectedCircle: CircleInfo? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        let priorityOrder = ["高", "中", "低"]
                        circles.sort {
                            guard let i0 = priorityOrder.firstIndex(of: $0.priority),
                                  let i1 = priorityOrder.firstIndex(of: $1.priority) else { return false }
                            return i0 < i1
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                .padding(.horizontal)
                
                List {
                    ForEach(circles) { circle in
                        // ★変更：行全体をタップ可能に
                        Button {
                            selectedCircle = circle
                        } label: {
                            HStack {
                                Text(circle.place)
                                    .font(.headline)
                                    .frame(width: 80, alignment: .center)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading) {
                                    Text(circle.artistName).font(.headline)
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
                        .buttonStyle(.plain) // Listのボタン見た目を通常行っぽく
                    }
                    .onDelete(perform: deleteCircle)
                }
            }
            .navigationTitle("コミメモッ！_prototype")
            
            // 追加画面
            .sheet(isPresented: $showingAddSheet) {
                NavigationView { AddCircleView(circles: $circles) }
            }
            
            // ★詳細表示：タップしたcircleが入ったらシート表示
            .sheet(item: $selectedCircle) { circle in
                CircleDetailSheet(circle: circle)
                // “ちっちゃい”高さに固定/候補を用意（iOS16+）
                    .presentationDetents([.height(260), .medium])
                    .presentationDragIndicator(.visible)
            }
        }
        
        // （あなたのフッターはこのままでOK）
        Divider()
        HStack {
            Spacer()
            Button { } label: { Image(systemName: "note.text").font(.title2) }
            Spacer()
            Button { } label: { Image(systemName: "map").font(.title2) }
            Spacer()
        }
        .padding(.top, 8)
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.bottom))
    }
    
    private func deleteCircle(at offsets: IndexSet) {
        circles.remove(atOffsets: offsets)
    }
}


//リスト追加の画面
struct AddCircleView: View {
    //このViewを閉じるための機能
    @Environment(\.dismiss) var dismiss
    
    //ContentViewのCircleInfoと紐付け
    @Binding var circles: [CircleInfo]
    
    // 作家名とURLの入れ子
    @State private var artistName = ""
    @State private var number = "" // URL用
    
    // 場所を構成する4つの要素の入れ子
    @State private var selectedHall = ""
    @State private var selectedRow = ""
    @State private var selectedDeskNumber = ""
    @State private var selectedPosition = ""
    @State private var selectedPriority = ""
    
    // Pickerの選択肢データ
    let halls = ["東", "西", "南"]
    let rows = ["A","B","D","E","F","G","H","K","L","M","N","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let deskNumbers = (1...64).map { String($0) }
    let positions = ["a", "b", "ab"]
    let priority = ["高", "中", "低"]
    
    // 全ての項目が入力されたかを確認するコンピューテッドプロピ
    private var isFormValid: Bool {
        !artistName.isEmpty && !number.isEmpty && !selectedHall.isEmpty && !selectedRow.isEmpty && !selectedPosition.isEmpty && !selectedPriority.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("サークル情報")) {
                TextField("作家名", text: $artistName)
                TextField("URLなど", text: $number)
                Picker("優先度", selection: $selectedPriority) {
                    ForEach(priority, id: \.self) {
                        Text(String($0))
                    }
                }
            }
            
            Section(header: Text("場所")) {
                Picker("ホール", selection: $selectedHall) {
                    ForEach(halls, id: \.self) {
                        Text($0)
                    }
                }
                
                Picker("列", selection: $selectedRow) {
                    ForEach(rows, id: \.self) {
                        Text($0)
                    }
                }
                
                Picker("机番号", selection: $selectedDeskNumber) {
                    ForEach(deskNumbers, id: \.self) {
                        Text(String($0))
                    }
                }
                
                Picker("位置", selection: $selectedPosition) {
                    ForEach(positions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle()) // 位置は選択肢が少ないのでスタイルを変更
            }
        }
        .navigationTitle("新しいサークルを追加")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("キャンセル") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("追加") {
                    // 4つの選択肢を結合して場所の文字列を生成
                    let newPlace = "\(selectedRow)-\(selectedDeskNumber)\(selectedPosition)"
                    
                    let newCircle = CircleInfo(
                        place: newPlace,
                        artistName: artistName,
                        url: number,
                        direction: selectedHall,
                        priority: selectedPriority// directionにはホールの情報を格納
                    )
                    
                    circles.append(newCircle)
                    dismiss()
                }
                // 全ての要素を入力し切るまで、追加ボタンを押せないようにする
                .disabled(!isFormValid)
            }
        }
    }
}

// セルの詳細情報
struct CircleDetailSheet: View {
    let circle: CircleInfo
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(circle.place)
                    .font(.title2.bold())
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            row("作家名", circle.artistName)
            row("ホール", circle.direction)
            row("優先度", circle.priority)
            
            // URLが本物のURLなら Link、そうでなければ文字表示
            if let url = URL(string: circle.url), url.scheme != nil {
                HStack {
                    Text("URL").foregroundColor(.secondary)
                    Spacer()
                    Link("開く", destination: url)
                }
            } else {
                row("URL/番号", circle.url)
            }
            
            Spacer(minLength: 0)
        }
        .padding()
    }
    
    private func row(_ key: String, _ value: String) -> some View {
        HStack {
            Text(key).foregroundColor(.secondary)
            Spacer()
            Text(value).bold()
        }
    }
}


#Preview {
    ContentView()
}
