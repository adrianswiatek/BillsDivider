import SwiftUI

struct SettingsView: View {
    @State private var numberOfPeople: Int = 2

    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        return numberFormatter
    }

    private var people: [String] {
        ["Me"] + (2...numberOfPeople).map { "\(numberFormatter.string(for: $0)!) person" }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Stepper(value: $numberOfPeople, in: 2...10) {
                        Text("Number of People:")
                            .font(.footnote)
                        Text(numberOfPeople.description)
                            .fontWeight(.bold)
                    }
                }

                Section(header: Text("People")) {
                    List {
                        ForEach(people, id: \.self) {
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
        SettingsView().environment(\.colorScheme, .dark)
    }
}
