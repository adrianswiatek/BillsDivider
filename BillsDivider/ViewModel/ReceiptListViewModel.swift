import Combine

class ReceiptListViewModel: ObservableObject {
    @Published var positions: [ReceiptPosition]

    init() {
        self.positions = []
    }
}
