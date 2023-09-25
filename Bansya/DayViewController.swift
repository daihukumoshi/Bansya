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
    var selectedPhoto: DayPhoto? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dayPhotos = readPhoto()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets.zero
        collectionView.delegate = self
        
       
       
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        self.collectionView.addGestureRecognizer(longTap)
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
        imageView.contentMode = .scaleAspectFill
        
        if dayPhotos.count != 0{
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
        
//        let collectionViewWidth = collectionView.bounds.width
//        let cellWidth = (collectionViewWidth - 1) / 2 // 2列にしたい場合、セル間に1ポイントのスペースを入れます
//        return CGSize(width: cellWidth, height: cellWidth)
        
//        let collectionViewWidth = collectionView.bounds.width
//            let spacing: CGFloat = 10 // セル間の余白を設定
//            let numberOfColumns: CGFloat = 2 // 2列にしたい場合
//
//            // セルの幅を計算
//            let cellWidth = (collectionViewWidth - spacing * (numberOfColumns + 1)) / numberOfColumns
//
//            return CGSize(width: cellWidth, height: cellWidth) // 正方形のセルを返す
        let cellSize:CGFloat = (self.view.bounds.width-32)/2.1 - 4
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
    
    @objc func longTap(sender: UILongPressGestureRecognizer) {
        let point: CGPoint = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        if let indexPath = collectionView.indexPathForItem(at: point){
            let alert = UIAlertController(title: "写真を削除", message: "本当に写真を削除しますか？_", preferredStyle: .alert)
            let delete = UIAlertAction(title: "削除", style: .destructive, handler: { (action) -> Void in
                let targetItem =  self.realm.objects(DayPhoto.self).where({$0.fileName == self.dayPhotos[indexPath.row].fileName}).first!
                try! self.realm.write{
                    self.realm.delete(targetItem)
                }
                
                self.dayPhotos = self.readPhoto()
                self.collectionView.reloadData()
            })
            
            let cancel = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
                //キャンセル
                
            })
            
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhoto = dayPhotos[indexPath.row]
        self.performSegue(withIdentifier: "toPhoto", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoto" {
            if let photoViewController = segue.destination as? PhotoViewController {
                photoViewController.selectedPhoto = selectedPhoto // selectedPhotoを設定
            }
        }
    }
}
