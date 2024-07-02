//
//  ViewController.swift
//  FMDBSchool
//
//  Created by Arshad Shaik on 08/12/23.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  // MARK: - Actions -
  @IBAction func addTapped(_ sender: UIButton) {
//    DatabaseManager.shared.createSchoolTable()
//    DatabaseManager.shared.createDepartmentTable()
//    DatabaseManager.shared.createStudentTable()
    print(" data saved ", DatabaseManager.shared.saveData())
    DatabaseManager.shared.addDepartmentsWithForeignKey()
    DatabaseManager.shared.addStudentsForDepartment()
  }
  
  @IBAction func fetchTapped(_ sender: UIButton) {
//    print("Department details are ", DatabaseManager.shared.getDepartments())
    print("joined data is ", DatabaseManager.shared.joinSchoolDepartmentStudentData())
  }
  
  @IBAction func updateTapped(_ sender: UIButton) {
//    DatabaseManager.shared.updateStudentName(studentId: 1, newName: "Parth Nenava")
//    DatabaseManager.shared.addAgeColumnToStudentTable()
  }
  
  @IBAction func deleteTapped(_ sender: UIButton) {
//    DatabaseManager.shared.deleteDepartmentData(departmentId: 2)
//    DatabaseManager.shared.deleteDataFromTable()
  }
  
}

