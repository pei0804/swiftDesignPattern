//------------------
// Adapter
//------------------

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

// 拡張したくない場合は、ラッパークラスとして定義する
// このラッパークラスは、2の内容でやったことと同じです。
class NewCoDirectoryAdapter: EmployeeDataSource {
    private let directory: NewCoDirectory

    init() {
        directory = NewCoDirectory()
    }

    var employees: [Employee] {
        return directory.getStaff().values.map {sv -> Employee in
            return Employee(name: sv.getName(), title: sv.getJob())
        }
    }

    func searchByName(name: String) -> [Employee] {
        return createEmployees(filteer: {(sv: NewCoStaffMember) -> Bool in
            return sv.getName().range(of: name) != nil
        })
    }

    func searchByTitle(title: String) -> [Employee] {
        return createEmployees(filteer: {(sv: NewCoStaffMember) -> Bool in
            return sv.getJob().range(of: title) != nil
        })
    }

    private func createEmployees(filteer filterClosure: ((NewCoStaffMember) -> Bool)) -> [Employee] {
        return (directory.getStaff().values.filter(filterClosure).map
            {entry -> Employee in
                return Employee(name: entry.getName(), title: entry.getJob())
        })
    }

}

let search = SearchTool(dataSources: SalesDataSource(), DevelopmentDataSource(), NewCoDirectoryAdapter())
print("--List--")
for e in search.employees {
    print("Name \(e.name)")
}
print("--Search--")
for e in search.search(text: "VP", type: SearchTool.SearchType.TITLE) {
    print("Name \(e.name) Title \(e.title)")
}