import SwiftUI
import UIKit
import SceneKit

public struct ViewGamePhysicalDistanceControllerRepresentable: UIViewControllerRepresentable{
    public func makeUIViewController(context: Context) -> ViewGamePhysicalDistanceController {
        return ViewGamePhysicalDistanceController()
    }
    
    public func updateUIViewController(_ uiViewController: ViewGamePhysicalDistanceController, context: Context) {
        
    }
}

public class ViewGamePhysicalDistanceController: UIViewController{
    var scene: SCNScene!
    var sceneView: SCNView = SCNView()
    var seats: [PhysicalDistanceSeat] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        initSeats()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    func setup(){
        sceneView.frame = CGRect(origin: .zero, size: view.frame.size)
        scene = SCNScene(named: "GamePhysicalDistance.scn")
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = UIColor.blue
        view.addSubview(sceneView)
    }
    func initSeats(){
        let nRow = 4
        let nCol = 5
        
        let seatTemplate: SCNNode = scene.rootNode.childNode(withName: "seat", recursively: true)!
        seatTemplate.isHidden = true
        
        for row in 0..<nRow{
            for col in 0..<nCol{
                let seatClone = seatTemplate.clone()
                seatClone.isHidden = false
                let isAvailable = (row*nCol + col) % 2 == 0
                let position = SCNVector3(x: Float(row*5+2), y: 0, z: Float(col*4-8))
                let seat = PhysicalDistanceSeat(seatNode: seatClone, isCross: false, isSupposedToBeCrossed: !isAvailable, position: position)
                
                seat.showCrossSign()
                
                scene.rootNode.addChildNode(seatClone)
                seats.append(seat)
            }
        }
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        let location: CGPoint = sender.location(in: sceneView)
        let hits = self.sceneView.hitTest(location, options: nil)
        
        for hit in hits{
            let tappedNode = hit.node
            let seatNode = getSeatNode(node: tappedNode)
            if let valSeatNode = seatNode {
                let pdSeatNode = getSeatBasedOnSeatNode(seatNode: valSeatNode)
                if pdSeatNode.isCross {
                    pdSeatNode.hideCrossSign()
                }else{
                    pdSeatNode.showCrossSign()
                }
                break
            }
        }
        
        checkIsGameOver()
    }
    func getSeatNode(node: SCNNode) -> SCNNode? {
        if node.name == "seat" {
            return node
        }else if node.parent != nil {
            return getSeatNode(node: node.parent!)
        }else {
            return nil
        }
    }
    func getSeatBasedOnSeatNode(seatNode: SCNNode) -> PhysicalDistanceSeat{
        seats.first{ $0.seatNode == seatNode }!
    }
    func checkIsGameOver(){
        if seats.allSatisfy({ $0.isProperCrossed }) {
            endingPhysicalDistanceGameEvent.send()
        }
    }
}
        
public struct ViewGamePhysicalDistance: View{
    @State var isGameEnd: Bool = false
    
    public var body: some View{
        ZStack{
            ViewGamePhysicalDistanceControllerRepresentable()
            VStack{
                Spacer()
                    .frame(height: 100)
                Text("ACT II: Physical Distance")
                    .font(.title)
                    .bold()
                Text("Goal: make seat unavailable like checkerboard pattern starting with front left available")
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
                    Text("You successfully give everyone a safe seat")
                        .foregroundColor(.black)
                        .font(.title)
                    Spacer()
                        .frame(height: 100)
                    Button(action: {
                        changeSceneEvent.send(.Dialogue(activeDialogue: .GameHygiene))
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
            .onReceive(endingPhysicalDistanceGameEvent){
                isGameEnd = true
            }
    }
}
