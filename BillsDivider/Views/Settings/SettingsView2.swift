import BillsDivider_Model
import BillsDivider_ViewModel
import SwiftUI

struct SettingsView2: View {
    @ObservedObject var viewModel: SettingsViewModel

    @State private var showDetails: Bool = false
    @State private var selectedColor: Color = .green

    private let colors: [Color] = [.green, .blue, .purple, .pink, .red, .orange]

    init(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text("Number of people:")
                    Spacer()
                    Text(viewModel.people.count.description)
                }
                .font(.headline)
                .padding(.init(top: 16, leading: 16, bottom: 8, trailing: 16))

                Color("SettingsSeparator")
                    .frame(width: UIScreen.main.bounds.width - 32, height: 0.5)

                HStack {
                    Text("People:")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 4)

                VStack {
                    ForEach(viewModel.people.asArray.prefix(1)) { person in
                        self.personCell(for: person)
                    }
                    .background(Color("SettingsPeopleCellBackground"))

                    if viewModel.canAddPerson() {
                        newPersonCell
                            .padding(.vertical, 8)
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }

    private func personCell(for person: Person) -> some View {
        VStack {
            HStack {
                TextField(
                    self.viewModel.placeholder(for: person),
                    text: self.$viewModel.peopleNames[self.viewModel.index(of: person)]
                )

                Button(action: {
                    withAnimation(.easeOut) {
                        self.showDetails.toggle()
                    }
                }) {
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(showDetails ? 180 : 0))
                }
                .frame(width: 44, height: 44)
            }
            .frame(height: 44)
            .padding(.init(top: 0, leading: 24, bottom: showDetails ? -8 : 0, trailing: 16))

            if showDetails {
                personDetailsCell
                    .frame(height: 44)
                    .padding(.horizontal, 24)
                    .background(Color.white)
            }
        }
    }

    private var personDetailsCell: some View {
        HStack {
            Text("Color:")
                .font(.system(size: 14))
            Spacer()
            ForEach(self.colors, id: \.hashValue) { color in
                Button(action: { self.selectedColor = color }) {
                    ZStack {
                        Circle()
                            .frame(width: 28, height: 28)
                            .foregroundColor(color)
                            .shadow(radius: 1)

                        if self.selectedColor == color {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }

    private var newPersonCell: some View {
        VStack {
            HStack {
                Button(action: { self.viewModel.addPerson() }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("New person")
                    }
                }
                .padding(.horizontal, 16)
                Spacer()
            }

            Color("SettingsSeparator")
                .frame(width: UIScreen.main.bounds.width - 32, height: 0.5)
        }
    }
}

struct SettingsView2_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().settingsView2
    }
}
