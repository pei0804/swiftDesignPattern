//: Playground - noun: a place where people can play

// =================
// カプセル化
// =================

// 疎結合にするだけでも便利ですが、最大のメリットはカプセル化にあります。
class Product {
    var name: String
    var desc: String
    var price: Double
    var stock: Int

    init(name: String, desc: String, price: Double, stock: Int) {
        self.name = name
        self.desc = desc
        self.price = price
        self.stock = stock
    }

    func calculateTax(rate: Double) -> Double {
        return self.price * rate
    }

    // データ値とそれらの操作するロジックが１つのコンポーネントにまとめられる。
    // データとロジックをまとめると、そのデータ型に関連するものが全て同じ場所に定義されるので、
    // コードが読みやすくなる。
    var stockValue: Double {
        get {
            return self.price * Double(self.stock)
        }
    }
}

// クラスや構造体を定義するのは手間だけど、タプルの時のような構造を気にしないで済む。
// 仮にdescプロパティがなくなったとしても元々定義されているメソッドは一切変更なしで済む。
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
