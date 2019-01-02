import Foundation

extension String {
    func match(_ regex: String) -> (range: NSRange, groups: [String]) {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
            guard let match = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)).first else {
                return (NSRange(), [])
            }

            var groups = [String]()
            for i in 0..<match.numberOfRanges {
                let group = String(NSString(string: self).substring(with: match.range(at: i)))
                groups.append(group)
            }

            return (match.range, groups)
        }
        catch {
            return (NSRange(), [])
        }
    }
}

let regex1 = "S(\\d+).?E(\\d+)"
let regex2 = "(\\d+)x(\\d+)"

"Lethal.Weapon.S03E10.720p.HDTV.x264-CRAVERS".match(regex1)
"Lethal.Weapon.S03E10.720p.HDTV.x264-CRAVERS".match(regex2)

"luther.5x01.720p hdtv x264-fov".match(regex1)
"luther.5x01.720p hdtv x264-fov".match(regex2)
