//
//  CSLogButton.swift
//  MyMemo
//
//  Created by MoNireu on 2019/11/26.
//  Copyright © 2019 monireu. All rights reserved.
//

import UIKit
public enum CSLogType: Int {
    case basic  // 기본 로그 타입
    case title  // 버튼의 타이틀을 출력
    case tag    // 버튼의 태그값을 출력
}

public class CSLogButton: UIButton {
    public var logType: CSLogType = .basic
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setBackgroundImage(UIImage(named: "button-bg.png"), for: .normal)
        self.tintColor = .white
        
        self.addTarget(self, action: #selector(logging(_:)), for: .touchUpInside)
    }
    
    @objc func logging(_ sender: UIButton) {
        switch self.logType {
        case .basic:
            NSLog("버튼이 클릭되었습니다.")
        case .title:
            let btnTitle = sender.titleLabel?.text ?? "타이틀 없는"
            NSLog("\(btnTitle) 버튼이 클릭되었습니다.")
        case .tag:
            NSLog("\(sender.tag) 버튼이 클릭되었습니다.")
        }
    }
    
}


