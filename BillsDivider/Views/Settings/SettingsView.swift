import BillsDivider_ViewModel
import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    init(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Number of people:")
                            .font(.footnote)
                        Text(viewModel.people.count.description)
                            .fontWeight(.bold)
                    }
                }

                Section(header: Text("People")) {
                    List {
                        ForEach(viewModel.people.asArray) { person in
                            HStack {
                                TextField(
                                    self.viewModel.placeholder(for: person),
                                    text: self.$viewModel.peopleNames[self.viewModel.index(of: person)]
                                )
                                .padding(.horizontal, 8)
                            }
                        }

                        if viewModel.canAddPerson() {
                            Button(action: { self.viewModel.addPerson() }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("New person")
                                }
                                .padding(.horizontal, 8)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().settingsView
    }
}
