import BillsDivider_ViewModel
import SwiftUI

struct SettingsView2: View {
    @ObservedObject var viewModel: SettingsViewModel

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
                .padding(.vertical, 8)

                VStack {
                    ForEach(viewModel.people.asArray) { person in
                        HStack {
                            TextField(
                                self.viewModel.placeholder(for: person),
                                text: self.$viewModel.peopleNames[self.viewModel.index(of: person)]
                            )
                                .padding(.leading, 8)

                            Button(action: {}) {
                                Image(systemName: "chevron.down")
                            }
                            .frame(width: 44, height: 44)
                        }
                        .padding(.horizontal, 16)
                    }
                    .background(
                        Rectangle()
                            .stroke(Color("SettingsSeparator"), lineWidth: 0.5)
                            .background(Color("SettingsPeopleCellBackground"))
                    )
                    .padding(.vertical, -4)

                    if viewModel.canAddPerson() {
                        newPersonCell
                            .padding(.vertical, 8)
                    }
                }
            }
            .navigationBarTitle("Settings")
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
