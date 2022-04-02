//
//  OnboardingView.swift
//  beraber
//
//  Created by yozdemir on 25.03.2022.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var skipOnboarding: Bool
    var screenSize: CGSize
    @State var offset: CGFloat = 0
    
    var body: some View {
        VStack {
            Button {
                
            } label: {
                    Text("BERABER")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.bold)

                    
//                Image("blue_logo")
//                    .resizable()
//                    .frame(width: 30, height: 30)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            OffsetPageTabView(offset: $offset) {
                HStack (alignment: .center, spacing: 0) {
                    ForEach(pages){ page in
                        VStack (alignment: .center){
                            Image(page.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: screenSize.height / 3)
                            VStack(alignment: .leading, spacing: 20) {
                                Text(page.title)
                                    .font(.largeTitle.bold())
                                
                                Text(page.description)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                
                            }
                            .foregroundStyle(.white)
                            .padding(.top, 30)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        .padding()
                        .frame(width: screenSize.width)
                    }
                }
            }
            HStack(alignment: .bottom) {
                
                //Indicators
                HStack(spacing: 12) {
                    ForEach(pages.indices, id: \.self) { index in
                        Capsule()
                            .fill(.white)
                            .frame(width: getIndex() == index ? 20 : 7, height: 7)
                    }
                }
                .overlay(
                    Capsule()
                        .fill(.white)
                        .frame(width:20, height: 7)
                        .offset(x:getIndicatorOffset())
                    ,alignment: .leading
                )
                    .offset(x: 10, y:-15)
                
                Spacer()
                
                Button {
                    let oldIndex = offset / screenSize.width
                    print("++",oldIndex)
                    if Int(oldIndex) == pages.count-1 {
                        let defaults = UserDefaults.standard
                        self.skipOnboarding.toggle()
                        defaults.set(true, forKey: "isPassedOnboarding")
                    } else {
                        let index = min(getIndex()+1, pages.count - 1)
                        offset = CGFloat(index) * screenSize.width
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding(20)
                        .background(
                            pages[getIndex()].color,
                            in: Circle()
                        )
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        //index değiştiğindeki animasyon
        .animation(.easeInOut, value: getIndex())
    }
    
    func getIndicatorOffset() -> CGFloat{
        let progress = offset / screenSize.width
        //12 = spacing
        //7 = Circle Size
        
        let maxWidth: CGFloat = 12 + 7
        return progress*maxWidth
    }
    
    func getIndex()->Int{
        var progress = round(offset / screenSize.width)
        //return Int(progress)
        //Güvenli şekilde index döndürmek
        if progress < 0 {
            progress = 0
        }
        let index = min(Int(progress), pages.count-1)
        return index
    }
}
