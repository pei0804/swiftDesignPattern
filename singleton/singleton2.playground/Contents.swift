//----------------
// シングルトン
//----------------
import Foundation

class DataItem {
    enum ItemType: String {
        case Email = "Email"
        case Phone = "Phone"
        case Card = "Card"
    }

    var type: ItemType
    var data: String

    init(type: ItemType, data: String) {
        self.type = type
        self.data = data
    }
}

class BackupServer {
    let name: String
    private var data = [DataItem]()

    init(name: String) {
        self.name = name
        Logger.sharedInstance.log(msg: "created new server \(name)")
    }

    func backup(item: DataItem) {
        data.append(item)
        Logger.sharedInstance.log(msg: "\(name) backed up item of type \(item.type.rawValue)")
    }

    func getData() -> [DataItem] {
        return data
    }
}

class Logger {
    private var data = [String]()
    private init(){}    // 全てのコンポーネントが、以下のプロパティを使ってメソッドを実行する
    static let sharedInstance = Logger()

    func log(msg: String) {
        data.append(msg)
    }

    func printLog() {
        for msg in data {
            print(msg)
        }
    }
}

var server = BackupServer(name: "Server#1")
server.backup(item: DataItem(type: DataItem.ItemType.Email, data: "Joe@gmail.com"))
server.backup(item: DataItem(type: DataItem.ItemType.Phone, data: "555-222-333"))
Logger.sharedInstance.log(msg: "Backed up 2 \(server.name)")
var otherServer = BackupServer(name: "Server#2")
otherServer.backup(item: DataItem(type: DataItem.ItemType.Email, data: "pei@gmail.com"))
Logger.sharedInstance.log(msg: "Backed up 1 \(otherServer.name)")

// 全てのログがひとつのインスタンスで取得できている
Logger.sharedInstance.printLog()