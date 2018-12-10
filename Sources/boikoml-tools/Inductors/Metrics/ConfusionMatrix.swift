//
//  ConfusionMatrix.swift
//  BoikoML
//
//  Created by Luis Eduardo Boiko Ferreira on 30/08/2018.
//  Copyright © 2018 Luis Eduardo Boiko Ferreira. All rights reserved.
//

import Foundation

public class ConfusionMatrix {
    
    
    
    private var tp : Int = 0
    private var tn : Int = 0
    private var fp : Int = 0
    private var fn : Int = 0
    
    //    # Todo generic version
    private var classPos : Double = 0.0
    private var classNeg : Double = 1.0
    
    private var y_pred : [Any]
    private var y_real : [Any]
    
    public init(y_pred : [Any], y_real : [Any]) {
        self.y_pred = y_pred
        self.y_real = y_real
    }
    
    public func matrix() {
//        print("mai")
        for i in 0 ..< self.y_pred.count {
//            print(self.y_real.count)
//            print(self.y_real, "ok")
            if self.y_pred[i] as! Double == self.classPos {
                if self.y_real[i] as! Double == self.classPos {
                    self.tp += 1
                } else {
                    self.fp += 1
                }
            } else if self.y_pred[i] as! Double == self.classNeg {
                if self.y_real[i] as! Double == self.classNeg {
                    self.tn += 1
                } else {
                    self.fn += 1
                }
            }
        }
        
        print("Confusion Matrix:")
        print("[[",self.tp, self.fp, "],")
        print("[", self.fn, self.tn, "]]")
        print("----------")
        print("Accuracy:", (Double(self.tp + self.tn) / Double(self.tp + self.tn + self.fp + self.fn)))
        print("Recall: [", Double(self.tp) / Double(self.tp + self.fn), ", ",Double(self.tn) / Double(self.tn + self.fp), "]")
        
    }
    
}
