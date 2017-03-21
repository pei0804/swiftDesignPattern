//-------------
// Bridge
//-------------

protocol ClearMessageChannel {
    func send(message: String)
}

protocol SecureMessageChannel {
    func sendEncryptedMessage(encryptedText: String)
}

class Communicator {
    private let clearChannel: ClearMessageChannel
    private let secureChannel: SecureMessageChannel

    init(clearChannel: ClearMessageChannel, secureChannel: SecureMessageChannel) {
        self.clearChannel = clearChannel
        self.secureChannel = secureChannel
    }

    // 格納されたインスタンスの持っているメソッドで実行
    func sendCleartextMessage(message: String) {
        self.clearChannel.send(message: message)
    }

    func sendSecureMessage(message: String) {
        self.secureChannel.sendEncryptedMessage(encryptedText: message)
    }
}

// sendメソッド
class Landline: ClearMessageChannel {
    func send(message: String) {
        print("Landline: \(message)")
    }
}

class Wireless: ClearMessageChannel {
    func send(message: String) {
        print("Wireless: \(message)")
    }
}

// sendEncrypterdMessageメソッド
class SecureLandLine: SecureMessageChannel {
    func sendEncryptedMessage(encryptedText: String) {
        print("Secure Landline: \(encryptedText)")
    }
}

class SecureWireless: SecureMessageChannel {
    func sendEncryptedMessage(encryptedText: String) {
        print("Secure Wireless: \(encryptedText)")
    }
}

// 今回のサンプルコードは十分に検討されて増えていく類のコードではありません。
// 徐々に増えていき、上記のようなクラスが作成されたという想定のものです。

// このコードで起きる問題は、新しい機能やプラットフォームを作成した時に実装クラスが、
// 急激に増えていくことにあります。どういうか説明すると、
// 現状はLandlineとWirelessの２つのプラットフォームに２つの機能があります。
// もし、そこにプラットフォームと機能が１つずつ追加されると、一気にクラスが9つ増えます。
// こういう問題はクラス階層の爆発と呼ばれていて、手に負えなくなります。
// Bridgeはこういった問題に役立ちます。

var clearChannel = Wireless()
var secureChannel = SecureWireless()

var comms = Communicator(clearChannel: clearChannel, secureChannel: secureChannel)
comms.sendCleartextMessage(message: "Hello")
comms.sendSecureMessage(message: "This is a secret")
