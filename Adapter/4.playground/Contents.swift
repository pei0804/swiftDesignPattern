//------------------
// Adapter
//------------------

// 双方向アダプターを作成する
// 標準実装では、メソッドとプロパティの呼び出し方向がアプリケーションからコンポーネントへの一方方向であることが前提となる。
// しかし、アプリケーションから情報を取得したり、状態の変化や提供するサービスをアプリケーションに通知するなど、
// コンポーネント側からアクションを開始することが期待されるケースもある。

// アプリケーション
protocol ShapeDrawer {
    func drawShape()
}

class DrawingApp {
    let drawer: ShapeDrawer
    var cornerRadius: Int = 0

    init(drawer: ShapeDrawer) {
        self.drawer = drawer
    }

    func makePicture() {
        drawer.drawShape()
    }
}

// コンポーネントのライブラリ

protocol AppSettings {
    var sketchRoundedShapes: Bool { get }
}

class SketchComponent {
    private let settings: AppSettings

    init(settings: AppSettings) {
        self.settings = settings
    }

    func sketchShape() {
        if settings.sketchRoundedShapes {
            print("Sketch Circle")
        } else {
            print("Sketch Square")
        }
    }
}

// Adapter

class TwoWayAdapter: ShapeDrawer, AppSettings {
    var app: DrawingApp?
    var component: SketchComponent?

    func drawShape() {
        component?.sketchShape()
    }

    var sketchRoundedShapes: Bool {
        return (app?.cornerRadius)! > 0
    }
}

let adapter = TwoWayAdapter()

let component = SketchComponent(settings: adapter)
let app = DrawingApp(drawer: adapter)
app.cornerRadius = 1

adapter.app = app
adapter.component = component
print(adapter.sketchRoundedShapes)
app.makePicture()
