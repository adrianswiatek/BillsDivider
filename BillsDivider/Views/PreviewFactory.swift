import BillsDivider_Model
import BillsDivider_ViewModel
import Combine
import SwiftUI

struct PreviewFactory {
    private let dependencyContainer: DependencyContainer

    init() {
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
        ReceiptHeaderView()
    }

    var editOverlayView: some View {
        let viewFactory: EditOverlayViewFactory = dependencyContainer.resolve(EditOverlayViewFactory.self)
        return viewFactory.create(presenting: .constant(true), parameters: .adding, configure: { _ in })
    }

    var priceSectionView: some View {
        let viewModel: PriceViewModel = dependencyContainer.resolve(PriceViewModel.self)
        let priceTextFieldFactory: PriceTextFieldFactory = dependencyContainer.resolve(PriceTextFieldFactory.self)
        return PriceSectionView(viewModel, priceTextFieldFactory)
    }

    var discountPopoverView: some View {
        let viewModel: EditOverlayViewModel = dependencyContainer.resolve(EditOverlayViewModel.self)
        let priceTextFieldFactory: PriceTextFieldFactory = dependencyContainer.resolve(PriceTextFieldFactory.self)
        return DiscountPopoverView(viewModel.discountPopoverViewModel, priceTextFieldFactory)
    }

    var discountSectionView: some View {
        let viewModel: EditOverlayViewModel = dependencyContainer.resolve(EditOverlayViewModel.self)
        return DiscountSectionView(viewModel.discountViewModel)
    }

    var discountTextFieldView: some View {
        let viewModel: DiscountPopoverViewModel = dependencyContainer.resolve(DiscountPopoverViewModel.self)
        let priceTextFieldFactory: PriceTextFieldFactory = dependencyContainer.resolve(PriceTextFieldFactory.self)
        return DiscountTextFieldView(viewModel, priceTextFieldFactory)
    }

    var buyerSectionView: some View {
        let viewModelFactory: EditOverlayViewModelFactory =
            dependencyContainer.resolve(EditOverlayViewModelFactory.self)
        let viewModel: EditOverlayViewModel = viewModelFactory.create(.constant(true), .adding)
        return BuyerSectionView(viewModel.buyerViewModel)
    }

    var ownerSectionView: some View {
        let viewModelFactory: EditOverlayViewModelFactory =
            dependencyContainer.resolve(EditOverlayViewModelFactory.self)
        let viewModel: EditOverlayViewModel = viewModelFactory.create(.constant(true), .adding)
        return OwnerSectionView(viewModel.ownerViewModel)
    }

    var reductionSectionView: some View {
        let viewModel: PriceViewModel = dependencyContainer.resolve(PriceViewModel.self)
        let priceTextFieldFactory: PriceTextFieldFactory = dependencyContainer.resolve(PriceTextFieldFactory.self)
        return ReductionSectionView(viewModel, priceTextFieldFactory)
    }

    var summaryView: some View {
        dependencyContainer.resolve(SummaryView.self) as AnyView
    }

    var settingsView: some View {
        dependencyContainer.resolve(SettingsView.self) as AnyView
    }
}
