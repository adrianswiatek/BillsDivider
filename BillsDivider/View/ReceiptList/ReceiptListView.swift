import SwiftUI

struct ReceiptListView: View {
    @ObservedObject private var viewModel: ReceiptListViewModel

    @State private var editOverlayParams: EditOverlayViewParams = .hidden
    @State private var presentingOptionsMenu: Bool = false

    private let columnWidth: CGFloat = UIScreen.main.bounds.width / 3
    private let viewModelFactory: ViewModelFactory

    init(_ viewModel: ReceiptListViewModel, _ viewModelFactory: ViewModelFactory) {
        self.viewModel = viewModel
        self.viewModelFactory = viewModelFactory
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: ReceiptHeaderView(columnWidth)) {
                    ForEach(viewModel.positions) { position in
                        HStack {
                            Text(self.viewModel.formatNumber(value: position.amount))
                                .frame(width: self.columnWidth)

                            Text(position.buyer.formatted)
                                .foregroundColor(.white)
                                .padding(.init(top: 1, leading: 8, bottom: 2, trailing: 8))
                                .background(
                                    Capsule(style: .continuous)
                                        .foregroundColor(self.getBuyerColor(for: position))
                                )
                                .frame(width: self.columnWidth)

                            Text(position.owner.formatted)
                                .foregroundColor(.white)
                                .padding(.init(top: 1, leading: 8, bottom: 2, trailing: 8))
                                .background(
                                    Capsule(style: .continuous)
                                        .foregroundColor(self.getOwnerColor(for: position))
                                )
                                .frame(width: self.columnWidth)
                        }
                        .offset(x: -24, y: 0)
                        .contextMenu {
                            Button(action: { self.editOverlayParams = .shownEditing(position) }) {
                                Text("Edit position")
                                Image(systemName: "pencil")
                            }
                            Button(action: { self.viewModel.removePosition(position) }) {
                                Text("Remove position")
                                Image(systemName: "trash")
                            }
                        }
                    }
                    .onDelete {
                        guard let index = $0.first else { return }

                        withAnimation {
                            self.viewModel.removePosition(at: index)
                        }
                    }
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: { self.presentingOptionsMenu = true }) {
                    Image(systemName: "ellipsis")
                        .frame(width: 32, height: 32)
                        .rotationEffect(.degrees(90))
                }
                .disabled(viewModel.positions.isEmpty),
                trailing: Button(action: { self.editOverlayParams = .shownAdding() }) {
                    Image(systemName: "plus")
                        .frame(width: 32, height: 32)
                }
            )
        }
        .sheet(isPresented: $editOverlayParams.show) {
            self.createEditOverlayView()
        }
        .actionSheet(isPresented: $presentingOptionsMenu) {
            ActionSheet(title: Text("Actions"), buttons: [
                .destructive(Text("Remove all"), action: { self.viewModel.removeAllPositions() }),
                .cancel()
            ])
        }
    }

    private func getBuyerColor(for position: ReceiptPosition) -> Color {
        switch position.buyer {
        case .me: return .blue
        case .notMe: return .green
        }
    }

    private func getOwnerColor(for position: ReceiptPosition) -> Color {
        switch position.owner {
        case .me: return .blue
        case .notMe: return .green
        case .all: return .purple
        }
    }

    private func createEditOverlayView() -> some View {
        editOverlayParams.providePosition(self.viewModel.positions.first)

        let editOverlayViewModel = viewModelFactory.editOverlayViewModel(presentingParams: $editOverlayParams)
        viewModel.subscribe(
            addingPublisher: editOverlayViewModel.positionAdded,
            editingPublisher: editOverlayViewModel.positionEdited
        )
        return EditOverlayView(editOverlayViewModel)
    }
}

struct ReceiptListView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().receiptListView
    }
}
