//
//  AbstractLearner.swift
//  BoikoML
//
//  Created by Luis Eduardo Boiko Ferreira on 29/08/2018.
//  Copyright © 2018 Luis Eduardo Boiko Ferreira. All rights reserved.
//

import Foundation

public protocol AbstractLearner {
    func fit(x_train : DataFrame<Any>, y_train : DataFrame<Any>)
    func predict(x_test : DataFrame<Any>, y_test : DataFrame<Any>) -> [Any]
}
