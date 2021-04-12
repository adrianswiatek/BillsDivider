import BillsDivider_ViewModel
import SwiftUI

public struct ReceiptView2: View {
    @State private var isActionSheetVisible: Bool = false

    @ObservedObject private var viewModel: ReceiptViewModel2
    private var addPositionView: AddPositionView

    public init(_ viewModel: ReceiptViewModel2, _ addPositionView: AddPositionView) {
        self.viewModel = viewModel
        self.addPositionView = addPositionView
    }

    public var body: some View {
        NavigationView {
            List {
                Section(header: header) {
                    ForEach(viewModel.positions, id: \.id) { position in
                        rowForPosition(position)
                            .contextMenu {
                                Button {
                                    viewModel.removePosition(position)
                                } label: {
                                    Text("Edit position")
                                    Image(systemName: "pencil")
                                }
                                Button {
                                    withAnimation { viewModel.removePosition(position) }
                                } label: {
                                    Text("Remove position")
                                    Image(systemName: "trash")
                                }
                            }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .actionSheet(isPresented: $isActionSheetVisible) {
                ActionSheet(title: Text("More"), message: nil, buttons: [
                    .destructive(Text("Remove all")) {
                        withAnimation { viewModel.removeAllPositions() }
                    },
                    .cancel()
                ])
            }
            .navigationTitle(Text("Receipt"))
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                leading: Button(action: { isActionSheetVisible = true }) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .frame(width: 40, height: 40)
                },
                trailing: NavigationLink(destination: addPositionView) {
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
            Spacer()

            roleLabel(withText: "B")

            Divider()
                .padding(.vertical, 6)

            roleLabel(withText: "O")
        }
    }

    private func rowForPosition(_ position: ReceiptPositionViewModel) -> some View {
        func personCircle(withColor color: Color) -> some View {
            Circle()
                .fill(color)
                .frame(width: 25)
        }

        func price() -> some View {
            HStack(alignment: .firstTextBaseline) {
                Text(position.priceWithDiscount)
                    .font(.system(.title2, design: .monospaced))
                    .fontWeight(.bold)

                if let discount = position.discount {
                    HStack(spacing: 4) {
                        Text(position.price)
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.bold)

                        Text("-")
                            .font(.system(.caption2, design: .monospaced))

                        Text("\(discount)")
                            .font(.system(.caption2, design: .monospaced))
                    }
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 10)
                }
            }
        }

        return HStack {
            price()

            Spacer()

            personCircle(withColor: position.buyerColor)

            Divider()
                .padding(.vertical, 6)

            personCircle(withColor: position.ownerColor)
        }
        .padding(.vertical, 4)
    }
}

struct ReceiptView2_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PreviewFactory().receiptView2
                .preferredColorScheme(.light)

            PreviewFactory().receiptView2
                .preferredColorScheme(.dark)
        }
    }
}
