import Foundation

final class ManifestationStore: ObservableObject {
    @Published private(set) var myManifestations: [Wish]
    @Published private(set) var feedManifestations: [Wish]

    init(
        myManifestations: [Wish] = Wish.samples,
        feedManifestations: [Wish] = Wish.friendSamples
    ) {
        self.myManifestations = myManifestations
        self.feedManifestations = feedManifestations
    }

    var personalFeed: [Wish] {
        myManifestations.sorted { $0.createdAt > $1.createdAt }
    }

    var socialFeed: [Wish] {
        (shareableMine + feedManifestations).sorted { $0.createdAt > $1.createdAt }
    }

    func addManifestation(
        intention: String,
        feedbackType: ManifestationFeedbackType,
        visibility: ManifestationVisibility
    ) -> Wish {
        let trimmed = intention.trimmingCharacters(in: .whitespacesAndNewlines)
        let title = Self.title(for: trimmed)
        let manifestation = Wish(
            title: title,
            intention: trimmed,
            status: .planted,
            visibility: visibility,
            feedbackType: feedbackType
        )

        myManifestations.insert(manifestation, at: 0)
        return manifestation
    }

    func manifestation(with id: Wish.ID) -> Wish? {
        (myManifestations + feedManifestations).first { $0.id == id }
    }

    func addComment(to manifestationID: Wish.ID, message: String) {
        let comment = ManifestationComment(authorName: "Malik", message: message)
        updateManifestation(with: manifestationID) { manifestation in
            manifestation.comments.append(comment)
        }
    }

    func toggleAffirmation(for manifestationID: Wish.ID) {
        updateManifestation(with: manifestationID) { manifestation in
            if manifestation.isAffirmed {
                manifestation.isAffirmed = false
                manifestation.affirmationCount = max(0, manifestation.affirmationCount - 1)
            } else {
                manifestation.isAffirmed = true
                manifestation.affirmationCount += 1
            }
        }
    }

    private var shareableMine: [Wish] {
        myManifestations.filter { $0.visibility != .privateOnly }
    }

    private func updateManifestation(with id: Wish.ID, mutate: (inout Wish) -> Void) {
        if let index = myManifestations.firstIndex(where: { $0.id == id }) {
            mutate(&myManifestations[index])
            return
        }

        if let index = feedManifestations.firstIndex(where: { $0.id == id }) {
            mutate(&feedManifestations[index])
        }
    }

    private static func title(for intention: String) -> String {
        let cleaned = intention
            .replacingOccurrences(of: "\n", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if cleaned.count <= 42 {
            return cleaned
        }

        let endIndex = cleaned.index(cleaned.startIndex, offsetBy: 42)
        return String(cleaned[..<endIndex]).trimmingCharacters(in: .whitespaces) + "..."
    }
}
