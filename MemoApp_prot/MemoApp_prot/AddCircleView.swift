import SwiftUI

// サークル追加画面のViewファイル

struct AddCircleView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var circles: [CircleInfo]
    let onClose: () -> Void
    
    @State private var artistName = ""
    @State private var number = ""
    
    @State private var selectedHall = ""
    @State private var selectedRow = ""
    @State private var selectedDeskNumber = ""
    @State private var selectedPosition = ""
    @State private var selectedPriority = ""
    
    let halls = ["東", "西", "南"]
    let rows = ["A","B","D","E","F","G","H","K","L","M","N","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let deskNumbers = (1...64).map { String($0) }
    let positions = ["a", "b", "ab"]
    let priorities = ["高", "中", "低"]
    
    private var isFormValid: Bool {
        !artistName.isEmpty
        && !number.isEmpty
        && !selectedHall.isEmpty
        && !selectedRow.isEmpty
        && !selectedDeskNumber.isEmpty
        && !selectedPosition.isEmpty
        && !selectedPriority.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("サークル情報")) {
                TextField("作家名", text: $artistName)
                TextField("URLなど", text: $number)
                
                Picker("優先度", selection: $selectedPriority) {
                    ForEach(priorities, id: \.self) { Text($0) }
                }
            }
            
            Section(header: Text("場所")) {
                Picker("ホール", selection: $selectedHall) {
                    ForEach(halls, id: \.self) { Text($0) }
                }
                
                Picker("列", selection: $selectedRow) {
                    ForEach(rows, id: \.self) { Text($0) }
                }
                
                Picker("机番号", selection: $selectedDeskNumber) {
                    ForEach(deskNumbers, id: \.self) { Text($0) }
                }
                
                Picker("位置", selection: $selectedPosition) {
                    ForEach(positions, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle("新しいサークルを追加")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("キャンセル") {
                    onClose()
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("追加") {
                    let newPlace = "\(selectedRow)-\(selectedDeskNumber)\(selectedPosition)"
                    let newCircle = CircleInfo(
                        place: newPlace,
                        artistName: artistName,
                        url: number,
                        direction: selectedHall,
                        priority: selectedPriority
                    )
                    circles.append(newCircle)
                    onClose()
                    dismiss()
                }
                .disabled(!isFormValid)
            }
        }
    }
}
