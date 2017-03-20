//-----------------
// AbstractFactory
//-----------------

// 実装クラスを直接インスタンス化するのではなく、抽象ファクトリクラスを使って指定された車種ファクトリを取得する。
let factory = CarFactory.getFactory(car: .SPORTS)
if factory != nil {
    let car = Car(carType: Cars.SPORTS, floor: factory!.createFloorplan(), suspension: factory!.createSuspension(), drive: factory!.createDrivetrain())
    car.printDetails()
}

// 抽象ファクトリ
class CarFactory {
    func createFloorplan() -> Floorplan {
        fatalError("Not implemented")
    }

    func createSuspension() -> Suspension {
        fatalError("Not implemented")
    }

    func createDrivetrain() -> Drivetrain {
        fatalError("Not implemented")
    }

    final class func getFactory(car: Cars) -> CarFactory? {
        var factory: CarFactory?
        switch car {
        case .COMPACT:
            factory = CompactCarFactory()
        case .SPORTS:
            factory = SportsCarFactory()
        case .SUV:
            factory = SUVCarFactory()
        }
        return factory
    }
}

// 具象ファクトリ
class CompactCarFactory: CarFactory {
    override func createFloorplan() -> Floorplan {
        return StandaredFloorplan()
    }

    override func createSuspension() -> Suspension {
        return RoadSuspension()
    }

    override func createDrivetrain() -> Drivetrain {
        return FrontWhellDrive()
    }
}

class SportsCarFactory: CarFactory {
    override func createFloorplan() -> Floorplan {
        return ShortFloorplan()
    }
    
    override func createSuspension() -> Suspension {
        return RaceSuspension()
    }

    // もし、ここを変えたとしても、呼び出しているコンポーネントのコードには影響がない
    override func createDrivetrain() -> Drivetrain {
        return RearWhellDrive()
    }
}

class SUVCarFactory: CarFactory {
    override func createFloorplan() -> Floorplan {
        return LongFloorplan()
    }
    
    override func createSuspension() -> Suspension {
        return OffRoadSuspension()
    }
    
    override func createDrivetrain() -> Drivetrain {
        return AllWhellDrive()
    }
}

protocol Floorplan {
    var seats: Int { get }
    var enginePosition: EngineOption { get }
}

enum EngineOption: String {
    case FRONT = "Front"
    case MID = "Mid"
}

class ShortFloorplan: Floorplan {
    var seats: Int = 2
    var enginePosition: EngineOption = EngineOption.MID
}

class StandaredFloorplan: Floorplan {
    var seats: Int = 2
    var enginePosition: EngineOption = EngineOption.FRONT
}

class LongFloorplan: Floorplan {
    var seats: Int = 8
    var enginePosition: EngineOption = EngineOption.FRONT
}

// Suspension
protocol Suspension {
    var suspensionType: SuspensionOption { get }
}

enum SuspensionOption: String {
    case STANDARD = "Standard"
    case SPORTS = "Firm"
    case SOFT = "Soft"
}

class RoadSuspension: Suspension {
    var suspensionType: SuspensionOption = SuspensionOption.STANDARD
}

class OffRoadSuspension: Suspension {
    var suspensionType: SuspensionOption = SuspensionOption.SOFT
}

class RaceSuspension: Suspension {
    var suspensionType: SuspensionOption = SuspensionOption.SPORTS
}

// Drivetrain
protocol Drivetrain {
    var driveType: DriveOption { get }
}

enum DriveOption: String {
    case FRONT = "Front"
    case PEAR = "Rear"
    case ALL = "4WD"
}

class FrontWhellDrive: Drivetrain {
    var driveType: DriveOption = DriveOption.FRONT
}

class RearWhellDrive: Drivetrain {
    var driveType: DriveOption = DriveOption.PEAR
}

class AllWhellDrive: Drivetrain {
    var driveType: DriveOption = DriveOption.ALL
}

enum Cars: String {
    case COMPACT = "VM Golf"
    case SPORTS = "Porsche Boxter"
    case SUV = "Cadillac Escalade"
}

struct Car {
    var carType: Cars
    var floor: Floorplan
    var suspension: Suspension
    var drive: Drivetrain

    func printDetails() {
        print("Car Type: \(carType.rawValue)")
        print("Seats: \(floor.seats)")
        print("Engine: \(floor.enginePosition)")
        print("Suspension: \(suspension.suspensionType.rawValue)")
        print("Drive: \(drive.driveType.rawValue)")
    }
}

// 実装クラスを直接インスタンス化するのではなく、抽象ファクトリクラスを使って指定された車種ファクトリを取得する。
let factory = CarFactory.getFactory(car: .SPORTS)
if factory != nil {
    let car = Car(carType: Cars.SPORTS, floor: factory!.createFloorplan(), suspension: factory!.createSuspension(), drive: factory!.createDrivetrain())
    car.printDetails()
}