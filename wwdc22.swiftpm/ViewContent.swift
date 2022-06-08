import SwiftUI
import UIKit

public struct ViewContent: View {
    @State var activeView: ActiveView = .MainMenu
    
    public var body: some View {
        ZStack{
            switch activeView {
            case .MainMenu:
                ViewMainMenu()
            case .Dialogue(activeDialogue: .Intro):
                ViewDialogue(dialogueType: .Intro)
            case .Dialogue(activeDialogue: .GameMask):
                ViewDialogue(dialogueType: .GameMask)
            case .Dialogue(activeDialogue: .GamePhysicalDistance):
                ViewDialogue(dialogueType: .GamePhysicalDistance)
            case .Dialogue(activeDialogue: .GameHygiene):
                ViewDialogue(dialogueType: .GameHygiene)
            case .Dialogue(activeDialogue: .Ending):
                ViewDialogue(dialogueType: .Ending)
            case .Game(activeGame: .Mask):
                ViewGameMask()
            case .Game(activeGame: .PhysicalDistance):
                ViewGamePhysicalDistance()
            case .Game(activeGame: .Hygiene):
                ViewGameHygiene()
            case .About:
                Text("View About...")
            case .Credit:
                Text("View Credit...")
            }
        }
        .onReceive(changeSceneEvent){ newActiveView in
            activeView = newActiveView
        }
        .statusBar(hidden: true)
    }
}

