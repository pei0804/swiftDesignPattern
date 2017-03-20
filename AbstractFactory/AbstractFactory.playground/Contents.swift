//----------------
// AbstractFactory
//----------------

// Floorplan
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

// 以下のように必要なものを選択して、ひとつのオブジェクトを作成することが出来ますが、
// このアプローチには問題があります。それは意思決定ロジックがアプリケーション全体に散らばってしまうことです。
// 個々の実装クラスの存在に依存することにもなり、ひとつでも構造体に変更があると、全てに変更が必要になることを意味します。
var car = Car(carType: Cars.SPORTS, floor: ShortFloorplan(), suspension: RaceSuspension(), drive: RearWhellDrive())
car.printDetails()

// AbstractFactoryパターンはFactoryMethodパターンと似た目的があり、
// オブジェクトグループを作成するものです。

// 使い分けについて
// AbstructFactoryは複数のオブジェクトをまとめる時
// FactoryMethodは単一のオブジェクトを作成する時