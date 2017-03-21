//: Playground - noun: a place where people can play

// =================
// 密結合
// =================

// 以下のような形の決まっているタプルなどを使うと関数と密結合になってしまう。
var ngProducts = [
    ("A", "A info", 275.0, 10),
    ("B", "B info", 341.0, 10),
    ("A", "A info", 275.0, 10),
]

// 例えばタプルの数が変わったり、順番が変わると引数を全て書き直す必要がある。
func ngCluclateTax(product: (String, String, Double, Int)) -> Double {
    return product.2 * 0.08
}

func ngCaluclateStockValue(tuples: [(String, String, Double, Int)]) -> Double {
    return tuples.reduce(0, {(total, product) -> Double in
        return total + (product.2 * Double(product.3))
    })
}

print(ngCaluclateStockValue(tuples: ngProducts))
print(ngCluclateTax(product: ngProducts[0]))


// =================
// 疎結合
// =================

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
}

// クラスや構造体を定義するのは手間ですが、タプルの時のような構造を気にしないで済む。
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
        return total + (product.price * Double(product.stock))
    })
}

print(calculateStockValue(productArray: products))
print(culclateTax(product: products[0]))