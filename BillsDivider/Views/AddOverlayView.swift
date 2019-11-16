import SwiftUI

struct AddOverlayView: View {
    @Binding var presenting: Bool

    @State private var priceText: String = ""
    @State private var buyer: Buyer = .me
    @State private var owner: Owner = .all

    var body: some View {
        VStack {
            HStack {
                Button(action: { self.presenting = false }) {
                    Image(systemName: "xmark")
                        .frame(width: 24, height: 24)
                }
                Spacer()
                Text("Add position")
                Spacer()
            }
            .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(Color(white:0.9))
            .cornerRadius(16)
            .padding(.bottom)

            HStack {
                Image(systemName: "dollarsign.circle")
                    .foregroundColor(.gray)
                    .font(.system(size: 24))
                TextField("0.00", text: $priceText)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 42, weight: .medium, design: .rounded))
                    .keyboardType(.decimalPad)
                    .padding(.horizontal)
            }
            .padding(.init(top: 2, leading: 24, bottom: 2, trailing: 0))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(lineWidth: 0.5))

            VStack {
                HStack {
                    Text("Buyer")
                        .font(.body)
                        .foregroundColor(.gray)
                        .frame(width: 75)
                    Picker(selection: $buyer, label: Text("Buyer")) {
                        Text("Me").tag(Buyer.me)
                        Text("Not me").tag(Buyer.notMe)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                HStack {
                    Text("Owner")
                        .font(.body)
                        .foregroundColor(.gray)
                        .frame(width: 75)
                    Picker(selection: $owner, label: Text("Buyer")) {
                        Text("Me").tag(Owner.me)
                        Text("Not me").tag(Owner.notMe)
                        Text("All").tag(Owner.all)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .padding(.vertical)

            Button(action: { self.presenting = false }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                    Text("Confirm")
                        .foregroundColor(.white)
                }
                .padding(.init(top: 8, leading: 48, bottom: 8, trailing: 48))
                .background(Color.blue)
                .cornerRadius(16)
            }
            .padding(.vertical)

            Spacer()
        }
        .padding(.init(top: 24, leading: 16, bottom: 24, trailing: 16))
    }
}

struct AddOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        AddOverlayView(presenting: .constant(true))
    }
}
