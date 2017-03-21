//---------------------
// AbstractFactory
//---------------------
// シングルトンパターンを適用する
// 実装クラスからオブジェクトを作成するために必要なロジックだけなので、
// シングルトンと相性が良いです。

// 抽象ファクトリ
class CarFactory {
    required init() {
    }

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
        var factoryType: CarFactory.Type
        switch car {
        case .COMPACT:
            factoryType = CompactCarFactory.self
        case .SPORTS:
            factoryType  = SportsCarFactory.self
        case .SUV:
            factoryType  = SUVCarFactory.self
        }
        var factory = factoryType.sharedInstance
        if factory == nil {
            factory = factoryType.init()
        }
        return factory
    }

    class var sharedInstance: CarFactory? {
        get { return nil }
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

    override class var sharedInstance: CarFactory? {
        get {
            struct SingletonWrapper {
                static let singleton = SportsCarFactory()
            }
            return SingletonWrapper.singleton
        }
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

    // 抽象ファクトリクラスを隠蔽する
    init(carType: Cars) {
        let concreateFactory = CarFactory.getFactory(car: carType)
        self.floor = concreateFactory!.createFloorplan()
        self.suspension = concreateFactory!.createSuspension()
        self.drive = concreateFactory!.createDrivetrain()
        self.carType = carType
    }

    func printDetails() {
        print("Car Type: \(carType.rawValue)")
        print("Seats: \(floor.seats)")
        print("Engine: \(floor.enginePosition)")
        print("Suspension: \(suspension.suspensionType.rawValue)")
        print("Drive: \(drive.driveType.rawValue)")
    }
}

// 隠蔽することで、コードが劇的に短くなる。
// このアプローチには、いくつか前提条件があります。

// コンポーネントがCarオブジェクトを作成しようとしている。
// パーツオブジェクトが三つとも要求される。(4つの場合もあるなどがあると破綻する)
let car = Car(carType: .SUV)
car.printDetails()
