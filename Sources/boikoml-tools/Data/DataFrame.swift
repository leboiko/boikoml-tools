//
//  DataFrame.swift
//  BoikoML
//
//  Created by Luis Eduardo Boiko Ferreira on 12/06/2018.
//  Copyright © 2018 Luis Eduardo Boiko Ferreira. All rights reserved.
//

import Foundation

public class DataFrame<T> {
    private var inputData : [[T]]
    private var data: [Int: [Any]] = [:]
    private var header : Header<Any>
    private var metaAttributeIndex : Int
    
    public init(inputData: [[T]], header: Header<Any>, metaAttributeIndex : Int) {
        self.inputData = inputData
        self.header = header
        self.metaAttributeIndex = metaAttributeIndex
        self.populateDataFrame()
    }
    
    // MARK: Internal functions
    
    private func populateDictKeys() {
        for i in 0..<self.inputData[0].count {
            self.data[i] = []
        }
    }
    
    public func setHeader(newHeader : Header<Any>) {
        self.header = newHeader
    }
    
    private func populateDataFrame() {
        self.populateDictKeys()
        for instance in self.inputData {
            for i in 0..<instance.count {
                if instance[i] is Int {
                    self.data[i]!.append(Double(instance[i] as! Int))
                } else if instance[i] is Double{
                    self.data[i]!.append(instance[i] as! Double)
                } else {
                    self.data[i]!.append(instance[i] as! String)
                }
            }
        }
        self.updateDataTypes()
        
    }
    
    public func removeAllLessIndex(indexToKeep : Int) -> DataFrame {
        for eachKey in self.data.keys {
            if eachKey != indexToKeep {
                self.data[eachKey] = nil
            }
        }
        
        for feature in self.header.header() {
            if feature.getIndex() == indexToKeep {
                self.header.cloneHeader(whichHeader:feature)
            }
        }
        
        return self
    }
    
    public func removeAttributeByIndex(indexToRemove: Int) {
        // First of all, remove the attribute from the header ([Features])
        for i in 0 ..< self.header.header().count {
            if self.header.header()[i].getIndex() == indexToRemove {
                self.header.removeAtIndex(index : i)
            }
        }
        
        self.data[self.metaAttributeIndex] = nil
        // Also update de meta index
//        if indexToRemove <= self.metaAttributeIndex && self.metaAttributeIndex > 0{
//            self.metaAttributeIndex = self.metaAttributeIndex - 1
//        }
        
    }
    
    public func splitMetaAttribute(dataframe : DataFrame) -> [String : DataFrame] {
        // copy header
        let header = self.getHeader()
        let clone = self.cloneDf()
        clone.setData(data: dataframe.data) //set the data correctly
        clone.removeAttributeByIndex(indexToRemove: self.metaAttributeIndex)
        
        let clone2 = self.cloneDf()
        clone2.setHeader(newHeader: Header(features: header))
        clone2.setData(data: dataframe.data)
        
        return ["x" : clone,
                "y" : clone2.removeAllLessIndex(indexToKeep: self.metaAttributeIndex)]
    }
    
    // MARK: Meta attribute related
    
    public func getMetaName(index: Int) -> String {
        return self.header.featureNameAtIndex(index: index)
    }
    
    public func getMetaIndex() -> Int {
        return self.metaAttributeIndex
    }
    
    // MARK: Utils
    
    public func transformStringToInt(arrayOfIndexes : [Int] = []) {
        var dictFeatures : [String : [String : Int]] = [:]
        var dictValues : [String : Int] = [:]
        var counter : Int = 0
        for i in 0..<self.getHeader().count {
            if self.getHeader()[i].getDType() == .nominalString {
                // let data = self.getPossibleValues(key: i)
                
                // for name in data.attributeKeys{
                //     dictValues[name] = counter
                //     counter += 1
                // }
                
               for data in self.getPossibleValues(key: i).enumerated(){
                   dictValues[data.element.key as! String] = counter
                   counter += 1
               }
//                   self.updateValues(index: i, dictValues: dictValues)
                dictFeatures[self.getHeader()[i].getName()] = dictValues
            }
            counter = 0
            dictValues = [:]
        }
        print(dictFeatures)
    }
    
    public func getPossibleValues(key : Int) -> [AnyHashable : Int] {
        var dictOfOccurences = [AnyHashable : Int]()
        var listOfOccurences = [AnyHashable]()
        for val in self.data[key]! {
            if listOfOccurences.contains(val as! AnyHashable) {
                dictOfOccurences[val as! AnyHashable] = dictOfOccurences[val as! AnyHashable]! + 1
            } else {
                listOfOccurences.append(val as! AnyHashable)
                dictOfOccurences[val as! AnyHashable] = 1
            }
        }
        return dictOfOccurences
    }
    
    public func getHeader() -> [Feature<Any>] {
        return self.header.header()
    }
    
    public func shape() -> [Int] {
//        print(self.data.count)
//        print(self.data[0]!.count)
        return [self.data.count, self.data[Array(self.data.keys)[0]]!.count]
    }
    
    
    
    private func getTrainingInstanceLimit(percent: Double) -> Int {
        return Int(Double(self.shape()[1]) * percent)
    }
    
    // This function receive the percent [0, 1] of the trainSet and return
    
    public func trainTestSplit(percent : Double) -> [String : DataFrame] {
        
        let limit = self.getTrainingInstanceLimit(percent: percent)
    
        var trainSlice: [Int: [Any]] = [:]
        var testSlice: [Int: [Any]] = [:]
        
        for i in 0..<self.data.count {
            trainSlice[i] = Array(self.data[i]![0 ..< limit])
            testSlice[i] = Array(self.data[i]![limit ..< self.shape()[1]])
//            print(self.data[i]![0 ..< limit])
        }
        let train = self.cloneDf()
        let test = self.cloneDf()
        
        
        train.setData(data: trainSlice)
        test.setData(data: testSlice)
        
        return ["train" : train,
                "test" : test]
    }
    
    private func cloneDf() -> DataFrame {
        return DataFrame(inputData: self.inputData, header: self.header, metaAttributeIndex: self.metaAttributeIndex)
    }
    
    public func setData(data: [Int : [Any]]) {
        self.data = data
    }
    
    private func updateDataTypes() {
        // Define a minimum number of possible values to determine if they may be categorical
        let minOccurence = 2
        let maxOccurence = 15
        for feature in self.getHeader(){
            let values = self.getPossibleValues(key: feature.getIndex())
            if values.count >= minOccurence && values.count <= maxOccurence {
                var listValues = [Any]()
                for item in values {
                    if item.key is String {
                        listValues.append(item.key as! String)
                        self.getHeader()[feature.getIndex()].setDType(dType: .nominalString)
                    } else {
                        listValues.append(item.key as! Int)
                        self.getHeader()[feature.getIndex()].setDType(dType: .nominalInt)
                    }
                    
                }
                 self.getHeader()[feature.getIndex()].setPossibleValues(values: listValues)
            }
        }
    }
    
    public func rowAtIndex(index : Int) -> [Any] {
        var instance : [Any] = []
        for key in self.data.keys.sorted() {
            instance.append(data[key]![index])
        }
        return instance
    }
    
    public func showDf() -> [Int: [Any]] {
        return self.data
    }
    
    public func getValues(index : Int, normalize : Bool = false) -> [String : [Double]] {
        var max = 0.0
        var doubleData : [Double] = []
        
        for i in 0..<self.shape()[1] {
            let currentRow = self.rowAtIndex(index: i)[index] as! Double
            doubleData.append(currentRow)
            if max < currentRow {
                max = currentRow
            }
        }
        
        if normalize {
            for i in 0..<doubleData.count {
                self.data[index]![i] = doubleData[i] / max 
                doubleData[i] = doubleData[i] / max
            }
        }
        
        return ["max" : [max],
                "values" : doubleData]
    }
    
    public func updateValues(index : Int, dictValues: [String : Int]) {
        
        for i in 0..<self.shape()[1] {
            self.data[index]![i] = dictValues[self.rowAtIndex(index: i)[index] as! String]!
            print("Converting \(self.data[index]![i]) para \(dictValues[self.rowAtIndex(index: i)[index] as! String]!)")
//            if self.header.header()[index].getIndex() ==

        }
    }
}


