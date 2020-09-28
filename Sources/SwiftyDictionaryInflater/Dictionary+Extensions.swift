import Foundation

extension Dictionary where Key == String, Value == String {
    public func inflate() -> [String:Any] {

        var root: [String: Any] = [:]
        var levels: [ String: [[String: Any]]] = [:]

        let sortedKeys = self.keys.sorted(by: {$0.components(separatedBy: "/").count > $1.components(separatedBy: "/").count})

        if sortedKeys.count == 0 {
            return [:]
        }

        let levelIdentifiers = Array(sortedKeys.first!.components(separatedBy: "/").dropLast())

        // setup array of dictionaries for levels
        levels = setupLevels(levelIdentifiers: levelIdentifiers)

        // actual key processing
        for (key) in sortedKeys {

            let keyComponents = Array(key.components(separatedBy: "/"))
            for (index, keyPart) in keyComponents.enumerated() {
                if index == 0 && index == keyComponents.count-1 {
                    root[keyPart] = self[key]
                } else if index == keyComponents.count-1 {
                    var dic = levels[keyComponents[index-1]]![0]
                    dic[keyPart] = self[key]
                    levels[keyComponents[index-1]]![0] = dic
                }
            }
        }

        self.decompose(levels: &levels, into: &root, levelIdentifiers: levelIdentifiers)

        return root
    }

    private func setupLevels(levelIdentifiers: [String]) -> [ String: [[String: Any]]] {
        var levels: [ String: [[String: Any]]] = [:]
        for keyPart in levelIdentifiers {
            levels[keyPart] = [[:]]
        }
        return levels
    }

    private func decompose(levels: inout [ String: [[String: Any]]], into root: inout [String: Any], levelIdentifiers: [String]) {
        var reverseLevelIds: [String] = []
        levelIdentifiers.forEach { (key) in
            reverseLevelIds.insert(key, at: 0)
        }

        for (index, keyPart) in reverseLevelIds.enumerated() {
            if  (index == levelIdentifiers.count-1) {
                let attr = levels[keyPart]
                root[keyPart] = attr
            } else {
                let attr = levels[keyPart]
                var dic = levels[reverseLevelIds[index+1]]![0]
                dic[keyPart] = attr
                levels[reverseLevelIds[index+1]]![0] = dic
            }
        }
    }
}

extension Dictionary where Key == String, Value == Any {
    public func level(_ key: String) -> [[String:Any]]? {
        return self[key] as? [[String:Any]]
    }
}

