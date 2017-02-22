//
//  main.swift
//  CSVParser
//
//  Created by Matt Beaney on 19/12/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation

func cleanRows(file:String) -> String {
    var cleanFile = file
    cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
    cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
    cleanFile = cleanFile.replacingOccurrences(of: ", ", with: "|")
    cleanFile = cleanFile.replacingOccurrences(of: "\"", with: "'")

    return cleanFile
}

func convertCSV(file:String) -> [String] {
    let cleanedRows = cleanRows(file: file).components(separatedBy: "\n")
    return cleanedRows
}

func getStringFieldsForRow(row:String, delimiter:String) -> [String]{
    return row.components(separatedBy: delimiter)
}

func doStuff() {
    do {
        guard let filepath = Bundle.main.path(forResource: "diaria", ofType: "txt")
            else {
                return
        }
        
        var json: NSMutableDictionary = [:]
        
        let content = try String(contentsOfFile: filepath)
        let csv = convertCSV(file: content as String)
        
        for row in csv {
            let fields = getStringFieldsForRow(row: row, delimiter: ",")
            if fields.count >= 2 {
                json.setObject(fields[1].replacingOccurrences(of: "|", with: ","), forKey: fields[0].replacingOccurrences(of: "|", with: ", ") as NSCopying)
            }
        }
        
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        let jsonString: String = String(data: data, encoding: String.Encoding.utf8)!
        
        print(json)
    } catch {
        
    }
}

doStuff()
