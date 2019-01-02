//
//  DvrSeasonTableHeaderView.swift
//  Down
//
//  Created by Ruud Puts on 15/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import XLActionController

class DvrSeasonTableHeaderView: UITableViewHeaderFooterView {
    typealias Dependencies = DvrSeasonTableHeaderViewModel.Dependencies & ErrorHandlerDependency
    var dependencies: Dependencies!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var statusButton: UIButton!

    private var viewModel: DvrSeasonTableHeaderViewModel!
    private var disposeBag: DisposeBag!

    private weak var context: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView()

        applyStyling()
    }

    private func applyStyling() {
        backgroundView?.style(as: .backgroundView)
        label.style(as: .headerLabel)
    }
}

private extension DvrSeasonTableHeaderView {
    func showStatusPicker() -> PublishSubject<DvrEpisodeStatus> {
        let actionController = DownActionController(applicationType: viewModel.dependencies.dvrApplication.downType)

        let selectedStatus = PublishSubject<DvrEpisodeStatus>()
        DvrEpisodeCellModel.settableStatusses.forEach { status in
            actionController.addAction(title: status.displayString, handler: { _ in
                selectedStatus.onNext(status)
            })
        }

        actionController.addSection(Section())
        actionController.addAction(title: "Cancel", style: .cancel)

        context?.present(actionController, animated: true, completion: nil)

        return selectedStatus
    }
}

extension DvrSeasonTableHeaderView: ReactiveBinding {
    typealias Bindable = DvrSeasonTableHeaderViewModel

    func bind(input: DvrSeasonTableHeaderViewModel.Input) {
        statusButton.rx.tap
            .flatMap { _ in self.showStatusPicker() }
            .bind(to: input.setStatus)
            .disposed(by: disposeBag)
    }

    func bind(output: DvrSeasonTableHeaderViewModel.Output) {
        output.season.map { $0.title }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)

        output.statusChanged
            .subscribeResult(onFailure: {
                guard let context = self.context else {
                    return
                }

                self.dependencies.errorHandler.handle(error: $0, action: .dvr_setEpisodeStatus, source: context)
            })
            .disposed(by: disposeBag)
    }
}

extension DvrSeasonTableHeaderView {
    func configure(with season: DvrSeason, dependencies: Dependencies, context: UIViewController? = nil) {
        self.dependencies = dependencies
        self.context = context

        statusButton.style(as: .contextButton(dependencies.dvrApplication.downType))

        disposeBag = DisposeBag()
        viewModel = DvrSeasonTableHeaderViewModel(dependencies: dependencies, season: season)
        bind(to: viewModel)
    }
}
