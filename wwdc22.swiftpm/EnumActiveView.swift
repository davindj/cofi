public enum ActiveView{
    case MainMenu
    case Dialogue(activeDialogue: DialogueType)
    case Game(activeGame: GameType)
    case About
    case Credit
}
