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

enum ManifestationFeedbackType: String, Codable, CaseIterable, Identifiable {
    case advice = "Advice"
    case emotionalSupport = "Emotional Support"
    case discourse = "Discourse"

    var id: String { rawValue }

    /// Compact label for tight spots like the selector pill.
    var shortName: String {
        switch self {
        case .advice:
            return "Advice"
        case .emotionalSupport:
            return "Emotional"
        case .discourse:
            return "Discourse"
        }
    }

    var description: String {
        switch self {
        case .advice:
            return "Help me think through next steps."
        case .emotionalSupport:
            return "Encourage me and affirm this intention."
        case .discourse:
            return "Explore this with me more deeply."
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
    var feedbackType: ManifestationFeedbackType
    var comments: [ManifestationComment]
    var affirmationCount: Int
    var isAffirmed: Bool

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
        feedbackType: ManifestationFeedbackType = .emotionalSupport,
        comments: [ManifestationComment] = [],
        affirmationCount: Int = 0,
        isAffirmed: Bool = false
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
        self.feedbackType = feedbackType
        self.comments = comments
        self.affirmationCount = affirmationCount
        self.isAffirmed = isAffirmed
    }
}

extension Wish {
    static let samples: [Wish] = [
        Wish(
            title: "Build the first version",
            intention: "Shape a calm, useful app that makes wish tracking feel intentional.",
            status: .rippling,
            visibility: .privateOnly,
            feedbackType: .advice
        ),
        Wish(
            title: "Make space for focus",
            intention: "Protect three quiet blocks this week for creative work.",
            status: .planted,
            visibility: .closeCircle,
            feedbackType: .emotionalSupport
        ),
        Wish(
            title: "Celebrate small proof",
            intention: "Notice the tiny signs that something is moving.",
            status: .blooming,
            visibility: .everyone,
            feedbackType: .discourse
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
            feedbackType: .emotionalSupport,
            comments: [
                ManifestationComment(authorName: "Ari", message: "This feels so grounded. Cheering for the calm launch.")
            ],
            affirmationCount: 12,
            isAffirmed: true
        ),
        Wish(
            title: "Creative mornings",
            intention: "Next month, I'm going to begin three mornings a week with writing before I open my messages.",
            status: .planted,
            visibility: .closeCircle,
            authorName: "Kai",
            authorHandle: "@softlaunch",
            isMine: false,
            feedbackType: .advice,
            affirmationCount: 5
        ),
        Wish(
            title: "Trust the next step",
            intention: "I want to move with patience and recognize progress before it becomes obvious.",
            status: .blooming,
            visibility: .everyone,
            authorName: "Noor",
            authorHandle: "@brightpath",
            isMine: false,
            feedbackType: .discourse,
            affirmationCount: 28
        )
    ]
}
