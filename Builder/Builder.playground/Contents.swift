//----------------
// Builder
//----------------

// オブジェクトを作成するには、大量の設定データが必要で、
// 呼び出し元のコンポーネントに全ての値が揃っているとは限らない場合に使う。

class Burger {
    let customerName: String
    let veggieProduct: Bool
    let patties: Int
    let pickles: Bool
    let mayo: Bool
    let ketchup: Bool
    let lettuce: Bool
    let cook: Cooked

    enum Cooked: String {
        case RARE = "Rare"
        case NORMAL = "Normal"
        case WELLDONE = "WellDone"
    }

    init(name: String, veggie: Bool, patties: Int, pickles: Bool, mayo: Bool, ketchup: Bool, lettuce: Bool, cook: Cooked) {
        self.customerName = name
        self.veggieProduct = veggie
        self.patties = patties
        self.pickles = pickles
        self.mayo = mayo
        self.ketchup = ketchup
        self.lettuce = lettuce
        self.cook = cook
    }

    func printDescription() {
        print("Name: \(self.customerName)")
        print("Veggie: \(self.veggieProduct)")
        print("Patties: \(self.patties)")
        print("Pickles: \(self.pickles)")
        print("mayo: \(self.mayo)")
        print("Ketchup: \(self.ketchup)")
        print("Lettuce: \(self.lettuce)")
        print("Cook: \(self.cook)")
    }
}

let order = Burger(name: "joe", veggie: false, patties: 2, pickles: true, mayo: true, ketchup: true, lettuce: true, cook: Burger.Cooked.NORMAL)
order.printDescription()


// このバーガーショップの流れは以下の通り
// 現状の問題点は、カスタマイズしない場合の設定データのデフォルト値を理解している必要があること。

// 名前
let name = "joe"

// ベジタリアン
let veggie = false

// カスタマイズ
let pickles = true
let mayo = false
let ketchup = true
let lettuce = true
let cooked = Burger.Cooked.NORMAL

// パテ
let patties = 2

let order2 = Burger(name: name, veggie: veggie, patties: patties, pickles: pickles, mayo: mayo, ketchup: ketchup, lettuce: lettuce, cook: cooked)
order2.printDescription()

// Telecoping Initializerアンチパターン
// 他の言語では、Builderパターンは、Telescoping InitializerまたはTelescoping Constructorと呼ばれるアンチパターンの代わりに疲れる使われる。
// クラスの操作を単純にするために、Telescoping Initilaizerパターンはよく使われる。

// 例えば以下のようなクラスがあった場合

class Milkshake {
    enum Size {
        case SMLL
        case MEDIUM
        case LARGE
    }

    enum Flavor {
        case CHOCO
        case STARWBERRY
        case VANILLA
    }

    let count: Int
    let size: Size
    let flavor: Flavor

    init(flavor: Flavor, size: Size, count: Int) {
        self.flavor = flavor
        self.size = size
        self.count = count
    }
}

// 呼び出し元のコンポーネントは、イニシャライザのデフォルト値を知っている必要があり、
// デフォルト値を使用する場合は、指定する必要がある。
var shake = Milkshake(flavor: Milkshake.Flavor.CHOCO, size: Milkshake.Size.MEDIUM, count: 1)

// デフォルトを指定して改善してみる
class Milkshake2 {
    enum Size {
        case SMLL
        case MEDIUM
        case LARGE
    }

    enum Flavor {
        case CHOCO
        case STARWBERRY
        case VANILLA
    }

    let count: Int
    let size: Size
    let flavor: Flavor

    init(flavor: Flavor, size: Size, count: Int) {
        self.flavor = flavor
        self.size = size
        self.count = count
    }

    // ほとんどのお客さんは数量はひとつを指定することが多いので改善のために、イニシャライザを変更する
    convenience init(flavor: Flavor, size: Size) {
        self.init(flavor: flavor, size: size, count: 1)
    }

    convenience init(flavor: Flavor) {
        self.init(flavor: flavor, size: Size.MEDIUM)
    }
}

// 以下のようにコードが短くなり、呼び出しは楽になった？
// この設計の問題（Telescopes Initialaizer） は、イニシャライザが複雑になり、
// メンテナンスがしにくい読みにくくなる。
var shake2 = Milkshake2(flavor: Milkshake2.Flavor.CHOCO)

// Swiftでは、以下のような解決アプローチが考えられる
class Milkshake3 {
    enum Size {
        case SMLL
        case MEDIUM
        case LARGE
    }

    enum Flavor {
        case CHOCO
        case STARWBERRY
        case VANILLA
    }

    let count: Int
    let size: Size
    let flavor: Flavor

    // デフォルト値を設定し、設定されなければ自動で設定されるようにする。
    init(flavor: Flavor, size: Size = Size.MEDIUM, count: Int = 1) {
        self.flavor = flavor
        self.size = size
        self.count = count
    }
}