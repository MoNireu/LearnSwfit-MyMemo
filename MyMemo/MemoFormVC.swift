//
//  MemoFormVC.swift
//  MyMemo
//
//  Created by MoNireu on 19/09/2019.
//  Copyright © 2019 monireu. All rights reserved.
//

import UIKit

class MemoFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    var subject: String!

    @IBOutlet var contents: UITextView!
    @IBOutlet var preview: UIImageView!
    @IBOutlet var doneSaveButton: UIBarButtonItem!
    @IBOutlet var pickerButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contents.delegate = self
        
        let bgImage = UIImage(named: "memo-background.png")!
        self.view.backgroundColor = UIColor(patternImage: bgImage)
        
        self.contents.layer.borderWidth = 0
        self.contents.layer.borderColor = UIColor.clear.cgColor
        self.contents.backgroundColor = UIColor.clear
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 9
        self.contents.attributedText = NSAttributedString(string: " ", attributes: [NSAttributedString.Key.paragraphStyle : style])
        self.contents.text = ""
        

    }
    
    // MARK: - Save contents
    @IBAction func doneAndSave(_ sender: Any) {
        self.contents.resignFirstResponder()
        
        if doneSaveButton.title == "저장" {
            // 내용을 입력하지 않은 경우, 경고한다.
            guard self.contents.text.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            // MemoData 객체를 생성하고, 데이터를 담는다.
            let data = MemoData()

            data.title    = self.subject
            data.contents = self.contents.text
            data.regdate  = Date()
            data.image    = self.preview.image

            // 앱 델리게이트 객체를 읽어온 다음, memolist 배열에 MemoData객체를 추가한다.
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memolist.append(data)
        
            self.navigationController?.popViewController(animated: true)
        }
        
        doneSaveButton.title = "저장"
    }

    
    
    // MARK: - Image editing
    // 이미지 선택시 호출되는 메소드
    @IBAction func pick(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: "이미지를 가져올 곳을 선택해주세요", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "카메라", style: .default) {(_) in
            self.source(.camera)
        }
        let album = UIAlertAction(title: "저장앨범", style: .default) {(_) in
            self.source(.savedPhotosAlbum)
        }
        let photoLibrary = UIAlertAction(title: "사진 라이브러리", style: .default) {(_) in
            self.source(.photoLibrary)
        }
        actionSheet.addAction(camera)
        actionSheet.addAction(album)
        actionSheet.addAction(photoLibrary)
        
        self.present(actionSheet, animated: true)
    }
    
    
    // 이미지 선택을 완료했을 떄 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 선택된 이미지를 미리보기에 표시한다.
        self.preview.image        = info[.editedImage] as? UIImage

        //이미지 피커 컨트롤러를 닫는다.
        picker.dismiss(animated: true)
    }
    
    // 소스타입 설정 커스텀 메소드
    func source(_ sourceType: UIImagePickerController.SourceType) -> Void {
        let picker = UIImagePickerController()
        picker.delegate      = self
        picker.allowsEditing = true
        picker.sourceType = sourceType

        self.present(picker, animated: true)
    }

    
    
    // MARK: - TextViewDelegateMethods
    // 텍스트 입력시 "저장"버튼을 "완료"버튼으로 변경 및 활성화. "이미지 피커"버튼 비활성화.
    func textViewDidBeginEditing(_ textView: UITextView) {
        doneSaveButton.title = "완료"
        pickerButton.isEnabled = false
        doneSaveButton.isEnabled = true
    }
    
    // 텍스트 입력 완료시 "이미지 피커"버튼 활성화.
    func textViewDidEndEditing(_ textView: UITextView) {
        pickerButton.isEnabled = true
    }
 
    
    // MARK: - Edit Title
    // 내용에 따라 제목 설정
    func textViewDidChange(_ textView: UITextView) {
        // 내용의 최대 15자리까지 읽어 subject 변수에 저장한다.
        let contents = textView.text as NSString
        let length   = ((contents.length > 15) ? 15 : contents.length)
        self.subject = contents.substring(with: NSRange(location: 0, length: length))

        // 내비게이션 타이틀에 표시한다.
        self.navigationItem.title = subject
    }
    
    

}
