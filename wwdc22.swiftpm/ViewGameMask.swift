import SwiftUI
import UIKit
import SceneKit

public struct ViewGameMaskControllerRepresentable: UIViewControllerRepresentable{
    public func makeUIViewController(context: Context) -> ViewGameMaskController {
        return ViewGameMaskController()
    }
    
    public func updateUIViewController(_ uiViewController: ViewGameMaskController, context: Context) {
        
    }
}

public class ViewGameMaskController: UIViewController{
    var scene: SCNScene!
    var sceneView: SCNView = SCNView()
    var humans: [MaskHuman] = []
    var humanTemplate: SCNNode!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        initHumans()
        startTimer()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    func setup(){
        sceneView.frame = CGRect(origin: .zero, size: view.frame.size)
        scene = SCNScene(named: "GameMaskScene.scn")
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        view.addSubview(sceneView)
    }
    func initHumans(){
        let humanTemplate: SCNNode = scene.rootNode.childNode(withName: "human", recursively: true)!
        humanTemplate.isHidden = true
        
        let nHuman: Int = 20
        for _ in 1...nHuman{
            let humanClone = humanTemplate.clone()
            humanClone.isHidden = false
            let spawnTime = Int.random(in: 1..<20) * 30
            let isOnLeftSide = Int.random(in: 0...10) <= 5
            let maskHuman = MaskHuman(humanNode: humanClone, timeBeforeSpawn: spawnTime, isOnLeftSide: isOnLeftSide)
            
            maskHuman.setPosition(x: Float(Int.random(in: 0...5)) - 2.5, y: -100, z: Float(isOnLeftSide ? -8 : 8))
            if !isOnLeftSide{
                maskHuman.rotate180deg()
            }
            
            humans.append(maskHuman)
            scene.rootNode.addChildNode(humanClone)
        }
    }
    func getHumanDestination(maskHuman: MaskHuman) -> Float{
        if maskHuman.isOnLeftSide {
            if maskHuman.isWearMask{
                return 8
            }else{
                return 6
            }
        }else{
            if maskHuman.isWearMask{
                return -8
            }else{
                return -6
            }
        }
    }
    func startTimer(){
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: onTimerTick)
    }
    
    // EVENT
    func onTimerTick(timer: Timer){
        for human in humans{
            if human.isSpawned {
                if human.isReachDestination(){
                    if human.isWearMask{
                        human.despawn()
                        humans = humans.filter{ $0.humanNode != human.humanNode }
                        if humans.count <= 0 {
                            timer.invalidate()
                            endingMaskGameEvent.send()
                        }
                    }else{
                        human.rotate180deg()
                        human.isOnLeftSide = !human.isOnLeftSide
                        human.setDestination(zDestination: getHumanDestination(maskHuman: human))
                    }
                }else{
                    human.walk()
                }
            }else{
                if human.isReadyToSpawn {
                    human.spawn()
                    human.setDestination(zDestination: getHumanDestination(maskHuman: human))
                }
                human.reduceSpawnTime()
            }
            
        }
    }
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        let location: CGPoint = sender.location(in: sceneView)
        let hits = self.sceneView.hitTest(location, options: nil)
        if hits.count > 0{
            let tappedNode = hits.first!.node
            let humanNode = getHumanNode(childNode: tappedNode)
            if humanNode != nil{
                humanWearMask(humanNode: humanNode!)
            }
        }
    }
    func getHumanNode(childNode: SCNNode) -> SCNNode? {
        if childNode.name == "human" {
            return childNode
        }else if childNode.parent != nil {
            return getHumanNode(childNode: childNode.parent!)
        }else {
            return nil
        }
    }
    func humanWearMask(humanNode: SCNNode){
        let maskHuman = humans.first{ $0.humanNode == humanNode }!
        maskHuman.wearMask()
    }
    func checkIsGameOver(){
        if humans.count > 0 { return }
        
    }
}
        
public struct ViewGameMask: View{
    @State var isGameEnd: Bool = false
    
    public var body: some View{
        ZStack{
            ViewGameMaskControllerRepresentable()
            VStack{
                Spacer()
                    .frame(height: 100)
                Text("ACT I: Mask")
                    .font(.title)
                    .bold()
                Text("Goal: give everyone a mask by clicking them")
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
                    Text("You successfully give everyone a mask")
                        .foregroundColor(.black)
                        .font(.title)
                    Spacer()
                        .frame(height: 100)
                    Button(action: {
                        changeSceneEvent.send(.Dialogue(activeDialogue: .GamePhysicalDistance))
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
            .onReceive(endingMaskGameEvent){
                isGameEnd = true
            }
    }
}
