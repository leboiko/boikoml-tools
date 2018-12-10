//
//  UtilsExtensions.swift
//  BoikoML
//
//  Created by Luis Eduardo Boiko Ferreira on 20/06/2018.
//  Copyright © 2018 Luis Eduardo Boiko Ferreira. All rights reserved.
//

import Foundation

extension NSCountedSet {
    var occurences: [(object: Any, count: Int)] {
        return allObjects.map { ($0, count(for: $0))}
    }
    var dictionary: [AnyHashable: Int] {
        return allObjects.reduce(into: [AnyHashable: Int](), {
            guard let key = $1 as? AnyHashable else { return }
            $0[key] = count(for: key)
        })
    }
}
