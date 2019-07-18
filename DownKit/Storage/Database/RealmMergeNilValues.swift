//
//  RealmMergeNilValues.swift
//  DownKit
//
//  Created by Ruud Puts on 30/12/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import RealmSwift
import Realm

protocol NilValueMerging: class {
    func add<S: Sequence>(_ objects: S, update: Realm.UpdatePolicy, mergeNilValues: Bool) where S.Iterator.Element: Object
    func add<Entity: Object>(_ entity: Entity, update: Realm.UpdatePolicy, mergeNilValues: Bool)
}

extension Realm: NilValueMerging {
    func add<S: Sequence>(_ objects: S, update: Realm.UpdatePolicy, mergeNilValues: Bool) where S.Iterator.Element: Object {
        objects.forEach { add($0, update: update, mergeNilValues: mergeNilValues) }
    }

    func add<Entity: Object>(_ entity: Entity, update: Realm.UpdatePolicy, mergeNilValues: Bool) {
        if mergeNilValues {
            self.mergeNilValues(entity)
        }

        add(entity, update: update)
    }
}

private extension Realm {
    func mergeNilValues(_ input: Any) {
        if let objectList = input as? RealmSwift.ListBase {
            for index in 0..<objectList._rlmArray.count {
                guard let object = objectList._rlmArray.object(at: index) as? Object else {
                    continue
                }

                mergeNilValues(object)
            }
            return
        }

        guard
            let object = input as? Object,
            let primaryKey = object.objectSchema.primaryKeyProperty?.name else {
            return
        }

        let matchingObjects = objects(type(of: object.self))
            .filter("\(primaryKey) == %@", object.value(forKey: primaryKey)!)
        guard let storedObject = matchingObjects.first else {
            return
        }

        // Recursive do all child properties which contain an object
        object.objectSchema.properties
            .filter { !$0.isOptional }
            .filter { $0.objectClassName != nil }
            .compactMap { object.value(forKey: $0.name) }
            .forEach { self.mergeNilValues($0) }

        guard let mergable = object as? NilValueMergable else {
            return
        }

        object.objectSchema.properties
            .filter { $0.objectClassName == nil }
            .filter { mergable.propertiesToMergeNilValues.contains($0.name) }
            .filter { $0.isOptional }
            .forEach {
                let currentValue = object.value(forKey: $0.name)
                guard let storedValue = storedObject.value(forKey: $0.name), currentValue == nil else {
                    return
                }

                object.setValue(storedValue, forKey: $0.name)
            }
    }
}

protocol NilValueMergable: class {
    var propertiesToMergeNilValues: [String] { get }
}
