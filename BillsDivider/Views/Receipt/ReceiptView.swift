import BillsDivider_ViewModel
import SwiftUI

public struct ReceiptView: View {
    @State private var isNavigationActive: Bool = false
    @State private var isActionSheetVisible: Bool = false

    @ObservedObject private var viewModel: ReceiptViewModel
    @ObservedObject private var coordinator: ReceiptViewCoordinator

    public init(_ viewModel: ReceiptViewModel, _ coordinator: ReceiptViewCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }

    public var body: some View {
        NavigationView {
            List {
                Section(header: header) {
                    ForEach(viewModel.positions, id: \.id) { position in
                        rowForPosition(position)
                    }
                    .onDelete {
                        guard let index = $0.first else { return }
                        viewModel.removePosition(at: index)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .background(
                NavigationLink("", destination: coordinator.destinationView(), isActive: $isNavigationActive)
            )
            .actionSheet(isPresented: $isActionSheetVisible) {
                ActionSheet(title: Text("More actions"), message: nil, buttons: [
                    .default(Text("Add reduction")) {
                        coordinator.addReduction()
                        isNavigationActive = true
                    },
                    .destructive(Text("Remove all")) {
                        withAnimation {
                            viewModel.removeAllPositions()
                        }
                    },
                    .cancel()
                ])
            }
            .navigationTitle(Text("Receipt"))
            .navigationBarItems(
                leading:
                    Button {
                        isActionSheetVisible = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .frame(width: 40, height: 40)
                    }
                    .disabled(!viewModel.canShowMoreActions),
                trailing:
                    Button {
                        coordinator.addPosition()
                        isNavigationActive = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .frame(width: 40, height: 40)
                    }
            )
            .onAppear {
                viewModel.fetchPositions()
            }
        }
    }

    private var header: some View {
        func roleLabel(withText text: String) -> some View {
            Text(text)
                .font(.footnote)
                .foregroundColor(.gray)
                .frame(width: 25)
                .background(Circle().stroke(Color.clear))
        }

        return HStack {
            roleLabel(withText: "B")

            Divider()
                .padding(.vertical, 6)

            roleLabel(withText: "O")

            Spacer()
        }
    }

    private func rowForPosition(_ position: ReceiptPositionViewModel) -> some View {
        func personCircle(withColor color: Color) -> some View {
            Circle()
                .fill(color)
                .frame(width: 25)
        }

        func price() -> some View {
            HStack {
                if let discount = position.discount {
                    HStack(spacing: 4) {
                        Text(position.price)
                            .font(.system(.body, design: .monospaced))
                            .fontWeight(.bold)

                        Text("-")
                            .font(.system(.caption, design: .monospaced))

                        Text("\(discount)")
                            .font(.system(.caption, design: .monospaced))
                    }
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 10)
                }

                Spacer()

                Text(position.priceWithDiscount)
                    .font(.system(.title2, design: .monospaced))
                    .fontWeight(.bold)
                    .padding(.trailing, 8)
            }
        }

        return HStack {
            personCircle(withColor: position.buyerColor)

            Divider()
                .padding(.vertical, 6)

            personCircle(withColor: position.ownerColor)

            Spacer()

            price()
        }
        .contextMenu {
            editButtonForPosition(position)
            removeButtonForPosition(position)
        }
        .padding(.vertical, 4)
    }

    private func editButtonForPosition(_ position: ReceiptPositionViewModel) -> some View {
        Button {
            let action = position.isReduction ? coordinator.editReduction : coordinator.editPosition
            action(position.id)
            isNavigationActive = true
        } label: {
            Image(systemName: "pencil")
            Text("Edit \(position.isReduction ? "reduction" : "position")")
        }
    }

    private func removeButtonForPosition(_ position: ReceiptPositionViewModel) -> some View {
        Button {
            viewModel.removePosition(with: position.id)
        } label: {
            Image(systemName: "trash")
            Text("Remove \(position.isReduction ? "reduction" : "position")")
        }
    }
}

struct ReceiptView2_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PreviewFactory().receiptView
                .preferredColorScheme(.light)

            PreviewFactory().receiptView
                .preferredColorScheme(.dark)
        }
    }
}
