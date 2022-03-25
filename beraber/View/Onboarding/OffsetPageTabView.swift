//
//  OffsetPageTabView.swift
//  beraber
//
//  Created by yozdemir on 25.03.2022.
//

import SwiftUI

struct OffsetPageTabView<Content: View>: UIViewRepresentable {
    var content : Content
    @Binding var offset: CGFloat
    
    init(offset: Binding<CGFloat>, @ViewBuilder content: @escaping ()->Content) {
        self.content = content()
        self._offset = offset
    }
    
    func makeCoordinator() -> Coordinator {
        return OffsetPageTabView.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        
        //extracting swiftUI vieew and embedding into UIKit scrollView
        let hostView = UIHostingController(rootView: content)
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            hostView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            //Eğer dikey paging kullanırsan alttaki satırı kaldır!
            hostView.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ]
        
        scrollView.addSubview(hostView.view)
        scrollView.addConstraints(constraints)
        
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        // Delegate'i ayarlama
        scrollView.delegate = context.coordinator
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        let currentOffset = uiView.contentOffset.x
//        print("----",offset)
//        print("++++", currentOffset)

        if currentOffset != offset {
            uiView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate{
        var parent: OffsetPageTabView
        
        init(parent: OffsetPageTabView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            
            parent.offset = offset
        }
    }
    
    
}

