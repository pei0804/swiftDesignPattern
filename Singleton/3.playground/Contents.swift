//-----------------
// シングルトンパターンでの同時アクセス
//-----------------

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

final class BackupServer {
    let name: String
    private var data = [DataItem]()

    static let sharedInstance: BackupServer = {
        let instance = BackupServer(name: "Main Server")
        return instance
    }()


    private init(name: String) {
        self.name = name
        Logger.sharedInstance.log(msg: "created new server \(name)")
    }

    func backup(item: DataItem) {
        data.append(item)
        // 並列処理をする場合、処理がかぶる可能生がある処理はシリアルで実行なども視野に入れる
        Logger.sharedInstance.log(msg: "\(name) backed up item of type \(item.type.rawValue) \(item.data)")
    }

    func getData() -> [DataItem] {
        return data
    }
}

class Logger {
    private var data = [String]()
    private init(){}
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

// GCD 
// http://dev.classmethod.jp/smartphone/iphone/swift-3-how-to-use-gcd-api-1/
// http://qiita.com/marty-suzuki/items/f0547e40dc09e790328f
var server = BackupServer.sharedInstance
let group = DispatchGroup()

for i in 0..<100 {
    DispatchQueue.global().async(group: group) {
        server.backup(item: DataItem(type: DataItem.ItemType.Email, data: String(i)))
    }
}

_ = group.wait()
print("owari")
Logger.sharedInstance.printLog()