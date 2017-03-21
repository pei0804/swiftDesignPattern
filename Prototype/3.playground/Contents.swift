//: Playground - noun: a place where people can play

//-------------
// 配列のコピー
//-------------
import Foundation

class Person: NSObject, NSCopying {
    var name: String
    var country: String

    init(name: String, country: String) {
        self.name = name
        self.country = country
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return Person(name: self.name, country: self.country)
    }
}

var people = [Person(name: "Joe", country: "France"), Person(name: "pei", country: "Japan")]
var otherpeople = people

people[0].country = "UK"

// 配列はパフォーマンスを最適化するために、変更されるまでコピーされない。(遅延コピー)
// つまり、今回の場合は配列の中身そのものが変更されているわけではないので、参照コピーだけが行われている。
print("Country: \(people[0].country)")
print("Country: \(otherpeople[0].country)")

// ディープコピーする方法
func deepCopy(data: [Any]) -> [Any] {
    return data.map({item -> Any in
        if item is NSCopying && item is NSObject {
            return (item as! NSObject).copy()
        } else {
            return item
        }
   })
}

var people2 = [Person(name: "Joe", country: "France"), Person(name: "pei", country: "Japan")]
var otherpeople2 = deepCopy(data: people2) as! [Person]

people2[0].country = "UK"

// 配列はパフォーマンスを最適化するために、変更されるまでコピーされない。(遅延コピー)
// つまり、今回の場合は配列の中身そのものが変更されているわけではないので、参照コピーだけが行われている。
print("Country: \(people2[0].country)")
print("Country: \(otherpeople2[0].country)")