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
    let logger = Logger()

    init(name: String) {
        self.name = name
        logger.log(msg: "created new server")
    }

    func backup(item: DataItem) {
        data.append(item)
        logger.log(msg: "\(self.name) backed up item of type \(item.type.rawValue)")
    }

    func getData() -> [DataItem] {
        return data
    }
}

class Logger {
    private var data = [String]()

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

var otherServer = BackupServer(name: "Server#2")
otherServer.backup(item: DataItem(type: DataItem.ItemType.Email, data: "pei@gmail.com"))

// ログは取れるが別々のインスタンスでしか検知していない
// そこでシングルトンパターンを使って解決をする
server.logger.printLog()
otherServer.logger.printLog()