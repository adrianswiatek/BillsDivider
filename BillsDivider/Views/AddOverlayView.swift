import SwiftUI

struct AddOverlayView: View {
    @Binding var presenting: Bool

    @State private var priceText: String = ""
    @State private var buyer: Buyer = .me
    @State private var owner: Owner = .all
    @State private var addAnother: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Price")) {
                        HStack {
                            TextField("0.00", text: $priceText)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 42, weight: .medium, design: .rounded))
                                .keyboardType(.decimalPad)
                                .padding(.horizontal)
                        }
                        .padding(.init(top: 2, leading: 24, bottom: 2, trailing: 0))
                    }

                    Section(header: Text("Buyer")) {
                        Picker(selection: $buyer, label: Text("Buyer")) {
                            Text("Me").tag(Buyer.me)
                            Text("Not me").tag(Buyer.notMe)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    Section(header: Text("Owner")) {
                        Picker(selection: $owner, label: Text("Buyer")) {
                            Text("Me").tag(Owner.me)
                            Text("Not me").tag(Owner.notMe)
                            Text("All").tag(Owner.all)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    Section {
                        Toggle("Add another", isOn: $addAnother)
                            .foregroundColor(Color(white: 0.4))
                            .font(.footnote)
                    }

                    Section {
                        Button(action: { self.presenting = false }) {
                            HStack {
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                Text("CONFIRM")
                                Spacer()
                            }
                        }
                        .disabled(priceText.isEmpty)
                    }
                }
            }
            .navigationBarTitle(Text("Add position"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: { self.presenting = false }) {
                Image(systemName: "xmark")
                    .frame(width: 24, height: 24)
            })
        }
    }
}

struct AddOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        AddOverlayView(presenting: .constant(true))
    }
}
