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
        let titleDriver = showWelcomeMessageDriver.map { $0 ? "Down" : "Settings" }
        let welcomeMessageDriver: Driver<String> = showWelcomeMessageDriver.map {
            guard $0 else { return String() }

            return "Welcome to Down!\n\nTo get started configure your downloader and indexers below"
        }

        let applicationSections = Driver.just([
                (type: ApiApplicationType.download, title: "Downloaders"),
                (type: ApiApplicationType.dvr, title: "TV show indexers"),
                (type: ApiApplicationType.dmr, title: "Movie indexers")
            ])
            .map {
                $0.map { type, title -> SettingsSectionModel in
                    self.makeSectionModel(for: type, withTitle: title)
                }
            }

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

    private func makeSectionModel(for type: ApiApplicationType, withTitle title: String) -> SettingsSectionModel {
        let applicationTypes: [DownApplicationType]
        switch type {
        case .download: applicationTypes = [.sabnzbd]
        case .dvr: applicationTypes = [.sickbeard, .sickgear]
        case .dmr: applicationTypes = [.couchpotato]
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
