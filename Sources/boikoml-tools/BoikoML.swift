import Foundation

enum OptionType: String {
    case csvFile = "f"
    case classIndex = "i"
    case help = "h"
    case quit = "q"
    case unknown
  
    init(value: String) {
        switch value {
        case "f": self = .csvFile
        case "i": self = .classIndex
        case "h": self = .help
        case "q": self = .quit
        default: self = .unknown
        }
    }
}

class BoikoML {

    let consoleIO = ConsoleIO()

    func staticMode() {
        // consoleIO.printUsage()
        //1
        let argCount = CommandLine.argc
        //2
        let argument = CommandLine.arguments[1]
        //3
        let (option, value) = getOption(argument.substring(from: argument.index(argument.startIndex, offsetBy: 1)))
        //4
        // consoleIO.writeMessage("Argument count: \(argCount) Option: \(option) value: \(value)")
    
        //1
        switch option {
        case .csvFile, .classIndex:
        
        if argCount != 5 {
            if argCount > 5 {
            consoleIO.writeMessage("Too many arguments for option \(option.rawValue)", to: .error)
            } else {
            consoleIO.writeMessage("Too few arguments for option \(option.rawValue)", to: .error)
            }
            consoleIO.printUsage()
        } else {
            //3
            
            let csvFile = CommandLine.arguments[2]
            let classIndex = Int(CommandLine.arguments[4])

            print("Csv file name passed is \(csvFile)")
            print("The model is being trained...")
            // print(classIndex)
            let csvData = self.parseUrl(fileUrl: csvFile)
            var df = DataFrame(inputData: csvData.csv.getData(), header: csvData.header, metaAttributeIndex: classIndex!)
            var data = df.trainTestSplit(percent: 0.8)
            var train = data["train"]!, test = data["test"]!
            var treino = train.splitMetaAttribute(dataframe: train), teste = train.splitMetaAttribute(dataframe: test)
            let clf = Knn(k: 7)
            // let clf = Id3()
            clf.fit(x_train: treino["x"]!, y_train: treino["y"]!)
            // print(clf.giniIndex(key: classIndex!))
            let pred = clf.predict(x_test: teste["x"]!, y_test: teste["y"]!)
            let cf = ConfusionMatrix(y_pred: pred, y_real: teste["y"]!.showDf()[teste["y"]!.getMetaIndex()]!)
            cf.matrix()
            print(teste["x"]!.shape())
            

            
            

        }
        
        case .help:
        consoleIO.printUsage()
        
        case .unknown, .quit:
        //7
        consoleIO.writeMessage("Unknown option \(value)")
        consoleIO.printUsage()
        }
    
    }

    func parseUrl(fileUrl : String) -> (csv: ReadCsv<Any>, header: Header<Any>) {
        let url = URL(string: fileUrl)
        let dataset = ReadCsv<Any>(path: url!, separator:",") 
        let dfHeader = Header<Any>(features: dataset.getCsvHeader())
        return (csv: dataset, header: dfHeader)
    }

    func getOption(_ option: String) -> (option:OptionType, value: String) {
        return (OptionType(value: option), option)
    }

}