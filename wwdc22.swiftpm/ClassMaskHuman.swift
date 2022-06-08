import SceneKit

public class MaskHuman{
    var humanNode: SCNNode
    var isWearMask: Bool = false
    var isOnLeftSide: Bool
    var timeBeforeSpawn: Int
    var currArmAngle: Float = 0
    var currArmIncrement: Float = -0.1
    var zDestination: Float = 0
    var moveIncrement: Float = 0
    var isMoving: Bool = false
    var isReadyToSpawn: Bool {
        timeBeforeSpawn <= 0
    }
    var isSpawned: Bool = false
    
    init(humanNode: SCNNode, timeBeforeSpawn: Int, isOnLeftSide: Bool){
        self.humanNode = humanNode
        self.timeBeforeSpawn = timeBeforeSpawn
        self.isOnLeftSide = isOnLeftSide
    }
    
    public func reduceSpawnTime(){
        timeBeforeSpawn -= 1
    }
    
    public func spawn(){
        isSpawned = true
        humanNode.position.y = 0
        doWalkAnimation()
    }
    
    public func despawn(){
        humanNode.removeFromParentNode()
    }
    
    public func setPosition(x: Float, y: Float, z: Float){
        humanNode.position.x = x
        humanNode.position.y = y
        humanNode.position.z = z
    }
    
    public func rotate180deg(){
        humanNode.eulerAngles.y += Float(Double.pi)
    }
    
    public func walk(){
        humanNode.position.z += moveIncrement
        doWalkAnimation()
    }
    
    public func doWalkAnimation(){
        let leftArm = humanNode.childNode(withName: "leftArm", recursively: true)!
        let rightArm = humanNode.childNode(withName: "rightArm", recursively: true)!
        let leftLeg = humanNode.childNode(withName: "leftLeg", recursively: true)!
        let rightLeg = humanNode.childNode(withName: "rightLeg", recursively: true)!
        
        leftArm.eulerAngles.x = currArmAngle
        rightArm.eulerAngles.x = -currArmAngle
        
        leftLeg.eulerAngles.x = -currArmAngle
        rightLeg.eulerAngles.x = currArmAngle
        
        currArmAngle += currArmIncrement
        if currArmAngle > 0.45 || currArmAngle < -0.45 {
            currArmIncrement *= -1
        }
//
//        print(leftArm)
//        print(rightArm)
//
//        leftArm.addAnimation(spin, forKey: "spin around")
//        rightArm.addAnimation(spin, forKey: "spin around")
        
//        let spin = CABasicAnimation(keyPath: "rotation")
//        // Use from-to to explicitly make a full rotation around z
//        spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 0, z: 0, w: 0))
//        spin.toValue = NSValue(scnVector4: SCNVector4(x: 360, y: 0, z: 0, w: 0))
//        spin.duration = 3
//        spin.repeatCount = .infinity
//        leftArm.addAnimation(spin, forKey: "spin around")
//        rightArm.addAnimation(spin, forKey: "spin around")
    }
    
    public func setDestination(zDestination: Float){
        isMoving = true
        self.zDestination = zDestination
        self.moveIncrement = zDestination < humanNode.position.z ? -0.1 : 0.1
    }
    
    public func isReachDestination() -> Bool{
        if isDestinationBelowPosition(){
            return humanNode.position.z <= zDestination
        }else{
            return humanNode.position.z >= zDestination
        }
    }
    
    public func isDestinationBelowPosition() -> Bool{
        moveIncrement < 0
    }
    
    public func wearMask(){
        isWearMask = true
        let nodeMask = humanNode.childNode(withName: "mask", recursively: true)!
        nodeMask.isHidden = false
    }
}
