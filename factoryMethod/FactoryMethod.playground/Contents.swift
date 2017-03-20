//----------------
// FactoryMethod
//----------------
// あるプロトタイプに準拠するクラスがいくつか存在し、
// その中から、インスタンス化するクラスをひとつ選択しなければならない場合に使う。

// 以下のプロトコルに準拠する
protocol RentalCar {
    var name: String { get }
    var passengers: Int { get }
    var pricePerDay: Float { get }
}

class Compact: RentalCar {
    var name = "VM Golf"
    var passengers = 3
    var pricePerDay: Float = 20
}

class Sports: RentalCar {
    var name = "Porsche Boxter"
    var passengers = 1
    var pricePerDay: Float = 100
}

class SUV: RentalCar {
    var name = "Cadillac Esaclade"
    var passengers = 8
    var pricePerDay: Float = 75
}

class Minivan: RentalCar {
    var name = "Chevrolet Express"
    var passengers = 14
    var pricePerDay: Float = 40
}
// 現状の実装のままだと問題があります。
// 実装クラスをインスタンス化する必要がある。
// RentalCarプロトコルによってもたらされる抽象化のメリットをCarSelectorクラスが享受できない。

// また、CarSelectorは選択対象となるRentalCarプロトコルの実装を全て熟知している必要がある。
// 加えて条件がもし変わった場合、CarSelectorの条件の変更はもちろん、
// PriceCalculatorのようなクラスが増えた場合に、複数箇所で保守をする必要が出てくる。
// これらの解決方法を、FactoryMethod2以降に紹介します。

class CarSelector {
    // 動的にインスタンス化するクラスを選択する
    class func selectCar(passengers: Int) -> String? {
        var car: RentalCar?
        switch passengers {
        case 0...1:
            car = Sports()
        case 2...3:
            car = Compact()
        case 4...8:
            car = SUV()
        case 9...14:
            car = Minivan()
        default:
            car = nil
        }
        return car?.name
    }
}

import Foundation

let passengers = [1, 3, 5]
for p in passengers {
    print("\(p) passengers \(CarSelector.selectCar(passengers: p))")
}

class PriceCalculator {
    class func calculatePrice(passengers: Int, day: Int) -> Float? {
        var car: RentalCar?
        switch passengers {
        case 0...1:
            car = Sports()
        case 2...3:
            car = Compact()
        case 4...8:
            car = SUV()
        case 9...14:
            car = Minivan()
        default:
            car = nil
        }
        return car == nil ? nil : car!.pricePerDay * Float(day)
    }
}