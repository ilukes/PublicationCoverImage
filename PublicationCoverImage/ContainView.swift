
import SwiftUI

struct ContainView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                ForEach(0 ..< 5) { index in
                    CoverImageView(
                        viewModel: .init(
                            title: urls[index % urls.count],
                            fit: .contain,
                            profile: .init(
                                links: [urls[index % urls.count]]
                            )
                        )
                    )
                    .frame(width: 300, height: 286)
                }
            }
        }
        .padding()
    }
}

struct ContainView_Previews: PreviewProvider {
    static var previews: some View {
        ContainView()
    }
}
