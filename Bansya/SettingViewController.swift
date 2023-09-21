//
//  SettingViewController.swift
//  Bansya
//
//  Created by 三木　杏夏 on 2023/09/18.
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let realm = try! Realm()
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dayTextField: UITextField!
    @IBOutlet var timeTextField: UITextField!
    var pickerView = UIPickerView()
    var data = ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
    var selectedSubject: Subject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        //編集の場合初期値入れる
        if selectedSubject != nil{
            titleTextField.text = selectedSubject?.title
            dayTextField.text = selectedSubject?.day
            timeTextField.text = selectedSubject?.time
        }
        
        
        // Do any additional setup after loading the view.
    }
    //画面戻ったら保存
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //編集
        if selectedSubject != nil{
            let targetItem = realm.objects(Subject.self).where({$0.id == selectedSubject.id}).first!
            try! self.realm.write{
                targetItem.title = titleTextField.text ?? ""
                targetItem.day = dayTextField.text ?? ""
                targetItem.time = timeTextField.text ?? ""
            }
        }else{
            //新規
            let newSubject = Subject()
            newSubject.title = titleTextField.text ?? ""
            newSubject.day = dayTextField.text ?? ""
            newSubject.time = timeTextField.text ?? ""
            
            try! self.realm.write{
                realm.add(newSubject)
            }
        }
    }
    
    //Pickerの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //Pickerの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    //Picker表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    //結果をtextfieldに表示
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dayTextField.text = data[row]
    }
    //textfield押されたらpicker出てくる
    func createPickerView(){
        pickerView.delegate = self
        dayTextField.inputView = pickerView
    }
    //picker外押されたら引っ込む
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dayTextField.endEditing(true)
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
