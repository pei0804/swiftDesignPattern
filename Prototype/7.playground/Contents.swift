//: Playground - noun: a place where people can play

//---------------
// prototypeの適用
//---------------
import Foundation

class Message: NSObject, NSCopying {
    var to: String
    var subject: String

    init(to: String, subject: String) {
        self.to = to
        self.subject = subject
    }

    // Messages用のcopyメソッド
    func copy(with zone: NSZone? = nil) -> Any {
        return Message(to: self.to, subject: self.subject)
    }
}

class DetailedMessage: Message {
    var from: String

    init(to: String, subject: String, from: String) {
        self.from = from
        super.init(to: to, subject: subject)
    }

    // DetailedMessage用のcopyメソッド
    override func copy(with zone: NSZone?) -> Any {
        return DetailedMessage(to: self.to, subject: self.subject, from: self.from)
    }
}

class MessageLogger {
    var messages: [Message] = []

    func logMessage(msg: Message) {
        // Messageを継承しているクラスのオブジェクトなら、なんでも対応できる
        messages.append(msg.copy() as! Message)
    }

    func processMessages(callback: (Message) -> Void) {
        for msg in messages {
            callback(msg)
        }
    }
}

// 上記のような実装をすることでコードがすっきりし、様々なパターンに対応が出来るソースになる。
var logger = MessageLogger()
var message = Message(to: "joe", subject: "hello")
logger.logMessage(msg: message)

message.to = "Bob"
message.subject = "Free for dinner"
logger.logMessage(msg: DetailedMessage(to: "Alice", subject: "Hi", from: "joe"))

logger.processMessages(callback: {msg -> Void in
    print("\(msg.to) \(msg.subject)")
})
