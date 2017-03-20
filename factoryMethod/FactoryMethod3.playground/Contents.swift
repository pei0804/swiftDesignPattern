//----------------
// FactoryMethod
//----------------
// ベースクラスを使用する
// RentalCarプロトコルを作成して、使うのではなく、クラスがプロトコルの代わりになっている。
// クラス階層が複雑な場合、個々のクラスに意思決定を移譲する方法もあります。（FactoryMethod4）
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
        var car: RentalCar?
        switch passengers {
        case 0...3:
            car = Compact()
        case 4...8:
            car = SUV()
        default:
            car = nil
        }
        return car
    }
}

class Compact: RentalCar {
    fileprivate init() {
        super.init(name: "VM Golf", passengers: 3, price: 20)
    }
}

class SUV: RentalCar {
    fileprivate init() {
        super.init(name: "Cadillac Escalade", passengers: 8, price: 75)
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