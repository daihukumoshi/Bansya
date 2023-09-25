//
//  PhotoViewController.swift
//  Bansya
//
//  Created by 三木　杏夏 on 2023/09/25.
//

import UIKit
import RealmSwift

class PhotoViewController: UIViewController {
    let realm = try! Realm()
    
    @IBOutlet var imageView: UIImageView!
    var selectedPhoto: DayPhoto? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedPhoto = selectedPhoto {
            let fileURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(selectedPhoto.fileName)
            if let cellImage = UIImage(contentsOfFile: fileURL.path) {
                imageView.image = cellImage
            } else {
                print("あ")
                // 画像を読み込めなかった場合の処理
                // 例えばデフォルト画像を表示するなど
            }
        } else {
            print("い")
            // selectedPhoroがnilの場合の処理
            // 例えばエラーメッセージを表示するなど
        }
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


