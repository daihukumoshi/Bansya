//
//  DayViewController.swift
//  Bansya
//
//  Created by 三木　杏夏 on 2023/09/21.
//

import UIKit
import RealmSwift
import Photos
import PhotosUI


class DayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PHPickerViewControllerDelegate{
    
    let realm = try! Realm()
    @IBOutlet var collectionView: UICollectionView!
    
    var Lectures: [Lecture] = []
    var photoExist: Bool = false
    var selectedLectureName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Lectures = readLecture()
        
    }
    
    func readLecture() -> [Lecture]{
        return Array(realm.objects(Lecture.self).where({$0.day == selectedLectureName ?? ""}))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoExist == true{
            return Lectures.count
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        
        if photoExist == true{
            
            //let cellImage = UIImage((named: Lectures[indexPath.row].fileName))
            //URL型にキャスト
            let fileURL = URL(string: Lectures[indexPath.row].fileName)
            //パス型に変換
            let filePath = fileURL?.path
            let cellImage = UIImage(contentsOfFile: filePath!)
            imageView.image = cellImage
        }else{
            let defaultImage = UIImage(named: "default.jpg")
            imageView.image = defaultImage
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 横方向のスペース調整
        let horizontalSpace:CGFloat = 1
        let cellSize:CGFloat = self.view.bounds.width/2 - horizontalSpace
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize)
    }
    
    @IBAction func add(){
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    //選択終了時
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                if let image = object as? UIImage {
                    
                    // ドキュメントディレクトリの「ファイルURL」（URL型）定義
                    var documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    // ドキュメントディレクトリの「パス」（String型）定義
                    let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                    
                    // 作成するテキストファイルの名前
                    let filename = "\(NSUUID().uuidString).png"
                    // DocumentディレクトリのfileURLを取得
                    if documentDirectoryFileURL != nil {
                        // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
                        let path = documentDirectoryFileURL.appendingPathComponent(filename)
                        documentDirectoryFileURL = path
                    }
                    
                    let pngImageData = image.pngData()
                    do {
                        try pngImageData!.write(to: documentDirectoryFileURL)
                    } catch {
                        //エラー処理
                        print("エラー")
                    }
                    
                    let newLecture = Lecture()
                    newLecture.day = self.selectedLectureName ?? ""
                    newLecture.fileName = filename
                    try! self.realm.write {
                        self.realm.add(newLecture)
                    }
                    
                    self.Lectures = self.readLecture()
                    self.collectionView.reloadData()
                    
                }
            })
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
