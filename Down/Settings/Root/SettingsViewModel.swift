//
//  SettingsViewModel.swift
//  Down
//
//  Created by Ruud Puts on 02/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import DownKit

import RxSwift
import RxCocoa

struct SettingsViewModel: Depending {
    typealias Dependencies = ApplicationPersistenceDependency
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension SettingsViewModel: ReactiveBindable {
    struct Input {
        let itemSelected: ControlEvent<IndexPath>
    }

    struct Output {
        let title: Driver<String>
        let welcomeMessage: Driver<String>

        let applications: Driver<[SettingsSectionModel]>

        let navigateToDetails: Observable<ApiApplication>
    }

    func transform(input: SettingsViewModel.Input) -> SettingsViewModel.Output {
        let showWelcomeMessageDriver = Driver.just(!dependencies.persistence.anyApplicationConfigured)
        let titleDriver = showWelcomeMessageDriver.map { $0 ? "Down" : "Settings" }
        let welcomeMessageDriver: Driver<String> = showWelcomeMessageDriver.map {
            guard $0 else { return String() }

            return "Welcome to Down!\n\nTo get started configure your downloader and indexers below"
        }

        let applicationsDriver = Driver.just([
            SettingsSectionModel(applicationType: .download, title: "Downloaders", applications: [.sabnzbd]),
            SettingsSectionModel(applicationType: .dvr, title: "Show indexers", applications: [.sickbeard, .sickgear]),
            SettingsSectionModel(applicationType: .dmr, title: "Movie indexers", applications: [.couchpotato])
        ])

        let navigateToDetailsDriver = input.itemSelected
            .withLatestFrom(applicationsDriver) { indexPath, sections in
                return sections[indexPath.section].applications[indexPath.row]
            }
            .map { self.dependencies.persistence.load(type: $0) ?? self.dependencies.persistence.makeApplication(ofType: $0) }

        return Output(title: titleDriver,
                        welcomeMessage: welcomeMessageDriver,
                        applications: applicationsDriver,
                        navigateToDetails: navigateToDetailsDriver)
    }
}
