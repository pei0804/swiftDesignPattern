//: Playground - noun: a place where people can play

//-----------
// 初期化コストの削減
//-----------
import Foundation

class Sum: NSObject, NSCopying {
    var resultsCache: [[Int]] = [[]]
    var fistValue: Int = 0
    var secondValue: Int = 0

    init(first: Int, second: Int, cacheSize: Int) {
        resultsCache = [[Int]](repeating: [Int](repeating: 0, count: cacheSize), count: cacheSize)

        // ものすごく時間のかかる処理
        for i in 0..<cacheSize {
            for j in 0..<cacheSize {
                resultsCache[i][j] = i + j
            }
        }
        self.fistValue = first
        self.secondValue = second
    }

    private init(first: Int, second: Int, cache:[[Int]]) {
        self.fistValue = first
        self.secondValue = second
        self.resultsCache = cache
    }

    var Result: Int {
        get {
            return fistValue < resultsCache.count
                && secondValue < resultsCache[fistValue].count
                ? resultsCache[fistValue][secondValue]
                : fistValue + secondValue
        }
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return Sum(first: self.fistValue, second: self.secondValue, cache: self.resultsCache)
    }
}

// 初期化を行う
var prototype = Sum(first: 0, second: 9, cacheSize: 100)

// 初期化済みのオブジェクトを参照コピー
var calc1 = prototype.Result

// クローニング
var clone = prototype.copy() as! Sum
clone.fistValue = 3
clone.secondValue = 8

// 初期化コストなし
var calc2 = clone.Result
print("Calc1 \(calc1) Calc2 \(calc2)")


// 上記のようにひとつのプロトタイプから、コピーを作成することで、
// 本来時間のかかっていた処理をせずに、複数のオブジェクトを作成することが出来る。
