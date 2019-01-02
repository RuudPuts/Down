//
//  DvrEpisodeCell.swift
//  Down
//
//  Created by Ruud Puts on 23/09/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit
import RxSwift
import XLActionController

protocol DownCellDelegate: class {
    func cellNeedsLayout(_ cell: UITableViewCell)
}

class DvrEpisodeCell: UITableViewCell {
    typealias Dependencies = DvrEpisodeCellModel.Dependencies & ErrorHandlerDependency
    var dependencies: Dependencies!

    weak var delegate: DownCellDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var plotContainer: UIStackView!
    @IBOutlet weak var plotActivityView: ActivityView!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var airLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!

    private var viewModel: DvrEpisodeCellModel!
    private var disposeBag: DisposeBag!

    private weak var context: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()

        plotContainer.isHidden = true
        statusButton.isHidden = true

        applyStyling()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = nil
        viewModel = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        plotContainer.isHidden = !selected
        statusButton.isHidden = !selected

        guard selected else {
            return
        }

        viewModel.input.fetchPlot.onNext(Void())
    }

    private func applyStyling() {
        style(as: .defaultTableViewCell)
        selectionStyle = .none
        
        nameLabel.style(as: .titleLabel)
        airLabel.style(as: .detailLabel)
        statusLabel.style(as: .detailLabel)
        
        plotLabel.style(as: .detailLabel)
        statusButton.style(as: .successButton)
        statusButton.setTitle("Set status", for: .normal)
    }
}

private extension DvrEpisodeCell {
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

extension DvrEpisodeCell: ReactiveBinding {
    typealias Bindable = DvrEpisodeCellModel

    func bind(input: DvrEpisodeCellModel.Input) {
        statusButton.rx.tap
            .flatMap { _ in self.showStatusPicker() }
            .bind(to: input.setStatus)
            .disposed(by: disposeBag)
    }

    func bind(output: DvrEpisodeCellModel.Output) {
        output.episode.map { $0.title }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)

        output.episode.map { $0.airingOn }
            .bind(to: airLabel.rx.text)
            .disposed(by: disposeBag)

        output.episode.map { $0.statusDescription }
            .bind(to: statusLabel.rx.text)
            .disposed(by: disposeBag)

        output.episode.map { $0.status }
            .map { ViewStyling.episodeStatusLabel($0) }
            .bind(to: statusLabel.rx.style)
            .disposed(by: disposeBag)

        bindPlot(output)
        bindStatusChanged(output)
    }

    private func bindPlot(_ output: DvrEpisodeCellModel.Output) {
        output.episode.map { $0.plot }
            .bind(to: plotLabel.rx.text)
            .disposed(by: disposeBag)

        let plotAvailable = output.episode
            .map { $0.plot != nil }
            .startWith(true)
            .asDriver(onErrorJustReturn: true)

        plotAvailable
            .map { !$0 }
            .drive(plotLabel.rx.isHidden)
            .disposed(by: disposeBag)

        plotAvailable
            .drive(plotActivityView.rx.isHidden)
            .disposed(by: disposeBag)

        output.plotFetched
            .delay(0.1, scheduler: MainScheduler.instance)
            .do(onNext: { _ in
                DispatchQueue.main.async {
                    self.setNeedsLayout()
                    self.delegate?.cellNeedsLayout(self)
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func bindStatusChanged(_ output: DvrEpisodeCellModel.Output) {
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

extension DvrEpisodeCell {
    func configure(with episode: DvrEpisode, dependencies: Dependencies, context: UIViewController? = nil) {
        self.dependencies = dependencies
        self.context = context

        plotActivityView.configure(for: dependencies.dvrApplication.downType)

        disposeBag = DisposeBag()
        viewModel = DvrEpisodeCellModel(dependencies: dependencies, episode: episode)
        bind(to: viewModel)
    }
}
