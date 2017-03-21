//----------------
// FactoryMethod
//----------------
// ベースクラスを使用する
// 複雑な意思決定があるパターン　Compact内部でsmallCompactにするかどうかの判断。
class RentalCar {
    private var nameBV: String
    private var passengersBV: Int
    private var priceBV: Float

    fileprivate init(name: String, passengers: Int, price: Float) {
        self.nameBV = name
        self.passengersBV = passengers
        self.priceBV = price
    }

    final var name: String {
        get { return nameBV }
    }

    final var passengers: Int {
        get { return passengersBV }
    }

    final var pricePerDay: Float {
        get { return priceBV }
    }

    class func createRentalCar(passengers: Int) -> RentalCar? {
        var carImpl: RentalCar.Type?
        switch passengers {
        case 0...3:
            // 複雑なクラス階層に対して意思決定を移譲する。
            // もし、単純な構造の場合は、このような移譲を避け、決定ロジックを一箇所にした方がスマート
            // しかし、移譲せずに全ての意思決定をここにまとめると、サブクラスへの依存関係が発生するので、
            // 複雑な変更が必要になった場合は、移譲することで、変更が必要なくなる。
            carImpl = Compact.self
        case 4...8:
            carImpl = SUV.self
        default:
            carImpl = nil
        }
        return carImpl?.createRentalCar(passengers: passengers)
    }
}

class Compact: RentalCar {
    // デフォルトのイニシャライザ
    // http://qiita.com/edo_m18/items/733d8c81fb00942e3167
    fileprivate convenience init() {
        self.init(name: "VM Golf", passengers: 3, price: 20)
    }

    // 継承先でsuper.initで呼ばれるイニシャライザ
    fileprivate override init(name: String, passengers: Int, price: Float) {
        super.init(name: name, passengers: passengers, price: price)
    }

    override class func createRentalCar(passengers: Int) -> RentalCar? {
        if passengers < 2 {
            return Compact()
        } else {
            return SmallCompact()
        }
    }
}

class SUV: RentalCar {
    fileprivate init() {
        super.init(name: "Cadillac Escalade", passengers: 8, price: 75)
    }

    override class func createRentalCar(passengers: Int) -> RentalCar? {
        return SUV()
    }
}

class SmallCompact: Compact {
    fileprivate init() {
        super.init(name: "Found Fiesta", passengers: 3, price: 15)
    }
}

class CarSelector {
    class func selectCar(passengers: Int) -> String? {
        return RentalCar.createRentalCar(passengers: passengers)?.name
    }
}

class PriceCalculator {
    class func calclulatePrice(passagers: Int, days: Int) -> Float? {
        let car =  RentalCar.createRentalCar(passengers: passagers)
        return car == nil ? nil : car!.pricePerDay * Float(days)
    }
}

let passengers = [1, 2, 3, 5]
for p in passengers {
    print("\(p) passengers \(CarSelector.selectCar(passengers: p))")
}
