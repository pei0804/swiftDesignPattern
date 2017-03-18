//: Playground - noun: a place where people can play
//-----------------
// 初期化コスト
//-----------------
// 以下にテンプレートパターンを適用した時に発生する。
// 早まった最適化について説明する。
// この問題の解決策は、prototypeパターンで解説します。
class Sum {
    var resultsCache: [[Int]] = [[]]
    var fistValue: Int = 0
    var secondValue: Int = 0

    // イニシャライザが複雑だったり、大量メモリを消費するものである場合、
    // 本当に必要かを考える必要がある
    init(first: Int, second: Int) {
        resultsCache = [[Int]](repeating: [Int](repeating: 0, count:10), count: 10)

        for i in 0..<10 {
            for j in 0..<10 {
                resultsCache[i][j] = i + j
            }
        }
        self.fistValue = first
        self.secondValue = second
    }

    var Result: Int {
        get {
            return fistValue < resultsCache.count
            && secondValue < resultsCache[fistValue].count
            ? resultsCache[fistValue][secondValue]
            : fistValue + secondValue
        }
    }
}

var calc1 = Sum(first: 0, second: 9).Result
var calc2 = Sum(first: 3, second: 8).Result

print("Calc1 \(calc1) Calc2 \(calc2)")

class Sum2 {
    var resultsCache: [[Int]] = [[]]
    var fistValue: Int = 0
    var secondValue: Int = 0

    // 例えば、イニシャライザが少しでも変わった時に、
    // このクラスを使っているコンポーネント全体に影響が発生してしまう。
    init(first: Int, second: Int, cacheSize: Int) {
        resultsCache = [[Int]](repeating: [Int](repeating: 0, count: cacheSize), count: cacheSize)

        for i in 0..<cacheSize {
            for j in 0..<cacheSize {
                resultsCache[i][j] = i + j
            }
        }
        self.fistValue = first
        self.secondValue = second
    }

    var Result: Int {
        get {
            return fistValue < resultsCache.count
                && secondValue < resultsCache[fistValue].count
                ? resultsCache[fistValue][secondValue]
                : fistValue + secondValue
        }
    }
}

// 変更が必要
var calc3 = Sum2(first: 0, second: 9, cacheSize: 100).Result
var calc4 = Sum2(first: 3, second: 8, cacheSize: 20).Result

print("Calc3 \(calc3) Calc4 \(calc4)")