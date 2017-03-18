//: Playground - noun: a place where people can play

//---------------
// prototype
//---------------
// Swiftでは新しい変数に値型を割り当てる時に、ptototypeパターンが適用される。
// 値型は構造体を使って定義されるが、Swiftの組み込み型は全ての構造体として実装されている。
// String Int Booleanなどはそれにあたる。

// 値型
struct Appointment {
    var name: String
    var day: String
    var place: String

    func printDetails(label: String) {
        print("\(label) with \(self.name) on \(self.day) at \(self.place)")
    }
}

// オブジェクトをクローンする
var beerMeeting = Appointment(name: "Bob", day: "Mon", place: "oosaka")

var wookMeeting = beerMeeting
wookMeeting.name = "pei"
wookMeeting.day = "Fri"
wookMeeting.place = "nagoya"

// それぞれののオブジェクトは別のものとして扱われる
beerMeeting.printDetails(label: "Twitter")
wookMeeting.printDetails(label: "Facebook")

// 参照型
class Appointment2 {
    var name: String
    var day: String
    var place: String

    init(name: String, day: String, place: String) {
        self.name = name
        self.day = day
        self.place = place
    }
    
    func printDetails(label: String) {
        print("\(label) with \(self.name) on \(self.day) at \(self.place)")
    }
}

var beerMeeting2 = Appointment2(name: "Bob", day: "Mon", place: "oosaka")

// オブジェクトへアドレスを渡す
var wookMeeting2 = beerMeeting2
wookMeeting2.name = "pei"
wookMeeting2.day = "Fri"
wookMeeting2.place = "nagoya"

// 見に行っているアドレスが同じなので、結果も同じになる
beerMeeting2.printDetails(label: "Twitter")
wookMeeting2.printDetails(label: "Facebook")


// prototypeパターンにおいては、この参照型は役に立たないので、
// クローニングをサポートするためにNSCopyingプロトコルを定義する。
import Foundation

class Appointment3: NSObject, NSCopying {
    var name: String
    var day: String
    var place: String
    
    init(name: String, day: String, place: String) {
        self.name = name
        self.day = day
        self.place = place
    }
    
    func printDetails(label: String) {
        print("\(label) with \(self.name) on \(self.day) at \(self.place)")
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return Appointment3(name: self.name, day: self.name, place: self.place)
    }
}


var beerMeeting3 = Appointment3(name: "Bob", day: "Mon", place: "oosaka")

// copyメソッドを使ってクローニングをする 
var wookMeeting3 = beerMeeting3.copy() as! Appointment3
wookMeeting3.name = "pei"
wookMeeting3.day = "Fri"
wookMeeting3.place = "nagoya"

// それぞれ保持している値が違う
// 参照型から値型になっているわけではなく、プロトタイプへの新しい参照が作成されている
beerMeeting3.printDetails(label: "Twitter")
wookMeeting3.printDetails(label: "Facebook")
