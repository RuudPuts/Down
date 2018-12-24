import Foundation

extension String {
    func match(pattern: String) -> Range<String.Index>? {
        return self.range(of: pattern, options: [.regularExpression, .caseInsensitive])
    }
}

let regex1 = "^(a|the)\\s?"
let regex2 = "^(a\\s|the\\s)?"

"The 100".match(pattern: regex1)
"The 100".match(pattern: regex2)

"Theft show".match(pattern: regex1)
"Theft show".match(pattern: regex2)

"A show title".match(pattern: regex1)
"A show title".match(pattern: regex2)

"American dad".match(pattern: regex1)
"American dad".match(pattern: regex2)
