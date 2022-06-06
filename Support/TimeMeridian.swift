

public enum TimeMeridian {

    case am
    case pm
}

extension TimeMeridian: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .am: return "AM"
        case .pm: return "PM"
        }
    }
}
