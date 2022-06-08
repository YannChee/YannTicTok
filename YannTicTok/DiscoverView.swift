//
//  DiscoverView.swift
//  YannTicTok
//
//  Created by YannChee on 2022/6/8.
//

import SwiftUI

struct DiscoverView: View {
    var body: some View {
        //自定义显示的内容
        List(0 ..< 2) { item in
            Text("hello")
                .font(.title)
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DiscoverView()
            DiscoverView()
        }
    }
}
