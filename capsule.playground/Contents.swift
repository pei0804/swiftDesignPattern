//: Playground - noun: a place where people can play

// =================
// カプセル化
// =================

// 疎結合にするだけでも便利ですが、最大のメリットはカプセル化にあります。

// 可読性
// データ値とそれらの操作するロジックが１つのコンポーネントにまとめられる。
// データとロジックをまとめると、そのデータ型に関連するものが全て同じ場所に定義されるので、
// コードが読みやすくなる。

// 密結合の防止
// 実装を公開せずにプロパティやメソッドを表現できれば、
// 他のコンポーネントが実装に依存することが不可能になるため、密結合にならない。
class Product {
    var name: String
    var desc: String
    var price: Double
    private var stockBackingValue: Int = 0

    var stock: Int {
        get {
            return stockBackingValue
        }
        // Int型ならなんでも格納出来るが、0未満の場合はエラー防止のために0としたいプロパティは、
        // 以下のようにセッターを格納型から計算型に変えることで、エラーを未然に防ぐことが出来る。
        // しかも、この実装だと、プロパティを使っているコンポーネントは影響を受けることがない。
        set {
            return stockBackingValue = max(0, newValue)
        }
    }

    init(name: String, desc: String, price: Double, stock: Int) {
        self.name = name
        self.desc = desc
        self.price = price
    }


    func calculateTax(rate: Double) -> Double {
        // 仮に以下のように最大金額を定義を後から定義しても、
        // このメソッドを使っているコンポーネントは影響を受けない。
        return min(10, self.price * rate)
    }


    var stockValue: Double {
        get {
            return self.price * Double(self.stock)
        }
    }
}

var products = [
    Product(name: "A", desc: "A info", price: 275.0, stock: 10),
    Product(name: "B", desc: "B info", price: 341.0, stock: 10),
    Product(name: "C", desc: "C info", price: 275.0, stock: 10)
]

func culclateTax(product: Product) -> Double {
    return product.price * 0.08
}

func calculateStockValue(productArray: [Product]) -> Double {
    return productArray.reduce(0, { (total, product) -> Double in
        return total + product.stockValue
    })
}

print(products[0].calculateTax(rate: 0.2))
print(culclateTax(product: products[0]))

products[0].stock = -20
print(products[0].stock)