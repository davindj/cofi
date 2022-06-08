import SwiftUI
import SceneKit

public struct VD: View{
    public var body: some View{
        GeometryReader{ geometry in
            ZStack{
                Image("wallpaper1")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geometry.size.width,
                           height: geometry.size.height,
                           alignment: .center)
                    .clipped()
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Text("")
                            .padding()
                            .font(.system(size: 40))
                            .frame(width: geometry.size.width - 80,
                                   height: 300,
                                   alignment: .topLeading)
                            .background(Color(hex: 0xFBE7C6, alpha: 0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        Color(hex: 0x990909),
                                        style: StrokeStyle(lineWidth: 10, dash: [30, 10]))
                            )
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 24)
                }
            }
            
        }
        .ignoresSafeArea()
        
//        GeometryReader { geometry in
//            ZStack{
//                Image("wallpaper1")
//                    .resizable()
//                    .scaledToFill()
//                    .edgesIgnoringSafeArea(.all)
//                VStack{
////                    Spacer()
////                    Text("dialogahsdahsdaskjdasd")
////                        .foregroundColor(.white)
////                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
////                        .background(.blue)
//                    Text("Hello, SwiftUI!")
//                        .font(.headline)
//                        .border(Color.pink)
//                        // 1
////                        .frame(maxWidth: .infinity, alignment: .leading)
//
//                        .border(Color.blue)
//                }
//            }
//
//            // .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
////            .clipped()
//        }
        
    }
}

struct VD_Previews: PreviewProvider {
    static var previews: some View {
        VD()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
