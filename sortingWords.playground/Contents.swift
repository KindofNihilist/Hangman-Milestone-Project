import UIKit

var wordsArray = [String]()
var sortedWords = [String]()
var contentsOfFile = ""

if let filePath = Bundle.main.url(forResource: "countries", withExtension: "json") {
    contentsOfFile = try String(contentsOf: filePath)
    contentsOfFile = contentsOfFile.replacingOccurrences(of: "\'", with: "\"")
    contentsOfFile = contentsOfFile.replacingOccurrences(of: "name:", with: "\"name\":")
    contentsOfFile = contentsOfFile.replacingOccurrences(of: "code:", with: "\"code\":")
}

for word in wordsArray {
    if word.count > 3 && word.count < 11 {
        sortedWords.append(word)
    }
}

let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

let fileURL = URL(fileURLWithPath: "countries", relativeTo: directoryURL).appendingPathExtension("json")


let data = contentsOfFile.data(using: .utf8)

do {
    try data?.write(to: fileURL)
    print("File saved: \(fileURL.absoluteURL)")
} catch {
 print(error.localizedDescription)
}

