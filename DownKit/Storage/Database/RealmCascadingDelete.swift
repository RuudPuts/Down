//
//  RealmCascadingDelete.swift
//  DownKit
//
//  Created by Ruud Puts on 20/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

// From https://gist.github.com/krodak/b47ea81b3ae25ca2f10c27476bed450c#gistcomment-2216158
import RealmSwift
import Realm

protocol CascadeDeleting: class {
    func delete<S: Sequence>(_ objects: S, cascading: Bool) where S.Iterator.Element: Object
    func delete<Entity: Object>(_ entity: Entity, cascading: Bool)
}

extension Realm: CascadeDeleting {
    func delete<S: Sequence>(_ objects: S, cascading: Bool) where S.Iterator.Element: Object {
        objects.forEach { delete($0, cascading: cascading) }
    }

    func delete<Entity: Object>(_ entity: Entity, cascading: Bool) {
        if cascading {
            cascadeDelete(entity)
        }
        else {
            delete(entity)
        }
    }
}

private extension Realm {
    func cascadeDelete(_ object: Object) {
        var toBeDeleted = Set<RLMObjectBase>()
        toBeDeleted.insert(object)

        while !toBeDeleted.isEmpty {
            guard
                let element = toBeDeleted.removeFirst() as? Object,
                !element.isInvalidated else {
                continue
            }

            resolve(element, toBeDeleted: &toBeDeleted)
            delete(element)
        }
    }

    func resolve(_ element: Object, toBeDeleted: inout Set<RLMObjectBase>) {
        guard let deletable = element as? CascadeDeletable else { return }

        element.objectSchema.properties
            .filter { deletable.propertiesToCascadeDelete.contains($0.name) }
            .forEach {
                guard let value = element.value(forKey: $0.name) else {
                    return
                }

                if let object = value as? Object {
                    toBeDeleted.insert(object)
                }
                else if let list = value as? RealmSwift.ListBase {
                    for index in 0..<list._rlmArray.count {
                        guard let object = list._rlmArray.object(at: index) as? Object else {
                            continue
                        }

                        toBeDeleted.insert(object)
                    }
                }
            }
    }
}

protocol CascadeDeletable: class {
    var propertiesToCascadeDelete: [String] { get }
}
