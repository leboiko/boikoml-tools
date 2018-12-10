//
//  Feature.swift
//  BoikoML
//
//  Created by Luis Eduardo Boiko Ferreira on 13/06/2018.
//  Copyright © 2018 Luis Eduardo Boiko Ferreira. All rights reserved.
//

import Foundation

public enum Dtype {
    case nominalString
    case nominalInt
    case numeric
}

public class Feature<T> {
    
    private var index : Int
    private var featureName : String
    private var dType : Dtype
    private var possibleValues : [T] = []
    
    init(index : Int, featureName : String, dType : Dtype) {
        self.index = index
        self.featureName = featureName
        self.dType = dType
    }
    
    public func getIndex() -> Int {
        return self.index
    }
    
    public func getName() -> String {
        return self.featureName
    }
    
    public func getDType() -> Dtype {
        return self.dType
    }
    
    public func setPossibleValues(values : [T]) {
        self.possibleValues = values
    }
    
    public func setDType(dType: Dtype) {
        self.dType = dType
    }
    
    public func getPossibleValues() -> [T] {
        return self.possibleValues
    }
}
