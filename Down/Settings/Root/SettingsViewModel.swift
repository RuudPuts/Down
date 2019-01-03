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

    var input = Input()
    lazy var output = transform(input: input)

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension SettingsViewModel: ReactiveBindable {
    struct Input {
        let itemSelected = PublishSubject<IndexPath>()
    }

    struct Output {
        let title: Driver<String>
        let welcomeMessage: Driver<String>

        let sectionData: Driver<[SettingsSectionModel]>

        let navigateToDetails: Observable<ApiApplication>
    }
}

extension SettingsViewModel {
    func transform(input: Input) -> Output {
        let showWelcomeMessageDriver = Driver.just(!dependencies.persistence.anyApplicationConfigured)
        let titleDriver = showWelcomeMessageDriver.map { $0 ? "Welcome to Down!" : "Settings" }
        let welcomeMessageDriver: Driver<String> = showWelcomeMessageDriver.map {
            guard $0 else { return String() }

            return "\nTo get started configure your downloader and indexers below\n"
        }

        let applicationSections = Driver.just([
            makeSectionModel(for: .download),
            makeSectionModel(for: .dvr),
            makeSectionModel(for: .dmr)
        ])

        let navigateToDetailsDriver = input.itemSelected
            .withLatestFrom(applicationSections) { indexPath, sections in
                return sections[indexPath.section].applications[indexPath.row]
            }
            .map { self.dependencies.persistence.load(type: $0.type) ?? self.dependencies.persistence.makeApplication(ofType: $0.type) }

        return Output(title: titleDriver,
                      welcomeMessage: welcomeMessageDriver,
                      sectionData: applicationSections,
                      navigateToDetails: navigateToDetailsDriver)
    }

    private func makeSectionModel(for type: ApiApplicationType) -> SettingsSectionModel {
        let title: String
        let applicationTypes: [DownApplicationType]
        switch type {
        case .download:
            title = "Downloaders"
            applicationTypes = [.sabnzbd]
        case .dvr:
            title = "TV show indexers"
            applicationTypes = [.sickbeard, .sickgear]
        case .dmr:
            title = "Movie indexers"
            applicationTypes = [.couchpotato]
        }

        let refinedApplications = applicationTypes.map { type -> RefinedApplication in
            let isConfigured = self.dependencies.persistence.isConfigured(type: type)
            let isActive = self.dependencies.persistence.isActive(type: type)

            return RefinedApplication(type: type,
                                      isConfigured: isConfigured,
                                      isActive: isActive)
        }

        return SettingsSectionModel(applicationType: type, title: title, applications: refinedApplications)
    }
}

extension SettingsViewModel {
    struct RefinedApplication {
        var type: DownApplicationType
        var isConfigured: Bool
        var isActive: Bool
    }
}
