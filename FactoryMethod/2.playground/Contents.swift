//--------------
// Factory Method
//--------------
// 実装クラスを選択するための意思決定ロジックをカプセル化し、
// このロジックを実行するために必要なパラメータを定義し，その操作の対象となるプロトコルの実装を返す。
// Javaなどではこのファクトリメソッドは抽象クラスにあたる。

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

// グローバルなファクトリメソッドを定義する
// 最も単純な方法で、グローバル関数を定義することで、どこからでもアクセスできるようにする。
// グローバル関数のcreateRentalCarに含まれている意思決定ロジックは、
// CarSelectorクラスとPriceCalculatorクラスで使用しているものと同じ。
// そのため、小さな変更でも呼び出し元にコンポーネントに影響を与える可能生がある。
func createRentalCar(passengers: Int) -> RentalCar? {
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
    return car
}

// コードが大幅に減っただけではなく、CarSelectorクラスの依存関係が
// createRentalCarグローバル関数とRentalCarプロトコルだけになっている。
class CarSelector {
    class func selectCar(passengers: Int) -> String? {
        return createRentalCar(passengers: passengers)?.name
    }
}

class PriceCalculator {
    class func calclulatePrice(passagers: Int, days: Int) -> Float? {
        let car = createRentalCar(passengers: passagers)
        return car == nil ? nil : car!.pricePerDay * Float(days)
    }
}

let passengers = [1, 3, 5]
for p in passengers {
    print("\(p) passengers \(CarSelector.selectCar(passengers: p))")
}