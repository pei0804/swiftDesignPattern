//----------------
// Builder
//----------------

// Builderパターンを使用せずにBurgerオブジェクトを作成した方法と同じに見えますが、
// 中間メカニズムとして、ビルダーを使用することで、変更の影響が受けにくくなっていて、柔軟性が高い。

class BurgerBuilder {
    private var veggie = false
    // 改善された点
    // ピクルスが人気ないので、最初からfalseにするなどが出来る。
    private var pickles: Bool = true
    private var mayo: Bool = true
    private var ketchup: Bool = true
    private var lettuce: Bool = true
    private var cooked: Burger.Cooked = Burger.Cooked.NORMAL
    private var patties: Int = 2
    // 改善された点          
    // オブジェクトを変更してもコンポーネントには影響がでない
    private var bacon = true

    // 改善された点
    // イレギュラーな処理が入っても影響がない。
    func setVeggie(choice: Bool) {
        self.veggie = choice
        if choice {
            self.bacon = false
        }
    }
    func setPickles(choice: Bool) { self.pickles = choice }
    func setMayo(choice: Bool) { self.mayo = choice }
    func setKetchup(choice: Bool) { self.ketchup = choice }
    func setLettuce(choice: Bool) { self.lettuce = choice }
    func setCooked(choice: Burger.Cooked ) { self.cooked = choice }
    func addPatty(choice: Bool) { self.patties = choice ? 3 : 2 }
    func setBacon(choice: Bool) { self.bacon = choice }

    func build(name: String) -> Burger {
        return Burger(name: name, veggie: self.veggie, patties: self.patties, pickles: self.pickles, mayo: self.mayo, ketchup: self.ketchup, lettuce: self.lettuce, cook: self.cooked, bacon: self.bacon)
    }
}

class Burger {
    let customerName: String
    let veggieProduct: Bool
    let patties: Int
    let pickles: Bool
    let mayo: Bool
    let ketchup: Bool
    let lettuce: Bool
    let cook: Cooked
    let bacon: Bool

    enum Cooked: String {
        case RARE = "Rare"
        case NORMAL = "Normal"
        case WELLDONE = "WellDone"
    }

    init(name: String, veggie: Bool, patties: Int, pickles: Bool, mayo: Bool, ketchup: Bool, lettuce: Bool, cook: Cooked, bacon: Bool) {
        self.customerName = name
        self.veggieProduct = veggie
        self.patties = patties
        self.pickles = pickles
        self.mayo = mayo
        self.ketchup = ketchup
        self.lettuce = lettuce
        self.cook = cook
        self.bacon = bacon
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
        print("Bacon: \(self.bacon)")
    }
}

var builder = BurgerBuilder()

// 名前を聞く
let name = "joe"

// 改善された点
// 以下の注文プロセスは自由に変えることが出来る。

// ベジタリアンメニューが必要か
builder.setVeggie(choice: false)

// ハンバーガーカスタマイズ
builder.setMayo(choice: false)
builder.setCooked(choice: Burger.Cooked.WELLDONE)

// パテ追加
builder.addPatty(choice: false)

let order = builder.build(name: name)

order.printDescription()

