//
//  ViewController.swift
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var studentTextField: UITextField!
    @IBOutlet weak var sexSegument: UISegmentedControl!
    @IBOutlet weak var teacherTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    
    //管理オブジェクトコンテキスト
    var context:NSManagedObjectContext!
    
    //最初からあるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()

        //部活動用と生徒用の管理オブジェクトコンテキストを取得する。
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = applicationDelegate.managedObjectContext

        //デリゲート先を自分に設定する。
        studentTextField.delegate = self
        teacherTextField.delegate = self
        subjectTextField.delegate = self
        
        //外部ファイルの出力先ディレクトリを表示する。
        print(NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first!)

    }


    //Returnキー押下時の呼び出しメソッド
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //キーボードをしまう。
        studentTextField.endEditing(true)
        teacherTextField.endEditing(true)
        subjectTextField.endEditing(true)
        
        return true
    }
    

    //生徒登録ボタン押下時の呼び出しメソッド
    @IBAction func pushStudentBtn(sender: UIButton) {
        do {
            //生徒オブジェクトをフェッチする。
            let fetchRequest = NSFetchRequest(entityName: "Student")
            fetchRequest.predicate = NSPredicate(format:"name = %@", studentTextField.text!)
            let studentList = try context.executeFetchRequest(fetchRequest) as! [Student]
            
            let student:Student
            if(studentList.count == 0) {
                //フェッチできなかった場合は生徒用の管理オブジェクトコンテキストに新規追加する。
                student = NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: context) as! Student
            } else {
                //フェッチできた場合はそのオブジェクトを編集する。
                student = studentList[0]
            }
            
            //生徒オブジェクトの属性値を変更する。
            student.name = studentTextField.text!
            student.sex = sexSegument.selectedSegmentIndex
            
            //データを保存する。
            try context.save()
            
            //テキストフィールドを空にする。
            studentTextField.text = ""
            
        } catch {
            print(error)
        }
    }



    //教師登録ボタン押下時の呼び出しメソッド
    @IBAction func pushTeacherBtn(sender: UIButton) {
        do {
            //教師オブジェクトをフェッチする。
            let fetchRequest = NSFetchRequest(entityName: "Teacher")
            fetchRequest.predicate = NSPredicate(format:"name = %@", teacherTextField.text!)
            let teacherList = try context.executeFetchRequest(fetchRequest) as! [Teacher]
            
            let teacher:Teacher
            if(teacherList.count == 0) {
                //フェッチできなかった場合は生徒用の管理オブジェクトコンテキストに新規追加する。
                teacher = NSEntityDescription.insertNewObjectForEntityForName("Teacher", inManagedObjectContext: context) as! Teacher
            } else {
                //フェッチできた場合はそのオブジェクトを編集する。
                teacher = teacherList[0]
            }
            
            //生徒オブジェクトの属性値を変更する。
            teacher.name = teacherTextField.text!
            teacher.subject = subjectTextField.text!
            
            //データを保存する。
            try context.save()
            
            //テキストフィールドを空にする。
            teacherTextField.text = ""
            subjectTextField.text = ""
            
        } catch {
            print(error)
        }
    }
}

