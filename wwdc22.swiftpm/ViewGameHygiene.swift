import SwiftUI
import UIKit
import SceneKit

public struct ViewGameHygieneControllerRepresentable: UIViewControllerRepresentable{
    public func makeUIViewController(context: Context) -> ViewGameHygieneController {
        return ViewGameHygieneController()
    }
    
    public func updateUIViewController(_ uiViewController: ViewGameHygieneController, context: Context) {
        
    }
}

public class ViewGameHygieneController: UIViewController{
    var scene: SCNScene!
    var sceneView: SCNView = SCNView()
    var seats: [PhysicalDistanceSeat] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    func setup(){
        sceneView.frame = CGRect(origin: .zero, size: view.frame.size)
        scene = SCNScene(named: "GameHygiene.scn")
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = UIColor.blue
        view.addSubview(sceneView)
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        let sink = scene.rootNode.childNode(withName: "sink", recursively: true)
        sink?.isHidden = false
        endingHygieneGameEvent.send()
    }
}
        
public struct ViewGameHygiene: View{
    @State var isGameEnd: Bool = false
    
    public var body: some View{
        ZStack{
            ViewGameHygieneControllerRepresentable()
            VStack{
                Spacer()
                    .frame(height: 100)
                Text("ACT III: Hygiene")
                    .font(.title)
                    .bold()
                Text("Goal: make facility that helps people stay hygiene")
                    .font(.title2)
                Spacer()
            }
            if isGameEnd{
                Color(hex: 0xffffff, alpha: 0.8)
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    Text("Congratulations!!!")
                        .font(.system(size: 120))
                        .foregroundColor(.black)
                        .bold()
                    Text("You successfully make people more hygiene")
                        .foregroundColor(.black)
                        .font(.title)
                    Spacer()
                        .frame(height: 100)
                    Button(action: {
                        changeSceneEvent.send(.Dialogue(activeDialogue: .Ending))
                    }){
                        Text("Continue Story")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
            }
        }
            .ignoresSafeArea()
            .onReceive(endingHygieneGameEvent){
                isGameEnd = true
            }
    }
}
