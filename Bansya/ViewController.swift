//
//  ViewController.swift
//  Bansya
//
//  Created by 三木　杏夏 on 2023/09/18.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    let realm = try! Realm()
    var Subjects: [Subject] = []
    var selectedSubject: Subject? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        Subjects = readSubject()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SubjectTableViewCell", bundle: nil), forCellReuseIdentifier: "SubjectCell")
        tableView.rowHeight = 80
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        tableView.addGestureRecognizer(longTap)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Subjects = readSubject()
        tableView.reloadData()
    }
    
    func readSubject() -> [Subject]{
        return Array(realm.objects(Subject.self))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Subjects.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SubjectTableViewCell
        let subject: Subject = Subjects[indexPath.row]
        cell.setCell(title: subject.title, day: (subject.day + subject.time))
        return cell
    }
    @objc func longTap(sender: UILongPressGestureRecognizer){
        guard sender.state == .began else { return }
        //長押しされたCellのindexPathを取得
        let touchPoint = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint){
            let alert = UIAlertController(title: Subjects[indexPath.row].title, message: "操作を以下から選択してください", preferredStyle: .alert)
            let delete = UIAlertAction(title: "削除", style: .destructive, handler: { (action) -> Void in
                //削除押された時の処理。配列から削除&TableViewリロード！！！
                let targetItem = self.realm.objects(Subject.self).where({$0.id == self.Subjects[indexPath.row].id}).first!
                try! self.realm.write{
                    self.realm.delete(targetItem)
                }
                self.Subjects = self.readSubject()
                self.tableView.reloadData()
            })
            let edit = UIAlertAction(title: "編集", style: .default, handler: { (action) -> Void in
                //編集押された時の処理。画面遷移〜〜〜
                self.selectedSubject = self.Subjects[indexPath.row]
                self.performSegue(withIdentifier: "toSetting", sender: nil)
            })
            
            let cancel = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
                //キャンセル
                
            })
            
            alert.addAction(delete)
            alert.addAction(edit)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //セルタップ時画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedSubject = Subjects[indexPath.row]
        self.performSegue(withIdentifier: "toLecture", sender: nil)
    }
    //科目名の受け渡し
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLecture"{
            let LectureViewController = segue.destination as! LectureViewController
            LectureViewController.selectedSubject = self.selectedSubject
        }
        if segue.identifier == "toSetting"{
            //編集の時は値引き渡し
            if selectedSubject != nil {
                let SettingViewController = segue.destination as! SettingViewController
                SettingViewController.selectedSubject = self.selectedSubject
            }
        }
    }
    
    

}

