import SwiftUI
import SceneKit

public struct ViewDialogue: View{
    var dialogueType: DialogueType
    var dialogues: [Dialogue] = []
    
    @State var currDialogueIdx: Int = -1 {
        didSet{
            currImageString = currDialogue.imageName
            currTextDialogueIdx = 0
        }
    }
    @State var currImageString: String = ""
    @State var currTextDialogueIdx: Int = -1{
        didSet{
            currTextLength = 0
        }
    }
    @State var currText: String = ""
    @State var currTextLength: Int = -1 {
        didSet{
            let substring = currDialogue.texts[currTextDialogueIdx].prefix(currTextLength)
            currText = String(substring)
        }
    }
    @State var isTimerActive: Bool = false {
        didSet{
            if !isTimerActive{
                timer.upstream.connect().cancel()
            }
        }
    }
    @State var isShowingDialogue: Bool = false
    
    let timer = Timer.publish(every: 0.08, on: .main, in: .common).autoconnect()
    
    
    var currDialogue: Dialogue {
        print(currDialogueIdx)
        return dialogues[currDialogueIdx]
    }
    var currFullText: String{
        currDialogue.texts[currTextDialogueIdx]
    }
    
    
    public var body: some View{
        GeometryReader{ geometry in
            ZStack{
                if isShowingDialogue {
                    Image(currImageString)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geometry.size.width,
                               height: geometry.size.height,
                               alignment: .center)
                        .clipped()
                }
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Text(isShowingDialogue ? currText : "")
                            .padding(40)
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
        .onAppear{appearHandler()}
        .onReceive(timer, perform: onTimerTick)
        .onTapGesture { onUserTapDialogue() }
    }

    
    init(dialogueType: DialogueType){
        self.dialogueType = dialogueType
        self.dialogues = getDialoguesBasedOnType(dialogueType: dialogueType)
//        self.currDialogueIdx = -1
//        self.currImageString = ""
//        self.currTextDialogueIdx = -1
//        self.currText = ""
//        self.currTextLength = -1
//        self.isTimerActive = false
//        self.isShowingDialogue = false
    }
    
    func getDialoguesBasedOnType(dialogueType: DialogueType) -> [Dialogue]{
        switch dialogueType {
        case .Intro:
            return introDialogues
        case .GameMask:
            return gameMaskDialogues
        case .GamePhysicalDistance:
            return gamePhysicalDistanceDialogues
        case .GameHygiene:
            return gameHygieneDialogues
        case .Ending:
            return endingDialogues
        }
    }
    
    // Event
    func appearHandler(){
        print("appear")
        tryChangeDialogue()
        print("dialog mask sudah coba diganti")
        isShowingDialogue = true
        print("show dialogue")
        isTimerActive = true
        print("active timer")
    }
    func onTimerTick(currTime: Date){
        if !isTimerActive { return }
        
        // Increment Text if Possible
        print("")
        if currTextLength < currFullText.count{
            currTextLength += 1
        }
    }
    func onUserTapDialogue(){
        print("bro masuk")
        print(dialogueType)
        if !isShowingDialogue { return }
        if currTextLength < currFullText.count {
            currTextLength = currFullText.count
        } else {
            tryChangeText()
        }
    }
    
    // Main Action
    func tryChangeDialogue(){
        if currDialogueIdx < dialogues.count-1{
            nextDialogue()
        }else{
            changeScene()
        }
    }
    func nextDialogue(){
        currDialogueIdx += 1
    }
    func tryChangeText(){
        if currTextDialogueIdx < currDialogue.texts.count - 1 {
            nextText()
        }else{
            tryChangeDialogue()
        }
    }
    func nextText(){
        currTextDialogueIdx += 1
    }
    func changeScene(){
        isTimerActive = false
        isShowingDialogue = false
        
        switch dialogueType {
        case .Intro:
            print("ganti dialog jadi dialog game mas")
            changeSceneEvent.send(.Dialogue(activeDialogue: .GameMask))
        case .GameMask:
            print("ganti dialog game mask")
            changeSceneEvent.send(.Game(activeGame: .Mask))
        case .GamePhysicalDistance:
            print("ganti dialog game physical distance")
            changeSceneEvent.send(.Game(activeGame: .PhysicalDistance))
        case .GameHygiene:
            print("ganti dialog game hygiene")
            changeSceneEvent.send(.Game(activeGame: .Hygiene))
        case .Ending:
            print("ganti dialog jadi dialog ending")
            changeSceneEvent.send(.MainMenu)
        }
    }
}

struct ViewDialogueIntro_Previews: PreviewProvider {
    static var previews: some View {
        ViewDialogue(dialogueType: .Intro)
    }
}
