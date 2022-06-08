import SceneKit

public class PhysicalDistanceSeat{
    var seatNode: SCNNode
    var isCross: Bool = false
    var isSupposedToBeCrossed: Bool
    
    var isProperCrossed: Bool{
        if isSupposedToBeCrossed{
            return isCross
        }else{
            return !isCross
        }
    }
    
    public init(seatNode: SCNNode, isCross: Bool, isSupposedToBeCrossed: Bool, position: SCNVector3){
        self.seatNode = seatNode
        self.isCross = isCross
        self.isSupposedToBeCrossed = isSupposedToBeCrossed
        self.seatNode.position = position
    }
    
    public func hideCrossSign(){
        let crossSign = seatNode.childNode(withName: "crossSign", recursively: true)!
        crossSign.isHidden = true
        isCross = false
    }
    
    public func showCrossSign(){
        let crossSign = seatNode.childNode(withName: "crossSign", recursively: true)!
        crossSign.isHidden = false
        isCross = true
    }
}
