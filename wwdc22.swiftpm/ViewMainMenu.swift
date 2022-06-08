import SwiftUI
import SceneKit

public struct ViewMainMenu: View{
    public var body: some View{
        GeometryReader{ geometry in
            ZStack{
                Image("titleScreen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geometry.size.width,
                           height: geometry.size.height,
                           alignment: .center)
                    .clipped()
                VStack{
                    Spacer()
                    Button(action: {
                        changeSceneEvent.send(.Dialogue(activeDialogue: .Intro))
                    }) {
                        Text("Play Game")
                            .font(Font.custom("MyFont", size: 50))
                            .foregroundColor(.black)
                            .bold()
                    }
                    Spacer()
                        .frame(height: 200)
                }
            }
            
        }
        .ignoresSafeArea()
    }
}

struct ViewMainMenu_Previews: PreviewProvider {
    static var previews: some View {
        ViewMainMenu()
    }
}
