//
//  Header.swift
//  BoikoML
//
//  Created by Luis Eduardo Boiko Ferreira on 13/06/2018.
//  Copyright © 2018 Luis Eduardo Boiko Ferreira. All rights reserved.
//

import Foundation

public class Header<T> : CustomStringConvertible {

    private var features : [Feature<Any>]
    
    public init(features : [Feature<Any>]) {
        self.features = features
    }
    
    public var description: String {
        var featuresList : String = ""
        for i in 0..<self.features.count {
            if featuresList != "" {
                featuresList = featuresList + ", " + self.featureNameAtIndex(index: i)
            } else {
                featuresList = self.featureNameAtIndex(index: i)
            }
        }
        return featuresList
    }
    
    public func featureNameAtIndex(index : Int) -> String {
        var featureName : String = ""
        for feature in self.features {
            if feature.getIndex() == index {
                featureName = feature.getName()
            }
        }
        
        return featureName
    }
    
    public func header() -> [Feature<Any>] {
        return self.features
    }
    
    public func cloneHeader(whichHeader : Feature<Any>) {
        self.features = [whichHeader]
    }
    
    public func removeAtIndex(index : Int) {
        self.features.remove(at: index)
    }
    
}
