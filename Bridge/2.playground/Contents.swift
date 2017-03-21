//-----------------
// Bridge
//-----------------

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

// ブリッジ
protocol ClearMessageChannel {
    func send(message: String)
}

protocol SecureMessageChannel {
    func sendEncryptedMessage(encryptedText: String)
}

class Communicator {
    private let clearChannel: ClearMessageChannel
    private let secureChannel: SecureMessageChannel

    // 2: Communicatorを使えるようにするためにbridgeインスタンスを渡す
    init(clearChannel: ClearMessageChannel, secureChannel: SecureMessageChannel) {
        self.clearChannel = clearChannel
        self.secureChannel = secureChannel
    }

    func sendCleartextMessage(message: String) {
        self.clearChannel.send(message: message)
    }

    func sendSecureMessage(message: String) {
        self.secureChannel.sendEncryptedMessage(encryptedText: message + " ces")
    }
}

class CommunicatorBridge: ClearMessageChannel, SecureMessageChannel {
    private var channel: Channel

    // 1: channelを選択する
    // LandlineChannel WirelessChannelのどちらか
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

    private func sendMessage(msg: Message) {
        msg.prepareMessage()
        channel.sendMessage(msg: msg)
    }
}

//var clearChannel = Landline()
//var comms = SecureLandLine()

// 1: channelを選択する
// LandlineChannel WirelessChannelのどちらか
var bridge = CommunicatorBridge(channel: LandlineChannel())

// 2: Communicatorを使えるようにするためにbridgeインスタンスを渡す
var comms = Communicator(clearChannel: bridge, secureChannel: bridge)

comms.sendCleartextMessage(message: "Hello!")
comms.sendSecureMessage(message: "This is a secret")