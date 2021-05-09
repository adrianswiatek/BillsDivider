import BillsDivider_ViewModel
import SwiftUI

public final class TabsViewCoordinator {
    public var receiptView: some View {
        ReceiptView(receiptViewModel, receiptViewCoordinator)
    }

    public var summaryView: some View {
        SummaryView(summaryViewModel)
    }

    public var settingsView: some View {
        SettingsView(settingsViewModel)
    }

    private let receiptViewCoordinator: ReceiptViewCoordinator
    private let receiptViewModel: ReceiptViewModel
    private let summaryViewModel: SummaryViewModel
    private let settingsViewModel: SettingsViewModel

    public init(
        _ receiptViewCoordinator: ReceiptViewCoordinator,
        _ receiptViewModel: ReceiptViewModel,
        _ summaryViewModel: SummaryViewModel,
        _ settingsViewModel: SettingsViewModel
    ) {
        self.receiptViewModel = receiptViewModel
        self.receiptViewCoordinator = receiptViewCoordinator
        self.summaryViewModel = summaryViewModel
        self.settingsViewModel = settingsViewModel
    }
}
