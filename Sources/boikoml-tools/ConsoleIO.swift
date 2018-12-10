import Foundation

enum OutputType {
  case error
  case standard
}

class ConsoleIO {
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
        // 1
        print("\u{001B}[;m\(message)")
        case .error:
        // 2
        fputs("\u{001B}[0;31m\(message)\n", stderr)
        }
    }

    func printUsage() {

        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
                
        writeMessage("usage:")
        writeMessage("\(executableName) -f csvFile")
        writeMessage("or")
        writeMessage("\(executableName) -h to show usage information")
        // writeMessage("Type \(executableName) without an option to enter interactive mode.")
    }
}