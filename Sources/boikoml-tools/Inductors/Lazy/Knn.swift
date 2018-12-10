//
//  Knn.swift
//  BoikoML
//
//  Created by Luis Eduardo Boiko Ferreira on 29/08/2018.
//  Copyright © 2018 Luis Eduardo Boiko Ferreira. All rights reserved.
//

import Foundation

public class Knn: AbstractLearner {

    
    
    private var k : Int
    private var x_train : DataFrame<Any>?
    private var y_train : DataFrame<Any>?
//    private var x_test : DataFrame<Any>?
//    private var y_test : DataFrame<Any>?
    
    
    public init(k: Int) {
        self.k = k
    }
    
    public func fit(x_train : DataFrame<Any>, y_train : DataFrame<Any>) {
        self.x_train = x_train
        self.y_train = y_train
    }
    
    public func predict(x_test : DataFrame<Any>, y_test : DataFrame<Any>) -> [Any] {
        var predictedClasses : [Any] = []
        var predictions : [(Double, Any)] = []
        
        for i in 0 ..< x_test.shape()[1] {
            
            predictions.removeAll()
            
            for j in 0 ..< self.x_train!.shape()[1] {
                predictions.append((self.getDistance(array1: x_test.rowAtIndex(index: i), array2: (self.x_train?.rowAtIndex(index: j))!), self.y_train!.rowAtIndex(index: j)[0] as Any))
            }
            // order the list of tuples by distance
            let tupleArrayInc = predictions.sorted(by: { $0.0 < $1.0 })
            // get k first elements
            let firstK = tupleArrayInc[0..<self.k]
            predictedClasses.append(self.setClasse(tuples: Array(firstK)) as! Double)
            
        }
        
//        print(predictedClasses)
        return predictedClasses
    }
    
    private func setClasse(tuples : [(Double, Any)]) -> Any {
        var possibleValues : [Any] = []
        
        for tuple in tuples{
            possibleValues.append(tuple.1)
        }
        
        let classCount = NSCountedSet(array: Array(possibleValues)).dictionary.sorted(by: { $0.1 > $1.1 })
//        print(classCount[0].key)
        return classCount[0].key

    }
    
    private func getDistance(array1 : [Any], array2 : [Any]) -> Double {
        var sum : Double = 0.0
        for i in 0 ..< array1.count {
            sum += pow((array1[i] as! Double - (array2[i] as! Double)), 2)
        }
//        var tot = pow((array1[i] - array2[i]), 2)
        
        return sum.squareRoot()
    }
    
}
