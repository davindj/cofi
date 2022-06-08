import Combine

let changeSceneEvent = PassthroughSubject<ActiveView, Never>()
let endingMaskGameEvent = PassthroughSubject<Void, Never>()
let endingPhysicalDistanceGameEvent = PassthroughSubject<Void, Never>()
let endingHygieneGameEvent = PassthroughSubject<Void, Never>()
