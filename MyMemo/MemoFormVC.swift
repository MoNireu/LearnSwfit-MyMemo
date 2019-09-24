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

    // 이미지 선택시 호출되는 메소드
    @IBAction func pick(_ sender: Any) {
        let picker = UIImagePickerController()

        picker.delegate      = self
        picker.allowsEditing = true

        self.present(picker, animated: true)
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contents.delegate = self

    }
    
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
 
    // 내용에 따라 제목 설정
    func textViewDidChange(_ textView: UITextView) {
        // 내용의 최대 15자리까지 읽어 subject 변수에 저장한다.
        let contents = textView.text as NSString
        let length   = ((contents.length > 15) ? 15 : contents.length)
        self.subject = contents.substring(with: NSRange(location: 0, length: length))

        // 내비게이션 타이틀에 표시한다.
        self.navigationItem.title = subject
    }
    
    // 이미지 선택을 완료했을 떄 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 선택된 이미지를 미리보기에 표시한다.
        self.preview.image        = info[.editedImage] as? UIImage

        //이미지 피커 컨트롤러를 닫는다.
        picker.dismiss(animated: true)
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

