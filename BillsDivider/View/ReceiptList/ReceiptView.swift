import SwiftUI

struct ReceiptView: View {
    @ObservedObject private var viewModel: ReceiptViewModel

    @State private var editOverlayParams: EditOverlayViewParams2 = .hidden
    @State private var presentingOptionsMenu: Bool = false

    private let columnWidth: CGFloat = UIScreen.main.bounds.width / 3

    init(_ viewModel: ReceiptViewModel) {
        self.viewModel = viewModel
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
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.init(top: 1, leading: 8, bottom: 2, trailing: 8))
                                .background(
                                    Capsule(style: .continuous)
                                        .foregroundColor(.blue)
                                )
                                .frame(width: self.columnWidth)

                            Text(position.owner.formatted)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.init(top: 1, leading: 8, bottom: 2, trailing: 8))
                                .background(
                                    Capsule(style: .continuous)
                                        .foregroundColor(self.getBackgroundColor(for: position.owner))
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
                },
//                .disabled(true),
                trailing: Button(action: { self.editOverlayParams = .shownAdding() }) {
                    Image(systemName: "plus")
                        .frame(width: 32, height: 32)
                }
            )
        }
//        .sheet(isPresented: $editOverlayParams.show) {
//
//        }
        .actionSheet(isPresented: $presentingOptionsMenu) {
            ActionSheet(title: Text("Actions"), buttons: [
                .destructive(Text("Delete all"), action: { self.viewModel.removeAllPositions() }),
                .cancel()
            ])
        }
    }

    private func getBackgroundColor(for owner: Owner2) -> Color {
        owner == .all ? .purple : .blue
    }
}

struct ReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().receiptView
    }
}
