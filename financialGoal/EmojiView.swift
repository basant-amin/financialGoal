//
//  EmojiView.swift
//  financialGoal
//
//  Created by Maha Salem Alghmadi on 04/04/1446 AH.
//

import SwiftUI

struct EmojiView: View {
    @Binding var show: Bool
    @Binding var selectedEmoji: String
    
    let columns = [GridItem(.adaptive(minimum: 40))]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(getSupportedEmojiList(), id: \.self) { row in
                        ForEach(row, id: \.self) { emojiScalar in
                            if let scalar = UnicodeScalar(emojiScalar) {
                                Button(action: {
                                    self.selectedEmoji = String(scalar)
                                    self.show = false
                                }) {
                                    Text(String(scalar)).font(.system(size: 40))
                                }
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
            .padding(.bottom, getSafeAreaBottomInset())
            .background(Color.white)
            .cornerRadius(25)
            
            Button(action: {
                self.show.toggle()
            }) {
                Image(systemName: "xmark").foregroundColor(.black)
            }.padding()
        }
        .opacity(show ? 1 : 0)
        .animation(nil, value: show)
    }
    
    func getSafeAreaBottomInset() -> CGFloat {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        
        return window?.safeAreaInsets.bottom ?? 0
    }
    
    func getEmojiList() -> [[Int]] {
        var emojis: [[Int]] = []
        for i in stride(from: 0x1F600, to: 0x1F64F, by: 1) { emojis.append([i]) }
        for i in stride(from: 0x1F300, to: 0x1F5FF, by: 1) { emojis.append([i]) }
        return emojis
    }
    
    func getSupportedEmojiList() -> [[Int]] {
        return getEmojiList().compactMap { row in
            let filteredRow = row.filter { scalar in
                if let unicodeScalar = UnicodeScalar(scalar) {
                    return unicodeScalar.properties.isEmoji
                }
                return false
            }
            return filteredRow.isEmpty ? nil : filteredRow
        }
    }
}

#Preview {
    EmojiView(show: .constant(true), selectedEmoji: .constant("😀"))
}
