//--------------
// Bridge
//--------------

// 実際にメッセージタイプとチャネルを追加してみる。

protocol Message {
    init(message: String)
    func prepareMessage()
    var contentToSend: String { get }
}

class ClearMessage: Message {
    private var message: String

    required init(message: String) {
        self.message = message
    }

    func prepareMessage() {
    }

    var contentToSend: String {
        return message
    }
}

class EncryptedMessage: Message {
    private var clearText: String
    private var cipherText: String?

    required init(message: String) {
        self.clearText = message
    }

    func prepareMessage() {
        cipherText = String(clearText.characters.reversed())
    }

    var contentToSend: String {
        return cipherText!
    }
}

// チャネル
protocol Channel {
    func sendMessage(msg: Message)
}

class LandlineChannel: Channel {
    func sendMessage(msg: Message) {
        print("Landline: \(msg.contentToSend)")
    }
}

class WirelessChannel: Channel {
    func sendMessage(msg: Message) {
        print("Wireless: \(msg.contentToSend)")
    }
}

// 追加
class SatelliteChannel: Channel {
    func sendMessage(msg: Message) {
        print("Satellite: \(msg.contentToSend)")
    }
}

class PriorityMessage: ClearMessage {
    override var contentToSend: String {
        return "Important: \(super.contentToSend)"
    }
}

// ブリッジ
protocol ClearMessageChannel {
    func send(message: String)
}

protocol SecureMessageChannel {
    func sendEncryptedMessage(encryptedText: String)
}

// 追加
protocol PriorityMessageChannel {
    func sendPriorityMessage(message: String)
}

class Communicator {
    private let clearChannel: ClearMessageChannel
    private let secureChannel: SecureMessageChannel

    // 追加
    private let priorityChannel: PriorityMessageChannel

    init(clearChannel: ClearMessageChannel, secureChannel: SecureMessageChannel, priorityChannel: PriorityMessageChannel) {
        self.clearChannel = clearChannel
        self.secureChannel = secureChannel
        self.priorityChannel = priorityChannel
    }

    func sendCleartextMessage(message: String) {
        self.clearChannel.send(message: message)
    }

    func sendSecureMessage(message: String) {
        self.secureChannel.sendEncryptedMessage(encryptedText: message + " ces")
    }

    func sendPriorityMessage(message: String) {
        self.priorityChannel.sendPriorityMessage(message: message)
    }
}

class CommunicatorBridge: ClearMessageChannel, SecureMessageChannel, PriorityMessageChannel {
    private var channel: Channel

    init(channel: Channel) {
        self.channel = channel
    }

    func send(message: String) {
        let msg = ClearMessage(message: message)
        sendMessage(msg: msg)
    }

    func sendEncryptedMessage(encryptedText: String) {
        let msg = EncryptedMessage(message: encryptedText)
        sendMessage(msg: msg)
    }

    func sendPriorityMessage(message: String) {
        sendMessage(msg: PriorityMessage(message: message))
    }

    private func sendMessage(msg: Message) {
        msg.prepareMessage()
        channel.sendMessage(msg: msg)
    }
}

var bridge = CommunicatorBridge(channel: SatelliteChannel())
var comms = Communicator(clearChannel: bridge, secureChannel: bridge, priorityChannel: bridge)
comms.sendPriorityMessage(message: "This imp")