//-----------------
// builder
//-----------------
// FactoryMethodとの組み合わせ

// 注文可能なハンバーガーの種類を定義するBurgersという列挙型を作成し、
// BurgerBuilderクラスでファクトリメソッドを定義している。
// 今回のBuilderの場合、クラスごとに使えないメソッドがあるので、
// 注文プロセスに最初に種類を選択する必要がある。

enum Burgers {
    case STANDARD
    case BIGBURGER
    case SUPERVEGGIE
}

class BurgerBuilder {
    fileprivate var veggie = false
    fileprivate var pickles: Bool = true
    fileprivate var mayo: Bool = true
    fileprivate var ketchup: Bool = true
    fileprivate var lettuce: Bool = true
    fileprivate var cooked: Burger.Cooked = Burger.Cooked.NORMAL
    fileprivate var patties: Int = 2
    fileprivate var bacon = true

    fileprivate init() {
    }

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

    class func getBuilder(burgerType: Burgers) -> BurgerBuilder {
        var builder: BurgerBuilder
        switch burgerType {
        case .BIGBURGER: builder = BigBurgerBuilder()
        case .SUPERVEGGIE: builder = SuperVeggieBurgerBuilder()
        case .STANDARD: builder = BurgerBuilder()
        }
        return builder
    }
}

class BigBurgerBuilder: BurgerBuilder {
    fileprivate override init() {
        super.init()
        self.patties = 4
        self.bacon = false
    }

    override func addPatty(choice: Bool) {
        fatalError("cannot add patty to Big Burger")
    }
}

class SuperVeggieBurgerBuilder: BurgerBuilder {
    fileprivate override init() {
        super.init()
        self.veggie = true
        self.bacon = false
    }

    override func setVeggie(choice: Bool) {
        // 何もしない。絶対にベジタブル
    }

    override func addPatty(choice: Bool) {
        fatalError("cannot add bacon to this Burger")
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

// var builder = BurgerBuilder()

// 名前を聞く
let name = "joe"

// バーガーの種類を選ぶ
let builder = BurgerBuilder.getBuilder(burgerType: .BIGBURGER)

// バーガーをカスタマイズ
builder.setMayo(choice: false)
builder.setCooked(choice: Burger.Cooked.WELLDONE)

let order = builder.build(name: name)
order.printDescription()