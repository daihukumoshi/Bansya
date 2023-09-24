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
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    let realm = try! Realm()
    var dayPhotos: [DayPhoto] = []
    var photoExist: Bool = false
    var selectedLecture: Lecture? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dayPhotos = readPhoto()
        
    }
    
    func readPhoto() -> [DayPhoto]{
        return Array(realm.objects(DayPhoto.self).where({$0.Lecture == selectedLecture!}))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if photoExist == true{
//            return Lectures.count
//        }else{
//            return 0
//        }
        return dayPhotos.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        
        if dayPhotos.count != 0{
            print("dayPhotos count: \(dayPhotos.count ?? 0)")
            print("fileName: \(dayPhotos[indexPath.row].fileName)")
            
            //let cellImage = UIImage((named: Lectures[indexPath.row].fileName))
            //URL型にキャスト
            //let fileURL = URL(string: dayPhotos[indexPath.row].fileName)
            let fileURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(dayPhotos[indexPath.row].fileName)
            //パス型に変換
            //let filePath = fileURL?.path
            let cellImage = UIImage(contentsOfFile: fileURL.path)
            //let cellImage = UIImage(contentsOfFile: filePath!)
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
//        // 横方向のスペース調整
//        let horizontalSpace:CGFloat = 1
//        let cellSize:CGFloat = self.view.bounds.width/2 - horizontalSpace
//        // 正方形で返すためにwidth,heightを同じにする
//        return CGSize(width: cellSize, height: cellSize)
        
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = (collectionViewWidth - 1) / 2 // 2列にしたい場合、セル間に1ポイントのスペースを入れます
        return CGSize(width: cellWidth, height: cellWidth)
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
                    DispatchQueue.main.async {
                        let newPhoto = DayPhoto()
                        newPhoto.Lecture = self.selectedLecture!
                        newPhoto.fileName = filename
                        try! self.realm.write {
                            self.realm.add(newPhoto)
                        }
                        self.dayPhotos = self.readPhoto()
                        self.collectionView.reloadData()
                    }
                }
            })
        }
        
    }
}
