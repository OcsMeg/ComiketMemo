import SwiftUI

// アプリのメイン画面
// 一覧表示，ヘッダー，フッター，各シートの表示

struct ContentView: View {
    @StateObject private var vm = CircleListViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationStack {
                VStack {
                    HeaderBar(
                        onSort: { vm.sortByPriority() },
                        onAdd: { vm.openAdd() }
                    )
                    .padding(.horizontal)

                    List {
                        ForEach(vm.circles) { circle in
                            Button {
                                vm.openDetail(circle)
                            } label: {
                                CircleRow(circle: circle)
                            }
                            .buttonStyle(.plain) // Listの行っぽい見た目を維持
                        }
                        .onDelete(perform: vm.delete)
                    }
                }
                .navigationTitle("コミメモッ！_prototype")
                .navigationDestination(isPresented: $vm.showMap) {
                    CircleMapView(
                        circles: vm.circles,
                        onClose: { vm.closeMap() }
                    )
                }
            }
            
            Divider()
            
            AppFooter(
                onMemo: { vm.closeMap() },
                onMap: { vm.openMap() }
            )
        }
        // シート表示はここで一本化
        .sheet(item: $vm.activeSheet) { sheet in
            switch sheet {
            case .add:
                NavigationView {
                    AddCircleView(
                        circles: $vm.circles,
                        onClose: { vm.closeSheet() }
                    )
                }
            case .detail(let circle):
                CircleDetailSheet(
                    circle: circle,
                    onClose: { vm.closeSheet() }
                )
                .presentationDetents([.height(260), .medium])
                .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    ContentView()
}
