//
//  CheckBox.swift
//  EisuKey
//
//  Created by 大橋航生 on 2021/05/30.
//

import SwiftUI

struct CheckBox: View {
    // 切り替える状態（初期値はfalse）
    @Binding var isChecked: Bool
    let action: (_ isChecked: Bool) -> Void
    // チェックボックスの表示
    var body: some View {
        Button(action: toggle) {
            if(isChecked) {
                Image(systemName: "checkmark.square.fill")
            .foregroundColor(.green)
            } else {
                Image(systemName: "square")
            }
        }
    }
    
    // タップ時の状態の切り替え
    func toggle() -> Void {
        isChecked = !isChecked
        action(isChecked)
    }
}
