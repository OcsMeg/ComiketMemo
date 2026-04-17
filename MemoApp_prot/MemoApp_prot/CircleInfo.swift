import Foundation

// サークル情報についてのスクリプト
// サークル情報の構造はここで定義
struct CircleInfo: Identifiable, Equatable {
    let id: UUID
    var place: String
    var artistName: String
    var url: String
    var direction: String
    var priority: String
    
    init(
        id: UUID = UUID(),
        place: String,
        artistName: String,
        url: String,
        direction: String,
        priority: String
    ) {
        self.id = id
        self.place = place
        self.artistName = artistName
        self.url = url
        self.direction = direction
        self.priority = priority
    }
}

// サンプルデータ
let sampleData: [CircleInfo] = [
    CircleInfo(place: "A-11a", artistName: "関本健治郎", url: "11", direction: "東", priority: "高"),
    CircleInfo(place: "B-12b", artistName: "キルパクン", url: "12", direction: "南", priority: "中"),
    CircleInfo(place: "C-32ab", artistName: "かみみみ", url: "23", direction: "西", priority: "低"),
]
