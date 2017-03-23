//----------------
// Decorator
//----------------

// Purchaseクラスは、顧客が店が選択した商品を表す。
// このクラスには、商品の名前と価格を格納するプロパティが定義されています。
// descriptionとtotalPriceの２つの計算型のプロパティを通じて公開されている。

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

// CustomerAccountクラスは、顧客の購入を表すPurchaseオブジェクトのコレクションを管理する。

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

// 例えば、ここにギフトオプションを追加したいとなった時に、PurchaseまたあCustomerAccountを変更する必要があります。
// しかし、クラス変更できないがあります。例えばPurchaseとCustomerAccountが販売管理パッケージだったとします。

let account = CustomerAccount(name: "Joe")
account.addPurchase(purchase: Purchase(product: "Red Hat", price: 10))
account.addPurchase(purchase: Purchase(product: "Scarf", price: 20))
account.printAccount()

class PurchaseWithGiftWrap: Purchase {
    override var description: String {
        return "\(super.description) + gift wrap 2$"
    }

    override var totalPrice: Float { return super.totalPrice + 2 }
}


class PurchaseWithRibbon: Purchase {
    override var description: String {
        return "\(super.description) + ribbon 1$"
    }

    override var totalPrice: Float { return super.totalPrice + 1 }
}

class PurchaseWithDelivery: Purchase {
    override var description: String {
        return "\(super.description) + delivery 5$"
    }

    override var totalPrice: Float { return super.totalPrice + 5}
}

print("-------")
account.addPurchase(purchase: PurchaseWithGiftWrap(product: "Sunglasses", price: 25))
account.printAccount()

// 上記のようなサブクラスを作成すれば、一応動作します。
// 顧客が必要に応じて、オプションを組み合わせることができるというビジネス要件が満たされていない。
// 例えば、ギフトとデリバリーの組み合わせが出来ないなど。
// 一応のようなクラスを追加すれば対応可能ですが。。。効率的ではないですね。

// ギフト包装
// リボン
// ギフト配送
// ギフト包装 + リボン
// .....

// 考えられる全ての順序を対処する必要がある。

class PurchaseWithGiftWrapAndDelivery: Purchase {
    override var description: String {
        return "\(super.description) + gift wrap 5$ + delivery 2$"
    }

    override var totalPrice: Float { return super.totalPrice + 5 + 2 }
}

print("-------")
account.addPurchase(purchase: PurchaseWithGiftWrapAndDelivery(product: "Sunglasses", price: 25))
account.printAccount()
