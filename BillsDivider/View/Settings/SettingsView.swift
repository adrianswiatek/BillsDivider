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
                    Stepper(value: $viewModel.numberOfPeople, in: viewModel.peopleRange) {
                        Text("Number of People:")
                            .font(.footnote)
                        Text(viewModel.numberOfPeople.description)
                            .fontWeight(.bold)
                    }
                }

                Section(header: Text("People")) {
                    List {
                        ForEach(viewModel.people, id: \.self) {
                            Text($0)
                                .padding(.horizontal, 8)
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
        SettingsView(SettingsViewModel())
    }
}
