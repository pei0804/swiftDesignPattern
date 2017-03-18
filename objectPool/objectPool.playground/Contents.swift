//----------------
// objectpool
//----------------
// 代替可能なオブジェクトの集まりを管理するパターン。
// オブジェクトを必要とするコンポーネントは、オブジェクトをプールから借り、
// それらを使って作業し、使い終わったら返す。（図書館のような感じ）
class Book {
    let author: String
    let title: String
    let stockNumber: Int
    var reader: String?
    var checkoutCount: Int = 0

    init(author: String, title: String, stock: Int) {
        self.author = author
        self.title = title
        self.stockNumber = stock
    }
}

import Foundation

class Pool<T> {
    private var data = [T]()
    private let serialQueue = DispatchQueue(label: "serial-queue")
    // セマフォ　https://blog.ymyzk.com/2015/08/gcd-grand-central-dispatch-semaphore/
    private var semaphore = DispatchSemaphore(value: 0)

    init(items: [T]) {
        data.reserveCapacity(data.count)
        for item in items {
            data.append(item)
        }
        // セマフォを作成する
        semaphore = DispatchSemaphore(value: items.count)
    }

    func getFromPool() -> T? {
        var result: T?
        // オブジェクトがチェックアウトが可能化調べる
        // しかし、ミリ単位の違いで同時アクセスがあると、エラーになる可能生がある
        // そのためセマフォを使ってブロックをする

        // セマフォの数をひとつ減らす
        // 0だとブロックされる
        semaphore.wait()
        if(data.count > 0) {
            // 同時に処理が発生するとまずい処理はシリアルにする
            serialQueue.sync {
                result = self.data.remove(at: 0)
            }
        }
        return result
    }

    func returnToPool(item: T) {
        // 同時に処理が発生するとまずい処理はシリアルにする
        serialQueue.sync {
            self.data.append(item)
            // セマフォの数をひとる増やす
            semaphore.signal()
        }
    }
}
// 同時アクセスが絶対にないようなアプリケーションでは、データ保護は必要なし
// しかし、アプリケーションは規模が大きくなると保護が必要になることもあるので、
// 最初から保護の処理は入れておいたほうがいい。

// 実行例
final class Library {
    private var books: [Book] = []
    private let pool: Pool<Book>

    // 今回の例ではLibraryがひとつだけ存在するべきのため、シングルトンにしている
    static let sharedInstance: Library = {

        // 2冊まで貸し出せる
        let instance = Library(stockLevel: 2)
        return instance
    }()

    private init(stockLevel: Int) {
        for count in 1...stockLevel {
            // 本の登録
            books.append(Book(author: "pei", title: "hal", stock: count))
        }
        pool = Pool<Book>(items: books)
    }

    // 本を借りる
    class func checkoutBook(reader: String) -> Book? {
        let book = sharedInstance.pool.getFromPool()
        // 貸し出した人
        book?.reader = reader
        print(reader)
        // 貸し出した回数
        book?.checkoutCount += 1
        return book
    }

    // 本を返す
    class func returnBook(book: Book) {
        book.reader = nil
        sharedInstance.pool.returnToPool(item: book)
    }

    class func printReport() {
        for book in sharedInstance.books {
            print("BookNumber: \(book.stockNumber)")
            print("Checked out \(book.checkoutCount) times")
            if(book.reader != nil) {
                // 本が借りている人
                print("checked out to \(book.reader!)")
            } else {
                print("In stock")
            }
        }
    }
}

// 実行
let queue = DispatchQueue(label: "concurrent-queue", attributes: .concurrent)
let group = DispatchGroup()

print("Start")

// 20回貸出を行う
for i in 1...20 {
    queue.async(group: group) {
        // 本を借りる
        var book = Library.checkoutBook(reader: "reader:\(i)")
        // 本を借りれたら、ランダムな時間語返す
        if(book != nil) {
            Thread.sleep(forTimeInterval: Double(arc4random() % 2))
            Library.returnBook(book: book!)
        }
    }
}

_ = group.wait()
print("all books comp")
Library.printReport()