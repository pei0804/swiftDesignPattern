//----------------
// Decorator
//----------------

// Decoratorパターンは、デコレータークラスを作成することにより、
// 1のような順序対応問題を解決します。

import Foundation

class CustomerAccount {
    let customerName: String
    var purchases = [Purchase]()

    init(name: String) {
        self.customerName = name
    }

    // 購入した商品を配列に追加する
    func addPurchase(purchase: Purchase) {
        self.purchases.append(purchase)
    }

    func printAccount() {
        var total: Float = 0
        // 購入した商品の一覧を出す
        for p in purchases {
            // 合計金額の計算
            total += p.totalPrice
            print("Purchase \(p.description), Price \(formatCurrencyString(number: p.totalPrice))")
        }
        print("total due \(formatCurrencyString(number: total))")
    }

    func formatCurrencyString(number: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: number as NSNumber) ?? ""
    }
}

class Purchase {
    private let product: String
    private let price: Float

    init(product: String, price: Float) {
        self.product = product
        self.price = price
    }

    var description: String {
        return product
    }

    var totalPrice: Float {
        return price
    }
}

// Decoratorパターンは変更することが不可能なクラスからの派生という方法で実装される。
// 同じプロパティと同じメソッドを定義し、元のクラスと全く同じように使えるクラスを作成。

class BasePurchaseDecorator: Purchase {
    private let wrappedPurchase: Purchase

    init(purchase: Purchase) {
        wrappedPurchase = purchase
        super.init(product: purchase.description, price: purchase.totalPrice)
    }
}

class PurchaseWithGiftWrap: BasePurchaseDecorator {
    override var description: String {
        return "\(super.description) + gift wrap 2$"
    }

    override var totalPrice: Float { return super.totalPrice + 2 }
}


class PurchaseWithRibbon: BasePurchaseDecorator {
    override var description: String {
        return "\(super.description) + ribbon 1$"
    }

    override var totalPrice: Float { return super.totalPrice + 1 }
}

class PurchaseWithDelivery: BasePurchaseDecorator {
    override var description: String {
        return "\(super.description) + delivery 5$"
    }

    override var totalPrice: Float { return super.totalPrice + 5}
}

let account = CustomerAccount(name: "Joe")

account.addPurchase(purchase: Purchase(product: "Red Hat", price: 10))
account.addPurchase(purchase: Purchase(product: "Scarf", price: 20))
//account.addPurchase(purchase: PurchaseWithGiftWrapAndDelivery(product: "Sunglasses", price: 25))
account.addPurchase(purchase: PurchaseWithDelivery(purchase: PurchaseWithGiftWrap(purchase: Purchase(product: "Sunglass", price: 25))))
account.printAccount()
