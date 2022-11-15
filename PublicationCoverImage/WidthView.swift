
import SwiftUI

struct WidthView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(0..<100) { index in
                    CoverImageView(
                        viewModel: .init(
                            title: urls[index % urls.count],
                            fit: .coverWidth,
                            profile: .init(
                                links: [urls[index % urls.count]]
                            )
                        )
                    )
                    .frame(height: 200)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct WidthView_Previews: PreviewProvider {
    static var previews: some View {
        WidthView()
    }
}
