//
//  RealmManager.swift
//  FindImages
//
//  Created by admin on 07/05/22.
//

import Foundation
import RealmSwift

class RealmManager {
    // MARK: - Variables
    private var realm: Realm?
    static let shared = RealmManager()

    // MARK: - Initialization
    private init() {
        do {
            realm = try Realm()
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
    
    func clearAll() {
        do {
            try realm?.write {
              realm?.deleteAll()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    // MARK: - Save & Get Position list
    func savePhotoList(terms: String, results: [Photos],lastPage: Int) {
        do {
            try realm?.write {
                let jsonString = results.toJSONString()
                let availableDates = RealmPotosList()
                availableDates.primary = "\(terms)"
                availableDates.details = jsonString
                availableDates.lastPage = lastPage
                realm?.add(availableDates, update: Realm.UpdatePolicy.all)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func getPhotoList(terms: String) -> [Photos] {
        return [Photos](JSONString: (realm?.objects(RealmPotosList.self).filter("primary like '\(terms)'").first?.details ?? "")) ?? []
    }
    
    func getLastPage(terms: String) -> Int {
        return realm?.objects(RealmPotosList.self).filter("primary like '\(terms)'").first?.lastPage ?? 0
    }
}

class RealmPotosList: Object {
    
    // MARK: - Variables
    @objc dynamic var primary: String? = ""
    @objc dynamic var details: String? = ""
    @objc dynamic var lastPage: Int = 0

    override static func primaryKey() -> String? {
        return "primary"
    }

    enum CodingKeys: String, CodingKey {
        case primary
        case details
    }
}
