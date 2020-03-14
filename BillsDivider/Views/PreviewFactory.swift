import BillsDivider_Model
import BillsDivider_ViewModel
import Combine
import SwiftUI

struct PreviewFactory {
    private let dependencyContainer: DependencyContainer
    private let receiptListColumnWidth: CGFloat

    init() {
        receiptListColumnWidth = UIScreen.main.bounds.width / 3
        dependencyContainer = DependencyContainer(.testing)
    }
}

extension PreviewFactory {
    var tabsView: some View {
        dependencyContainer.resolve(TabsView.self) as AnyView
    }

    var receiptView: some View {
        dependencyContainer.resolve(ReceiptView.self) as AnyView
    }

    var receiptHeaderView: some View {
        ReceiptHeaderView(receiptListColumnWidth)
    }

    var editOverlayView: some View {
        let viewFactory: EditOverlayViewFactory = dependencyContainer.resolve(EditOverlayViewFactory.self)
        return viewFactory.create(presentingParams: .constant(.shownAdding()), configure: { _ in })
    }

    var priceSectionView: some View {
        let viewModel: PriceViewModel = dependencyContainer.resolve(PriceViewModel.self)
        return PriceSectionView(viewModel)
    }

    var discountPopoverView: some View {
        let viewModel: EditOverlayViewModel = dependencyContainer.resolve(EditOverlayViewModel.self)
        return DiscountPopoverView(viewModel.discountPopoverViewModel)
    }

    var discountSectionView: some View {
        let viewModel: DiscountViewModel = dependencyContainer.resolve(DiscountViewModel.self)
        return DiscountSectionView(viewModel)
    }

    var discountTextFieldView: some View {
        let viewModel: DiscountPopoverViewModel = dependencyContainer.resolve(DiscountPopoverViewModel.self)
        return DiscountTextFieldView(viewModel)
    }

    var buyerSectionView: some View {
        let viewModelFactory: EditOverlayViewModelFactory =
            dependencyContainer.resolve(EditOverlayViewModelFactory.self)

        return BuyerSectionView(viewModelFactory.create(with: .constant(.shownAdding())))
    }

    var ownerSectionView: some View {
        let viewModelFactory: EditOverlayViewModelFactory =
            dependencyContainer.resolve(EditOverlayViewModelFactory.self)

        return OwnerSectionView(viewModelFactory.create(with: .constant(.shownAdding())))
    }

    var summaryView: some View {
        dependencyContainer.resolve(SummaryView.self) as AnyView
    }

    var settingsView: some View {
        dependencyContainer.resolve(SettingsView.self) as AnyView
    }
}
