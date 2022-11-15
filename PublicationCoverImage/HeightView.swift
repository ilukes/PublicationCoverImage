
import SwiftUI

struct HeightView: View {
    /// Need this to refresh the subview
    @State private var sizes: [CGSize] = Array(repeating: .init(width: 200, height: 300), count: 100)
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(0 ..< 20) { index in
                    CoverImageView(
                        viewModel: .init(
                            title: urls[index % urls.count],
                            fit: .coverHeight,
                            profile: .init(
                                links: [urls[index % urls.count]]
                            )
                        ),
                        resizing: { size in
                            self.sizes[index] = size
                        }
                    )
                }
            }
            .padding(.leading, 5)
        }
        .frame(height: 300)
    }
}

struct HeightView_Previews: PreviewProvider {
    static var previews: some View {
        HeightView()
    }
}
