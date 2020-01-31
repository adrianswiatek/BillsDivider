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
                HStack {
                    Text("Number of people:")
                    Spacer()
                    Text(viewModel.formattedNumberOfPeople)
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
                    ForEach(viewModel.peopleViewModel) { person in
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
        .onDisappear(perform: { self.viewModel.reset() })
    }

    private func personCell(for personViewModel: PersonViewModel) -> some View {
        VStack {
            HStack {
                TextField(
                    personViewModel.placeHolder,
                    text: self.$viewModel.peopleViewModel[self.viewModel.index(of: personViewModel)].name
                )

                Button(action: {
                    withAnimation(.easeOut) {
                        personViewModel.hasDetailsOpened.toggle()
                    }
                }) {
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(personViewModel.hasDetailsOpened ? 180 : 0))
                }
                .frame(width: 44, height: 44)
            }
            .frame(height: 44)
            .padding(.init(top: 0, leading: 24, bottom: personViewModel.hasDetailsOpened ? -8 : 0, trailing: 16))

            if personViewModel.hasDetailsOpened {
                personDetailsCell(for: personViewModel)
                    .frame(height: 44)
                    .padding(.horizontal, 24)
                    .background(Color.white)
            }
        }
    }

    private func personDetailsCell(for personViewModel: PersonViewModel) -> some View {
        HStack {
            Text("Color:")
                .font(.system(size: 14))
            Spacer()
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().settingsView
    }
}
