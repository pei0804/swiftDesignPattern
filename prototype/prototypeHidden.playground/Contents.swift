//: Playground - noun: a place where people can play

class Message {
    var to: String
    var subject: String

    init(to: String, subject: String) {
        self.to = to
        self.subject = subject
    }
}

class MessageLogger {
    var messages: [Message] = []

    func logMessage(msg: Message) {
        messages.append(msg)
    }

    func processMessages(callback: (Message) -> Void) {
        for msg in messages {
            callback(msg)
        }
    }
}

var logger = MessageLogger()
var message = Message(to: "joe", subject: "hello")
logger.logMessage(msg: message)

message.to = "Bob"
message.subject = "Free for dinner"
logger.logMessage(msg: message)

// 意図的にはjoe helloとbob free for dinnerの二種類が出てきてほしい
logger.processMessages(callback: {msg -> Void in
    print("\(msg.to) \(msg.subject)")
})

class MessageLogger2 {
    var messages: [Message] = []

    func logMessage(msg: Message) {
        // Arrayの性質上、参照が適用されるのを防ぐために、initを走らせるようにすることも出来ますが、
        // この解決策はあまり好ましくないです。
        messages.append(Message(to: msg.to, subject: msg.subject))
    }

    func processMessages(callback: (Message) -> Void) {
        for msg in messages {
            callback(msg)
        }
    }
}

var logger2 = MessageLogger2()
var message2 = Message(to: "joe", subject: "hello")
logger2.logMessage(msg: message2)

message2.to = "Bob"
message2.subject = "Free for dinner"
logger2.logMessage(msg: message2)

// 一応結果は返ってくる
logger2.processMessages(callback: {msg -> Void in
    print("\(msg.to) \(msg.subject)")
})

// 例えば、以下のようなクラスが追加された場合、問題が発生する。
class DetailedMessage: Message {
    var from: String

    init(to: String, subject: String, from: String) {
        self.from = from
        super.init(to: to, subject: subject)
    }
}


var logger3 = MessageLogger2()
var message3 = Message(to: "joe", subject: "hello")
logger3.logMessage(msg: message3)

message3.to = "Bob"
message3.subject = "Free for dinner"
logger3.logMessage(msg: DetailedMessage(to: "Alice", subject: "Hi", from: "joe"))

// どちらのclassを判定した上で、出力が必要になる。
// 例えば、同じようなクラスがひとつまた増えると分岐も増えます。
// そこで、そもそものMessageクラスのイニシャライザを変えることも出来ますが、
// イニシャライザが複雑になるため、好ましくありません。
// このソースの解決策はprototypeHidden2にて
logger3.processMessages(callback: {msg -> Void in
    if let detailed = msg as? DetailedMessage {
        print("\(detailed.to) \(detailed.from) \(detailed.from)")
    } else {
        print("\(msg.to) \(msg.subject)")
    }
})
