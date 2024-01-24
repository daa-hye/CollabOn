//
//  Extension + String.swift
//  CollabOn
//
//  Created by 박다혜 on 1/11/24.
//

import Foundation

extension String {

    var decimalFilteredString: String {
        return String(unicodeScalars.filter(CharacterSet.decimalDigits.contains))
    }

    func formated(by patternString: String) -> String {
        let digit: Character = "#"

        let pattern: [Character] = Array(patternString)
        let input: [Character] = Array(self.decimalFilteredString)
        var formatted: [Character] = []

        var patternIndex = 0
        var inputIndex = 0

        while inputIndex < input.count {
            let inputCharacter = input[inputIndex]

            guard patternIndex < pattern.count else { break }
            
            switch pattern[patternIndex] == digit {

            case true:
                formatted.append(inputCharacter)
                inputIndex += 1

            case false:
                formatted.append(pattern[patternIndex])
            }

            patternIndex += 1
        }
        return String(formatted)
    }

    func dateFormat() -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = inputDateFormatter.date(from: self) else { return self }
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yy. MM. dd"
        return outputDateFormatter.string(from: date)
    }

}
