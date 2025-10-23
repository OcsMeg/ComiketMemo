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
    // @Stateをつけることにより、外部からも変更できるように
    @State private var circles: [CircleInfo] = sampleData
    
    // 追加画面を出すかどうか
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView { // NavigationViewで全体を囲むとタイトルが表示されます
            VStack {
                // Listの前にHStackを配置
                HStack {
                    // ソートボタン
                    Button {
                        // 優先度のソート
                        let priorityOrder = ["高", "中", "低"]
                        circles.sort {
                            // 各優先度がpriorityOrder配列のどの位置にあるかを取得
                            guard let firstIndex = priorityOrder.firstIndex(of: $0.priority),
                                  let secondIndex = priorityOrder.firstIndex(of: $1.priority) else {
                                return false
                            }
                            // インデックスが小さい方（"高"に近い方）が前に来るように並び替え
                            return firstIndex < secondIndex
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Spacer() // スペースを追加して右寄せに
                    
                    //追加ボタン
                    Button(action: {
                        // ボタンが押されたら、追加画面を出す
                        showingAddSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                .padding(.horizontal)
                
                List {
                    ForEach(circles) { circle in
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
                            Text(circle.priority) // URLの代わりに表示
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                    }
                    .onDelete(perform: deleteCircle) // 削除機能を追加
                }
            }
            .navigationTitle("コミメモッ！_prototype")
            .sheet(isPresented: $showingAddSheet) {
                //AddCircleViewに、リストのデータを渡す
                NavigationView {
                    AddCircleView(circles: $circles)
                }
            }
        }
        
        Divider() // コンテンツとフッターの区切り線
        
        HStack {
            Spacer()
            
            // メモボタン
            Button(action: {
                // TODO: メモボタンのアクションをここに記述
            }) {
                Image(systemName: "note.text")
                    .font(.title2)
            }
            
            Spacer()
            
            // 地図ボタン
            Button(action: {
                // TODO: 地図ボタンのアクションをここに記述
            }) {
                Image(systemName: "map")
                    .font(.title2)
            }
            
            Spacer()
        }
        .padding(.top, 8)
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.bottom)) // フッターの背景色

    }
    
    // リストから項目を削除する関数
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

#Preview {
    ContentView()
}
