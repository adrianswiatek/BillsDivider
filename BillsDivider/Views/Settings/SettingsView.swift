import BillsDivider_ViewModel
import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    init(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            ScrollView {
                Separator()

//                numberOfPeople
//                    .padding(.init(top: 16, leading: 16, bottom: 8, trailing: 16))

                people
                    .padding(.init(top: 8, leading: 16, bottom: 4, trailing: 16))

                VStack(alignment: .center, spacing: 0) {
                    ForEach(viewModel.peopleViewModel) { person in
                        self.cells(for: person)
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
        .onDisappear(perform: { self.viewModel.reset() })
    }

    private var numberOfPeople: some View {
        HStack {
            Text("Number of people:")
            Spacer()
            Text(viewModel.formattedNumberOfPeople)
        }
        .font(.headline)
    }

    private var people: some View {
        HStack {
            Text("People:")
                .font(.headline)
            Spacer()
        }
    }

    private func cells(for personViewModel: PersonViewModel) -> some View {
        VStack {
            basicCell(for: personViewModel)
                .frame(height: 44)
                .padding(.init(top: 0, leading: 24, bottom: personViewModel.hasDetailsOpened ? -8 : 0, trailing: 16))

            if personViewModel.hasDetailsOpened {
                detailsCell(for: personViewModel)
                    .frame(height: 44)
                    .padding(.horizontal, 24)
                    .background(Color("SettingsPeopleDetailCellBackground"))
            }
        }
    }

    private func basicCell(for personViewModel: PersonViewModel) -> some View {
        HStack {
            TextField(
                personViewModel.placeHolder,
                text: self.$viewModel.peopleViewModel[self.viewModel.index(of: personViewModel)].name
            )
            .accessibility(identifier: "SettingsView.PersonsTextField")

            Button(
                action: {
                    withAnimation(.easeOut) { personViewModel.hasDetailsOpened.toggle() }
                },
                label: {
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(personViewModel.hasDetailsOpened ? 180 : 0))
                }
            )
            .frame(width: 44, height: 44)
            .accessibility(identifier: "SettingsView.ChevronButton")
        }
    }

    private func detailsCell(for personViewModel: PersonViewModel) -> some View {
        HStack {
            Text("Color:")
                .font(.system(size: 14))
                .accessibility(identifier: "SettingsView.ColorText")
            Spacer()
            colors(for: personViewModel)
        }
    }

    private func colors(for personViewModel: PersonViewModel) -> some View {
        ForEach(self.viewModel.colors, id: \.hashValue) { color in
            Button(action: { personViewModel.color = color }) {
                ZStack {
                    Circle()
                        .frame(width: 28, height: 28)
                        .foregroundColor(color)
                        .shadow(radius: 1)

                    if personViewModel.color == color {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
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

            Separator()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().settingsView
    }
}
