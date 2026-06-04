import Foundation

enum ManifestationVisibility: String, CaseIterable, Identifiable {
    case everyone = "Everyone"
    case closeCircle = "Close Circle"
    case privateOnly = "Private"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .everyone:
            return "Visible in the wider feed"
        case .closeCircle:
            return "Shared with trusted friends"
        case .privateOnly:
            return "Only you can see it"
        }
    }
}

struct ManifestationComment: Identifiable, Hashable {
    let id: UUID
    var authorName: String
    var message: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        authorName: String,
        message: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.authorName = authorName
        self.message = message
        self.createdAt = createdAt
    }
}

struct Wish: Identifiable, Hashable {
    enum Status: String, CaseIterable {
        case planted = "Planted"
        case rippling = "Rippling"
        case blooming = "Blooming"
    }

    let id: UUID
    var title: String
    var intention: String
    var status: Status
    var createdAt: Date
    var visibility: ManifestationVisibility
    var authorName: String
    var authorHandle: String
    var isMine: Bool
    var prompt: String?
    var comments: [ManifestationComment]

    init(
        id: UUID = UUID(),
        title: String,
        intention: String,
        status: Status,
        createdAt: Date = .now,
        visibility: ManifestationVisibility = .privateOnly,
        authorName: String = "Malik",
        authorHandle: String = "@mywell",
        isMine: Bool = true,
        prompt: String? = nil,
        comments: [ManifestationComment] = []
    ) {
        self.id = id
        self.title = title
        self.intention = intention
        self.status = status
        self.createdAt = createdAt
        self.visibility = visibility
        self.authorName = authorName
        self.authorHandle = authorHandle
        self.isMine = isMine
        self.prompt = prompt
        self.comments = comments
    }
}

extension Wish {
    static let samples: [Wish] = [
        Wish(
            title: "Build the first version",
            intention: "Shape a calm, useful app that makes wish tracking feel intentional.",
            status: .rippling,
            visibility: .privateOnly,
            prompt: "I will..."
        ),
        Wish(
            title: "Make space for focus",
            intention: "Protect three quiet blocks this week for creative work.",
            status: .planted,
            visibility: .closeCircle,
            prompt: "I want..."
        ),
        Wish(
            title: "Celebrate small proof",
            intention: "Notice the tiny signs that something is moving.",
            status: .blooming,
            visibility: .everyone,
            prompt: "Next month, I'm going to..."
        )
    ]

    static let friendSamples: [Wish] = [
        Wish(
            title: "A gentler launch week",
            intention: "I will ship the first version with clarity, rest, and enough room to enjoy the moment.",
            status: .rippling,
            visibility: .everyone,
            authorName: "Maya",
            authorHandle: "@moonwell",
            isMine: false,
            prompt: "I will...",
            comments: [
                ManifestationComment(authorName: "Ari", message: "This feels so grounded. Cheering for the calm launch.")
            ]
        ),
        Wish(
            title: "Creative mornings",
            intention: "Next month, I'm going to begin three mornings a week with writing before I open my messages.",
            status: .planted,
            visibility: .closeCircle,
            authorName: "Kai",
            authorHandle: "@softlaunch",
            isMine: false,
            prompt: "Next month, I'm going to..."
        ),
        Wish(
            title: "Trust the next step",
            intention: "I want to move with patience and recognize progress before it becomes obvious.",
            status: .blooming,
            visibility: .everyone,
            authorName: "Noor",
            authorHandle: "@brightpath",
            isMine: false,
            prompt: "I want..."
        )
    ]
}
