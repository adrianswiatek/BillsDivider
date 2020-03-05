import BillsDivider_ViewModel
import SwiftUI

struct ReceiptView: View {
    @ObservedObject private var viewModel: ReceiptViewModel

    @State private var editOverlayParams: EditOverlayViewParams = .hidden
    @State private var presentingOptionsMenu: Bool = false

    private let editOverlayViewFactory: EditOverlayViewFactory
    private let columnWidth: CGFloat = UIScreen.main.bounds.width / 3

    init(_ viewModel: ReceiptViewModel, _ editOverlayViewFactory: EditOverlayViewFactory) {
        self.viewModel = viewModel
        self.editOverlayViewFactory = editOverlayViewFactory
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: ReceiptHeaderView(columnWidth)) {
                    ForEach(viewModel.positions) { position in
                        HStack {
                            HStack(spacing: 2) {
                                Text(self.viewModel.formatNumber(value: position.amountWithDiscount))

                                if position.hasDiscount {
                                    Text("%")
                                        .foregroundColor(.red)
                                        .font(.system(size: 14))
                                }
                            }
                            .frame(width: self.columnWidth)

                            Text(position.buyer.formatted)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.init(top: 1, leading: 8, bottom: 2, trailing: 8))
                                .background(
                                    Capsule(style: .continuous)
                                        .foregroundColor(self.viewModel.colorFor(position.buyer))
                                )
                                .frame(width: self.columnWidth)

                            Text(position.owner.formatted)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.init(top: 1, leading: 8, bottom: 2, trailing: 8))
                                .background(
                                    Capsule(style: .continuous)
                                        .foregroundColor(self.viewModel.colorFor(position.owner))
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
                                Text("Delete position")
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
                .disabled(viewModel.ellipsisModeDisabled),
                trailing: Button(action: { self.editOverlayParams = .shownAdding() }) {
                    Image(systemName: "plus")
                        .frame(width: 32, height: 32)
                }
            )
            .accessibility(identifier: "ReceiptView.receiptPositions")
        }
        .sheet(isPresented: $editOverlayParams.show) {
            ZStack {
                self.createEditOverlayView()
                self.itemAddedView()
                    .opacity(self.viewModel.itemAdded ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3))
            }
        }
        .actionSheet(isPresented: $presentingOptionsMenu) {
            ActionSheet(title: Text("Actions"), buttons: [
                .destructive(Text("Delete all"), action: { self.viewModel.removeAllPositions() }),
                .cancel()
            ])
        }
    }

    private func createEditOverlayView() -> some View {
        editOverlayParams.providePosition(viewModel.positions.first)
        return editOverlayViewFactory.create(presentingParams: $editOverlayParams) {
            viewModel.subscribe(
                addingPublisher: $0.positionAdded,
                editingPublisher: $0.positionEdited
            )
        }
    }

    private func itemAddedView() -> some View {
        Text("Item added")
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.init(.init(white: 0.5, alpha: 1)))
            )
            .offset(.init(width: 0, height: -UIScreen.main.bounds.height / 3))
    }
}

struct ReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().receiptView
    }
}
