//
//  Distances.swift
//  BoikoML
//
//  Created by Luis Eduardo Boiko Ferreira on 30/08/2018.
//  Copyright © 2018 Luis Eduardo Boiko Ferreira. All rights reserved.
//

import Foundation

public class Distances {
    public var distance : Double
    public var predictedClass : Any
    
    public init(distance : Double, predictedClass : Any) {
        self.distance = distance
        self.predictedClass = predictedClass
    }
}
