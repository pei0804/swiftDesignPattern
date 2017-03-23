//-----------------
// Decorator
//-----------------

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

class BasePurchaseDecorator: Purchase {
    private let wrappedPurchase: Purchase

    init(purchase: Purchase) {
        wrappedPurchase = purchase
        super.init(product: purchase.description, price: purchase.totalPrice)
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

// ここまで単純なデコレータークラスを定義してきました。
// これはDecotratorパターンの仕組みを重点的に取り上げ、
// デコレーターがラッピングするクラスやそれらを使用するコンポーネントに影響を与えずに、
// デコレーターを選択して適用する方法を示したいと考えたからです。
// 実際にはデコレーターはそこまで単純にする必要はなく、元のクラスが定義しているメソッドや
// プロパティをどのようにしても構わない。一般的なバリエーションのひとつでデコレーター結合を以下に記述します。


class GiftOptionDecorator: Purchase {
    private let wrappedPurchase: Purchase
    private let options: [OPTION]

    enum OPTION {
        case GIFTWARAP
        case RIBBON
        case DELIVERY
    }

    init(puchase: Purchase, options: OPTION...) {
        self.wrappedPurchase = puchase
        self.options = options
        super.init(product: puchase.description, price: puchase.totalPrice)
    }

    override var description: String {
        var result = wrappedPurchase.description
        for option in options {
            switch option {
            case .GIFTWARAP:
                result = "\(result) + gift wrap"
            case .RIBBON:
                result = "\(result) + ribbon"
            case .DELIVERY:
                result = "\(result) + delivery"
            }
        }
        return result
    }

    override var totalPrice: Float {
        var result = wrappedPurchase.totalPrice
        for option in options {
            switch option {
            case .GIFTWARAP:
                result += 2
            case .RIBBON:
                result += 1
            case .DELIVERY:
                result += 5
            }
        }
        return result
    }
}


let account = CustomerAccount(name: "Joe")

account.addPurchase(purchase: Purchase(product: "Red Hat", price: 10))
account.addPurchase(purchase: Purchase(product: "Scarf", price: 20))
account.addPurchase(purchase:
    BlackFridayDecorator(purchase:
        GiftOptionDecorator(puchase: Purchase(product: "Scarf", price: 20), options: GiftOptionDecorator.OPTION.DELIVERY)))
account.printAccount()

for p in account.purchases {
    if let d = p as? DiscountDecorator {
        print("\(p.description) has \(d.countDiscounts())")
    } else {
        print("\(p.description) has no discounts")
    }
}