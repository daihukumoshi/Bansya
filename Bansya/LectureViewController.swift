//
//  LectureViewController.swift
//  Bansya
//
//  Created by 三木　杏夏 on 2023/09/18.
//

import UIKit
import RealmSwift

class LectureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet var tableView: UITableView!
    let realm = try! Realm()
    var Lectures: [Lecture] = []
    var datePicker: UIDatePicker = UIDatePicker()
    var selectedSubject: Subject? = nil
    var selectedLecture: Lecture? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        Lectures = readLecture()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LectureTableViewCell", bundle: nil), forCellReuseIdentifier: "LectureCell")
        tableView.rowHeight = 200
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        tableView.addGestureRecognizer(longTap)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Lectures = readLecture()
        tableView.reloadData()
    }
    
    func readLecture() -> [Lecture]{
        return Array(realm.objects(Lecture.self))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Lectures.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LectureCell", for: indexPath) as! LectureTableViewCell
        let lecture: Lecture = Lectures[indexPath.row]
        cell.setCell(day: lecture.day)
        return cell
    }
    
    @objc func longTap(sender: UILongPressGestureRecognizer){
        guard sender.state == .began else { return }
        
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        datePicker.preferredDatePickerStyle = .wheels
        //長押しされたCellのindexPathを取得
        let touchPoint = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint){
            let alert = UIAlertController(title: Lectures[indexPath.row].day, message: "操作を以下から選択してください\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            let delete = UIAlertAction(title: "講義を削除", style: .destructive, handler: { (action) -> Void in
                //削除押された時の処理。DBから削除
                
                let targetItem = self.realm.objects(Lecture.self).where({$0.id == self.Lectures[indexPath.row].id}).first!
                try! self.realm.write{
                    self.realm.delete(targetItem)
                }
                
                self.Lectures = self.readLecture()
                self.tableView.reloadData()
            })
            let edit = UIAlertAction(title: "変更を保存", style: .default, handler: { [self] (action) -> Void in
                //編集押された時の処理。DB更新&画面遷移〜〜〜
                let formatter = DateFormatter()
                formatter.dateFormat = "MM月dd日"
                
                let targetItem = self.realm.objects(Lecture.self).where({$0.id == self.Lectures[indexPath.row].id}).first!
                try! self.realm.write{
                    targetItem.day = formatter.string(from: self.datePicker.date)
                }
                
                self.Lectures = self.readLecture()
                self.tableView.reloadData()
            })
            let cancel = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
                //キャンセル
                
            })
            
            datePicker.frame = CGRect(x: 0, y: 50, width: 270, height: 162)
            alert.view.addSubview(datePicker)
            
            alert.addAction(delete)
            alert.addAction(edit)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func add(){
        
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        datePicker.preferredDatePickerStyle = .wheels
        
        let alert = UIAlertController(title: "講義を追加", message: "講義日時を選んでください\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let new = UIAlertAction(title: "新規作成", style: .default, handler: { [self] (action) -> Void in
            //編集押された時の処理。DB更新&画面遷移〜〜〜
            let formatter = DateFormatter()
            formatter.dateFormat = "MM月dd日"
            
            let newLecture = Lecture()
            newLecture.day = formatter.string(from: self.datePicker.date)
            
            try! self.realm.write{
                realm.add(newLecture)
            }
            
            Lectures = readLecture()
            tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            //キャンセル
            
        })
        
        // Auto LayoutでDatePickerに制約を追加
//        datePicker.translatesAutoresizingMaskIntoConstraints = false
//        datePicker.heightAnchor.constraint(equalToConstant: 130).isActive = true
//        datePicker.widthAnchor.constraint(equalToConstant: 270).isActive = true
//
//        if let container = alert.view.subviews.first?.subviews.first {
//            container.translatesAutoresizingMaskIntoConstraints = false
//            container.heightAnchor.constraint(equalToConstant: 400).isActive = true // ここで高さを調整
//        }
        
        datePicker.frame = CGRect(x: 0, y: 50, width: 270, height: 162)
        alert.view.addSubview(datePicker)
        alert.addAction(new)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    //セルタップ時画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedLecture = Lectures[indexPath.row]
        self.performSegue(withIdentifier: "toDay", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDay"{
            let DayViewController = segue.destination as! DayViewController
            DayViewController.selectedLecture = self.selectedLecture
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

    }
    */

}
