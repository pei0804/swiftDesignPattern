//------------------
// Decorator
//------------------

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

class DiscountDecorator: Purchase {
    private let wrappedPurchase: Purchase

    init(purchase: Purchase) {
        self.wrappedPurchase = purchase
        super.init(product: purchase.description, price: purchase.totalPrice)
    }

    override var description: String {
        return super.description
    }

    var discountAmount: Float {
        return 0
    }

    func countDiscounts() -> Int {
        var total = 1
        if let discounter = self.wrappedPurchase as? DiscountDecorator {
            total += discounter.countDiscounts()
        }
        return total
    }
}

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

class BlackFridayDecorator: DiscountDecorator {
    override var totalPrice: Float {
        return super.totalPrice - discountAmount
    }

    override var discountAmount: Float {
        return super.totalPrice * 0.20
    }
}

class EndOfLineDecorator: DiscountDecorator {
    override var totalPrice: Float {
        return super.totalPrice - discountAmount
    }

    override var discountAmount: Float {
        return super.totalPrice * 0.70
    }
}

let account = CustomerAccount(name: "Joe")

account.addPurchase(purchase: Purchase(product: "Red Hat", price: 10))
account.addPurchase(purchase: Purchase(product: "Scarf", price: 20))

// 新しい機能を実装しているデコレートターには、デコレーションを適用する方法に関して宣言がある。
// 新しい機能を提供するには、デコレートタークラスのインスタンスごとに、それを検出できる他のコンポーネントがひとつは必要になります。
// それは呼び出し元のコンポーネントか、入れ子のデコレータの場合はラッパーとして機能するデコレータです。

// 価格全体に割引
account.addPurchase(purchase:
    EndOfLineDecorator(purchase:
        BlackFridayDecorator(purchase:
            PurchaseWithGiftWrap(purchase:
                PurchaseWithDelivery(purchase:
                    Purchase(product: "Sunglasses", price: 25))))))

// 販売価格にのみ割引
account.addPurchase(purchase:
    EndOfLineDecorator(purchase:
        PurchaseWithDelivery(purchase:
            PurchaseWithGiftWrap(purchase:
                BlackFridayDecorator(purchase:
                    Purchase(product:"Sunglasses", price:25))))));
account.printAccount()

for p in account.purchases {
    if let d = p as? DiscountDecorator {
        print("\(p.description) has \(d.countDiscounts())")
    } else {
        print("\(p.description) has no discounts")
    }
}
