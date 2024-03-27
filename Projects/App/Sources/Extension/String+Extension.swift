//
//  String+Extension.swift
//  gambler
//
//  Created by 박성훈 on 3/24/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import Foundation

extension String {
    /// 입력이 한글, 영어, 숫자로로 2~20글자로 이루어져 있는지를 판별하는 함수
    /// - Parameter input: 텍스트 필드의 텍스트
    /// - Returns: 부합하면 true 아니면 false
    func isValidInput(minLength: Int, maxLength: Int) -> Bool {
        let pattern = "^[가-힣a-zA-Z0-9]+$"  // 정규식 패턴(한글/영어/숫자)
        
        if self.count >= minLength && self.count <= maxLength {
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)  // 대소문자 구분하지 않고 탐색
                let nsInput = self as NSString
                let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsInput.length))
                
                return !matches.isEmpty  // matches.count > 0
            } catch {
                print("Regex Error: \(error.localizedDescription)")
                return false
            }
        } else {
            return false
        }
    }
}
