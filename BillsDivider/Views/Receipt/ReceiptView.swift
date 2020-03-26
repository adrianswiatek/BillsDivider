import BillsDivider_Model
import BillsDivider_ViewModel
import SwiftUI

struct ReceiptView: View {
    @ObservedObject private var viewModel: ReceiptViewModel
    
    @State private var editOverlayParams: EditOverlayViewParams = .hidden
    @State private var presentingOptionsMenu: Bool = false
    @State private var presentingReductionOverlay: Bool = false
    
    private let editOverlayViewFactory: EditOverlayViewFactory
    private let reductionOverlayViewFactory: ReductionOverlayViewFactory
    
    init(
        _ viewModel: ReceiptViewModel,
        _ editOverlayViewFactory: EditOverlayViewFactory,
        _ reductionOverlayViewFactory: ReductionOverlayViewFactory
    ) {
        self.viewModel = viewModel
        self.editOverlayViewFactory = editOverlayViewFactory
        self.reductionOverlayViewFactory = reductionOverlayViewFactory
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: ReceiptHeaderView()) {
                    ForEach(viewModel.positions) { position in
                        self.row(forPosition: position)
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
                trailing: Button(action: { self.presentingReductionOverlay = true }) {
                    Image(systemName: "plus")
                        .frame(width: 32, height: 32)
                }
//                trailing: Button(action: { self.editOverlayParams = .shownAdding() }) {
//                    Image(systemName: "plus")
//                        .frame(width: 32, height: 32)
//                }
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
        .sheet(isPresented: $presentingReductionOverlay) {
            self.createReductionOverlayView()
        }
        .actionSheet(isPresented: $presentingOptionsMenu) {
            ActionSheet(title: Text("Actions"), buttons: [
                .destructive(Text("Delete all"), action: { self.viewModel.removeAllPositions() }),
                .cancel()
            ])
        }
    }

    private func row(forPosition position: ReceiptPosition) -> some View {
        HStack {
            HStack(spacing: 4) {
                if position.hasDiscount {
                    DiscountSign()
                        .font(.system(size: 12))
                }

                Text(self.viewModel.formatNumber(value: position.amountWithDiscount))
                    .font(.system(size: 22))
                    .bold()
                    .accessibility(identifier: "ReceiptView.ValueStaticText")
            }

            Spacer()

            personsCapsule(name: position.buyer.formatted, color: viewModel.colorFor(position.buyer))

            Text("|")
                .foregroundColor(.secondary)
                .padding(.horizontal, -4)

            personsCapsule(name: position.owner.formatted, color: viewModel.colorFor(position.owner))
        }
        .padding(.horizontal, 4)
    }

    private func personsCapsule(name: String, color: Color) -> some View {
        Text(name)
            .padding(.init(top: 1, leading: 8, bottom: 2, trailing: 8))
            .background(
                Capsule(style: .continuous)
                    .foregroundColor(color)

            )
            .lineLimit(1)
            .foregroundColor(.white)
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

    private func createReductionOverlayView() -> some View {
        reductionOverlayViewFactory.create(presenting: $presentingReductionOverlay) {
            viewModel.subscribe(reducingPublisher: $0.reductionAdded)
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
