//--------------
// Adapter
//--------------

// このパターンによって解決される問題
// 既存システムに新しいコンポーネントを統合する必要が生じた時に使うべきパターンです。
// このコンポーネントは同じような機能を提供するけど、共通インタフェースがなく変更することも出来ない。
// 以下のサンプルは、既存のシステムを表している。
// 問題が発生するのは、EmployeeDataSourceに準拠しないデータソースが発生した時です。

struct Employee {
    var name: String
    var title: String
}

protocol EmployeeDataSource {
    var employees: [Employee] { get }
    func searchByName(name: String) -> [Employee]
    func searchByTitle(title: String) -> [Employee]
}

import Foundation

class DataSourceBase: EmployeeDataSource {
    var employees: [Employee] = [Employee]()

    func searchByName(name: String) -> [Employee] {
        return search(selector: {e -> Bool in
            return e.name.range(of: name) != nil
        })
    }

    func searchByTitle(title: String) -> [Employee] {
        return search(selector: {e -> Bool in
            return e.title.range(of: title) != nil
        })
    }


    private func search(selector:((Employee) -> Bool)) -> [Employee] {
        var results = [Employee]()
        for e in employees {
            if selector(e) {
                results.append(e)
            }
        }
        return results
    }
}

class SalesDataSource: DataSourceBase {
    override init() {
        super.init()
        employees.append(Employee(name: "Alice", title: "VP of Sales"))
        employees.append(Employee(name: "Bob", title: "Account Exec"))
    }
}

class DevelopmentDataSource: DataSourceBase {
    override init() {
        super.init()
        employees.append(Employee(name: "Joe", title: "VP of Development"))
        employees.append(Employee(name: "Pepe", title: "Developer"))
    }
}

class SearchTool {
    enum SearchType {
        case NAME
        case TITLE
    }

    private let sources: [EmployeeDataSource]

    init(dataSources: EmployeeDataSource...) {
        self.sources = dataSources
    }

    var employees: [Employee] {
        var results = [Employee]()
        for source in sources {
            results += source.employees
        }
        return results
    }

    func search(text: String, type: SearchType) -> [Employee] {
        var results = [Employee]()
        for source in sources {
            results += type == SearchType.NAME
                ? source.searchByName(name: text) : source.searchByTitle(title: text)
        }
        return results
    }
}

let search = SearchTool(dataSources: SalesDataSource(), DevelopmentDataSource())
print("--List--")
for e in search.employees {
    print("Name \(e.name)")
}

print("--Search--")
for e in search.search(text: "VP", type: SearchTool.SearchType.TITLE) {
    print("Name \(e.name) Title \(e.title)")
}

// 以下のような全く違うデータソースが入ってくると、実際に問題が起きる。
// 下記のクラスと互換性を確保するために、クラスの内容を変更するという手段がありますが、
// 現実問題として、変更をすることが常に可能であることは珍しい。
// Adapterはこういった変更が出来ない複数のデータを統合して扱うことに長けている。

class NewCoStaffMember {
    private var name: String
    private var role: String

    init(name: String, role: String) {
        self.name = name
        self.role = role
    }

    func getName() -> String {
        return self.name
    }

    func getJob() -> String {
        return self.role
    }
}

class NewCoDirectory {
    private var staff: [String: NewCoStaffMember]

    init() {
        self.staff = [
            "Hans": NewCoStaffMember(name: "Hans", role: "Corp Counsel"),
            "Greta": NewCoStaffMember(name: "Greta", role: "VP Legal")
        ]
    }

    func getStaff() -> [String: NewCoStaffMember] {
        return self.staff
    }
}

