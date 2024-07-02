//
//  Util.swift
//  FMDBSchool
//
//  Created by Arshad Shaik on 08/12/23.
//

import Foundation

class Util {
  
  static let shared = Util()
  
  func getPath(fileName: String) -> String {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let fileUrl = documentDirectory?.appending(path: fileName)
    print("database path is ", fileUrl?.path() as Any)
    return fileUrl?.path() ?? ""
  }
  
  func copyDatabase(fileName: String) {
    let dbPath = getPath(fileName: Database.dbName.rawValue)
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: dbPath),
       let bundle = Bundle.main.resourceURL {
      let file = bundle.appending(path: fileName)
      do {
        try fileManager.copyItem(atPath: file.path(), toPath: dbPath)
        print("database copied successfully")
      } catch let error {
        print("error in copying path ", error)
      }
    }
  }
}

enum Database: String {
  case dbName = "School.db"
}
