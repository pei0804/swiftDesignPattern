//--------------
// Bridge
//--------------

// FactoryMethodとの組み合わせ
// プラットフォームは実行時に選択され、通常はコンフィグレーションファイルなどの外部設定が使用される。
// サンプルプロジェクトの場合は、プラットフォームはメッセージを送信するためのチャネルであり、
// プラットフォームの選択は利用可能なネットワークハードウェアに基いて選択される
// ですが、いまはコードで明示的に指定するような仕様になっている。
// var bridge = CommunicatorBridge(channel: SatelliteChannel())

// プラットフォーム固有の実装がコンパイル時に選択されることと、プラットフォームを変更するにはコードを変更して、
// 再コンパイルする必要があることを考えると現実的ではない。
// このようにしたのはBridgeパターンをカスタマイズする最も簡単な方法は、Factory Methodパターンを適用し、
// プラットフォーム固有の実装をブリッジクラスとアプリケーションの他の部分から隠す。

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

// プロトコルからクラスへ変更する。
　
//protocol Channel {
//    func sendMessage(msg: Message)
//}

class Channel {
    enum Channels {
        case Landline
        case Wireless
        case Satellite
    }

    class func getChannel(channelType: Channels) -> Channel {
        switch channelType {
        case .Landline:
            return LandlineChannel()
        case .Wireless:
            return WirelessChannel()
        case .Satellite:
            return SatelliteChannel()
        }
    }

    func sendMessage(msg: Message) {
        fatalError("Not implemented")
    }
}

class LandlineChannel: Channel {
    override func sendMessage(msg: Message) {
        print("Landline: \(msg.contentToSend)")
    }
}

class WirelessChannel: Channel {
    override func sendMessage(msg: Message) {
        print("Wireless: \(msg.contentToSend)")
    }
}

class SatelliteChannel: Channel {
    override func sendMessage(msg: Message) {
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

protocol PriorityMessageChannel {
    func sendPriorityMessage(message: String)
}

class Communicator {
    private let clearChannel: ClearMessageChannel
    private let secureChannel: SecureMessageChannel
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

    init(channel: Channel.Channels) {
        self.channel = Channel.getChannel(channelType: channel)
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

//var bridge = CommunicatorBridge(channel: SatelliteChannel())
var bridge = CommunicatorBridge(channel: Channel.Channels.Satellite)
var comms = Communicator(clearChannel: bridge, secureChannel: bridge, priorityChannel: bridge)
comms.sendPriorityMessage(message: "This imp")