import BillsDivider_Model
import BillsDivider_ViewModel
import SwiftUI

struct ReceiptView: View {
    private enum OverlayViewType {
        case unset
        case position(params: EditOverlayViewParams)
        case reduction
    }

    @ObservedObject private var viewModel: ReceiptViewModel

    @State private var overlayViewType: OverlayViewType = .unset
    @State private var editOverlayParams: EditOverlayViewParams = .adding

    @State private var presentingOverlay: Bool = false
    @State private var presentingOptionsMenu: Bool = false
    
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
            ZStack(alignment: .bottomTrailing) {
                List {
                    Section(header: ReceiptHeaderView()) {
                        ForEach(viewModel.positions) { position in
                            self.row(forPosition: position)
                                .contextMenu {
                                    Button(action: { self.editOverlayParams = .editing(withPosition: position) }) {
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
                .accessibility(identifier: "ReceiptView.receiptPositions")

                ReceiptActionButtons(
                    isEllipsisButtonEnabled: !viewModel.ellipsisModeDisabled,
                    onEllipsisButtonTapped: { self.presentingOptionsMenu = true },
                    onMinusButtonTapped: {
                        self.overlayViewType = .reduction
                        self.presentingOverlay = true
                    },
                    onPlusButtonTapped: {
                        self.overlayViewType = .position(params: .adding)
                        self.presentingOverlay = true
                    }
                )
                .padding(.init(top: 0, leading: 0, bottom: 20, trailing: 16))
            }
            .navigationBarTitle(Text("Receipt"), displayMode: .large)
            .sheet(isPresented: $presentingOverlay) {
                self.overlayView
            }
            .actionSheet(isPresented: $presentingOptionsMenu) {
                ActionSheet(title: Text("Actions"), buttons: [
                    .destructive(Text("Delete all"), action: { self.viewModel.removeAllPositions() }),
                    .cancel()
                ])
            }
        }
    }

    private var overlayView: some View {
        switch overlayViewType {
        case .reduction:
            return AnyView(createReductionOverlayView())
        case .position:
            return AnyView(ZStack {
                createEditOverlayView()
                itemAddedView()
                    .opacity(viewModel.itemAdded ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3))
            })
        default:
            preconditionFailure("Unsupported OverlayViewType.")
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

            ReceiptPersonView(name: position.buyer.formatted, color: viewModel.colorFor(position.buyer))

            Text("|")
                .foregroundColor(.secondary)
                .padding(.horizontal, -4)

            ReceiptPersonView(name: position.owner.formatted, color: viewModel.colorFor(position.owner))
        }
        .padding(.horizontal, 4)
    }

    private func createEditOverlayView() -> some View {
        editOverlayParams.providePosition(viewModel.positions.first)
        return editOverlayViewFactory.create(presenting: $presentingOverlay, parameters: editOverlayParams) {
            viewModel.subscribe(
                addingPublisher: $0.positionAdded,
                editingPublisher: $0.positionEdited
            )
        }
    }

    private func createReductionOverlayView() -> some View {
        reductionOverlayViewFactory.create(presenting: $presentingOverlay) {
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
