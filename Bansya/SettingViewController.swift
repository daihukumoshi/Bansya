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
    @IBOutlet var roundedView: UIView!
    var pickerView = UIPickerView()
    var data = ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
    var selectedSubject: Subject!
    var selectedColor: String = "green"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        roundedView.layer.cornerRadius = 18
        roundedView.layer.masksToBounds = true
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
                targetItem.color = selectedColor
            }
        }else{
            //新規
            if titleTextField.text != "", dayTextField.text != "", timeTextField.text != ""{
                let newSubject = Subject()
                newSubject.title = titleTextField.text ?? ""
                newSubject.day = dayTextField.text ?? ""
                newSubject.time = timeTextField.text ?? ""
                newSubject.color = selectedColor
                
                try! self.realm.write{
                    realm.add(newSubject)
                }
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
    
    @IBAction func yellow(){
        roundedView.backgroundColor = UIColor(red: 250/255, green: 244/255, blue: 199/255, alpha: 1.0)
        selectedColor = "yellow"
    }
    @IBAction func red(){
        roundedView.backgroundColor = UIColor(red: 243/255, green: 187/255, blue: 194/255, alpha: 1.0)
        selectedColor = "red"
    }
    @IBAction func pink(){
        roundedView.backgroundColor = UIColor(red: 252/255, green: 241/255, blue: 242/255, alpha: 1.0)
        selectedColor = "pink"
    }
    @IBAction func blue(){
        roundedView.backgroundColor = UIColor(red: 186/255, green: 220/255, blue: 241/255, alpha: 1.0)
        selectedColor = "blue"
    }
    @IBAction func green(){
        roundedView.backgroundColor = UIColor(red: 198/255, green: 224/255, blue: 229/255, alpha: 1.0)
        selectedColor = "green"
    }
    @IBAction func purple(){
        roundedView.backgroundColor = UIColor(red: 213/255, green: 209/255, blue: 232/255, alpha: 1.0)
        selectedColor = "purple"
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
