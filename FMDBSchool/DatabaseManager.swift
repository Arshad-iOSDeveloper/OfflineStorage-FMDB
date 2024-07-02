//
//  DatabaseManager.swift
//  FMDBSchool
//
//  Created by Arshad Shaik on 08/12/23.
//

import Foundation
import FMDB

class DatabaseManager: NSObject {
  
  static let shared = DatabaseManager()
  var database: FMDatabase?
  
  override init() {
    database = FMDatabase(path: Util.shared.getPath(fileName: Database.dbName.rawValue))
  }
  
  func createSchoolTable() {
    /// Ensure the database is initialised
    guard let db = database else {
      print("Database not initialised.")
      return
    }
    /// Open the database connection
    db.open()
    /// SQL query to create the 'school' table
    let createTableQuery = "CREATE TABLE IF NOT EXISTS school (schoolId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, schoolName TEXT)"
    do {
      /// Execute the query to create the table
      try db.executeUpdate(createTableQuery, values: nil)
      print("table created successfully")
    } catch {
      /// Handle any errors that occur during table creation
      print("Error creating table: \(error.localizedDescription)")
    }
    /// Close the database connection
    db.close()
  }
  
  func createDepartmentTable() {
    guard let db = database else {
      print("Database not initialised.")
      return
    }
    db.open()
    let createTableQuery = """
                CREATE TABLE IF NOT EXISTS department (
                    departmentId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                    departmentName TEXT,
                    schoolId INTEGER,
                    FOREIGN KEY (schoolId) REFERENCES school(schoolId)
                )
            """
    do {
      try db.executeUpdate(createTableQuery, values: nil)
      print("table created successfully")
    } catch {
      print("Error creating table: \(error.localizedDescription)")
    }
    db.close()
  }
  
  func createStudentTable() {
    guard let db = database else {
      print("Database not initialized.")
      return
    }
    db.open()
    let createTableQuery = """
                CREATE TABLE IF NOT EXISTS student (
                    studentId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                    studentName TEXT,
                    departmentId INTEGER,
                    FOREIGN KEY (departmentId) REFERENCES department(departmentId)
                )
            """
    do {
      try db.executeUpdate(createTableQuery, values: nil)
      print("table created successfully")
    } catch {
      print("Error creating table: \(error.localizedDescription)")
    }
    db.close()
  }
  
  func saveData() -> Bool {
    database?.open()
    let insertQuery = "INSERT INTO school(schoolName) VALUES(?)"
    let isSave = database?.executeUpdate(insertQuery, withArgumentsIn: ["LiveHealth"]) ?? false
    database?.close()
    return isSave
  }
  
  func addDepartmentsWithForeignKey() {
    guard let db = database else {
      print("Database not initialised.")
      return
    }
    db.open()
    let departmentData = [
      ("Marketing", 2),
      ("Hr", 2)
    ]
    for (departmentName, schoolId) in departmentData {
      do {
        try db.executeUpdate("INSERT INTO department (departmentName, schoolId) VALUES (?, ?)", values: [departmentName, schoolId])
        print("Department '\(departmentName)' added with schoolId \(schoolId) successfully.")
      } catch {
        fatalError("Error adding department to the department table: \(error.localizedDescription)")
      }
    }
    db.close()
  }
  
  func addStudentsForDepartment() {
    guard let db = database else {
      print("Database not initialised.")
      return
    }
    db.open()
    let studentData = [
      ("Vikas", 4)
    ]
    for (studentName, departmentId) in studentData {
      do {
        try db.executeUpdate("INSERT INTO student (studentName, departmentId) VALUES (?, ?)", values: [studentName, departmentId])
        print("student '\(studentName)' added with departmentId \(departmentId) successfully.")
      } catch {
        fatalError("Error adding student to the student table: \(error.localizedDescription)")
      }
    }
    db.close()
  }
  
  // MARK: - Get Data -
  /// Retrieves data from the 'department' table.
  func getDepartments() -> [[String: Any]] {
    // Ensure the database is initialised
    guard let db = database else {
      print("Database not initialised.")
      return []
    }
    
    // Open the database connection
    db.open()
    
    var departments: [[String: Any]] = []
    
    do {
      // SQL query to select all rows from the 'department' table
      let query = "SELECT * FROM department"
      let resultSet = try db.executeQuery(query, values: nil)
      
      // Iterate through the result set and store data in an array of dictionaries
      while resultSet.next() {
        var department: [String: Any] = [:]
        department["departmentId"] = resultSet.long(forColumn: "departmentId")
        department["departmentName"] = resultSet.string(forColumn: "departmentName")
        department["schoolId"] = resultSet.long(forColumn: "schoolId")
        
        departments.append(department)
      }
      
      print("Departments retrieved successfully.")
    } catch {
      // Handle any errors that occur during data retrieval
      print("Error retrieving data from the 'department' table: \(error.localizedDescription)")
    }
    
    // Close the database connection
    db.close()
    
    return departments
  }
  
  // MARK: - Update Data -
  /// Updates the name of a student in the 'student' table.
  func updateStudentName(studentId: Int, newName: String) {
    // Ensure the database is initialised
    guard let db = database else {
      print("Database not initialised.")
      return
    }
    
    // Open the database connection
    db.open()
    
    do {
      // SQL query to update the name of a student based on studentId
      let updateQuery = "UPDATE student SET studentName = ? WHERE studentId = ?"
      try db.executeUpdate(updateQuery, values: [newName, studentId])
      
      print("Student name updated successfully.")
    } catch {
      // Handle any errors that occur during the update
      print("Error updating student name in the 'student' table: \(error.localizedDescription)")
    }
    
    // Close the database connection
    db.close()
  }
  
  // MARK: - Delete -
  func deleteDepartmentData(departmentId: Int) {
    guard let db = database else {
      print("Database not initialised.")
      return
    }
    db.open()
    let deleteQuery = "DELETE FROM department WHERE departmentId = ?"
    do {
      try db.executeUpdate(deleteQuery, values: [departmentId])
      print("table row deleted successfully")
    } catch {
      print("Error creating table: \(error.localizedDescription)")
    }
    database?.close()
  }
  
  // MARK: - Drop -
  func deleteDataFromTable() {
    guard let db = database else {
      print("Database not initialised.")
      return
    }
    db.open()
    let query = "DELETE FROM student"
    do {
      try db.executeUpdate(query, values: nil)
      print("table row deleted successfully")
    } catch {
      print("Error creating table: \(error.localizedDescription)")
    }
    database?.close()
  }
  
  // MARK: - ALTER -
  /// Adds the 'age' column to the 'student' table.
  func addAgeColumnToStudentTable() {
    // Ensure the database is initialised
    guard let db = database else {
      print("Database not initialised.")
      return
    }
    
    // Open the database connection
    db.open()
    
    do {
      // SQL query to add the 'age' column to the 'student' table
      let alterTableQuery = "ALTER TABLE student ADD COLUMN age INTEGER"
      try db.executeUpdate(alterTableQuery, values: nil)
      
      print("Column 'age' added to the 'student' table successfully.")
    } catch {
      // Handle any errors that occur during the alteration
      print("Error adding 'age' column to the 'student' table: \(error.localizedDescription)")
    }
    
    // Close the database connection
    db.close()
  }
  
  // MARK: - JOIN -
  /// Performs a simple join operation between 'school', 'department', and 'student' tables.
  func joinSchoolDepartmentStudentData() -> [[String: Any]] {
    // Ensure the database is initialised
    guard let db = database else {
      print("Database not initialised.")
      return []
    }
    
    // Open the database connection
    db.open()
    
    var resultData: [[String: Any]] = []
    
    do {
      // SQL query to perform a join operation
      let query = """
                  SELECT
                      school.schoolId,
                      school.schoolName,
                      department.departmentId,
                      department.departmentName,
                      student.studentId,
                      student.studentName,
                      student.age
                  FROM
                      school
                  INNER JOIN
                      department ON school.schoolId = department.schoolId
                  INNER JOIN
                      student ON department.departmentId = student.departmentId
              """
      
      let resultSet = try db.executeQuery(query, values: nil)
      
      // Iterate through the result set and store data in an array of dictionaries
      while resultSet.next() {
        var rowData: [String: Any] = [:]
        rowData["schoolId"] = resultSet.long(forColumn: "schoolId")
        rowData["schoolName"] = resultSet.string(forColumn: "schoolName")
        rowData["departmentId"] = resultSet.long(forColumn: "departmentId")
        rowData["departmentName"] = resultSet.string(forColumn: "departmentName")
        rowData["studentId"] = resultSet.long(forColumn: "studentId")
        rowData["studentName"] = resultSet.string(forColumn: "studentName")
        rowData["age"] = resultSet.long(forColumn: "age")
        
        resultData.append(rowData)
      }
      
      print("Join operation completed successfully.")
    } catch {
      // Handle any errors that occur during the join operation
      print("Error performing join operation: \(error.localizedDescription)")
    }
    
    // Close the database connection
    db.close()
    
    return resultData
  }
}
