
import SwiftUI

final class CoverImageViewModel: ObservableObject {
    enum State {
        case none
        case loading
        case success
        case failed
    }

    enum Fit {
        case contain
        case coverWidth
        case coverHeight
    }

    /// This struct can init from PublicationItem or Entry(R2Publication),
    /// it can have the type and links and others properties in the future
    struct Profile {
        let links: [String]
    }

    let title: String
    let fit: Fit
    let profile: Profile

    @Published fileprivate var state: State = .none

    fileprivate var image: UIImage?

    private var imageWidth: CGFloat = 0
    private var imageHeight: CGFloat = 0

    init(title: String, fit: Fit, profile: Profile) {
        self.title = title
        self.fit = fit
        self.profile = profile
    }

    private func changeState(to state: State) {
        DispatchQueue.main.async {
            self.state = state
        }
    }

    fileprivate func fetchImage() async {
        changeState(to: .loading)

        // try? await Task.sleep(nanoseconds: UInt64(Double(Int.random(in: 1 ..< 5)) * Double(NSEC_PER_SEC)))

        guard let url = getImageLink() else {
            changeState(to: .failed)
            return
        }

        image = UIImage(named: url)
        imageWidth = image?.size.width ?? 0
        imageHeight = image?.size.height ?? 0
        changeState(to: .success)
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            if let img = UIImage(data: data) {
//                image = img
//                changeState(to: .success)
//            } else {
//                changeState(to: .failed)
//            }
//        } catch {
//            changeState(to: .failed)
//        }
    }

    /// Find the right link in here(For now, just get the first link)
    private func getImageLink() -> String? {
        profile.links.first
    }

    /// Get the ImageView height with given the size
    fileprivate func getImageViewHeight(_ size: CGSize) -> CGFloat {
        guard imageWidth > 0, imageHeight > 0 else {
            return size.height
        }

        switch fit {
            case .contain:
                let height = min(imageHeight * size.width / imageWidth, size.height)
                let width = imageWidth * height / imageHeight
                
                if width > size.width {
                    return imageHeight * size.width / imageWidth
                }
                
                return height
                
            case .coverWidth:
                return min(imageHeight * size.width / imageWidth, size.height)
                
            case .coverHeight:
                return imageHeight
        }
    }

    fileprivate func getImageViewWidth(_ size: CGSize) -> CGFloat {
        guard imageWidth > 0, imageHeight > 0 else {
            return size.width
        }

        switch fit {
            case .contain:
                let width = min(imageWidth * size.height / imageHeight, size.width)
                let height = width * imageHeight / imageWidth
                
                if height > size.height {
                    return imageWidth * size.height / imageHeight
                }
                
                return width
                
            case .coverWidth:
                if imageHeight * size.width / imageWidth > size.height {
                    return imageWidth * size.height / imageHeight
                }

                return size.width
                
            case .coverHeight:
                return imageWidth * size.height / imageHeight
        }
    }

    /// Get the Image real ratio
    fileprivate func getImageRatio() -> CGFloat {
        guard imageWidth > 0, imageHeight > 0 else {
            return 1
        }

        return imageWidth / imageHeight
    }
}

struct CoverImageView: View {
    @ObservedObject var viewModel: CoverImageViewModel

    @State private var size: CGSize? = nil

    var resizing: ((CGSize) -> Void)? = nil

    var body: some View {
        ZStack {
            if viewModel.state != .success {
                Color.red.ignoresSafeArea()
            }

            if viewModel.state == .loading {
                ProgressView()
            } else if viewModel.state == .success {
                CoverView()
            } else if viewModel.state == .failed {
                EmptyView()
            }
        }
        .if(size != nil, transform: {
            $0.frame(width: size!.width, height: size!.height)
        })
        .onAppear {
            Task {
                await viewModel.fetchImage()
            }
        }
    }

    @ViewBuilder
    private func EmptyView() -> some View {
        Text(viewModel.title)
            .lineLimit(0)
            .multilineTextAlignment(.center)
            .padding(5)
    }

    @ViewBuilder
    private func CoverView() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            if viewModel.fit == .coverWidth {
                VStack {
                    Spacer(minLength: 0)

                    ImageView()
                        .aspectRatio(viewModel.getImageRatio(), contentMode: .fit)
                        .frame(width: size.width, height: viewModel.getImageViewHeight(size))
                }
                .clipped()
            } else if viewModel.fit == .coverHeight {
                HStack {
                    ImageView()
                        .aspectRatio(viewModel.getImageRatio(), contentMode: .fit)
                        .frame(width: viewModel.getImageViewWidth(size), height: size.height)
                        .frame(maxWidth: .infinity)
                        .onAppear {
                            self.size = .init(width: viewModel.getImageViewWidth(size), height: size.height)
                            self.resizing?(self.size!)
                        }
                }
                .clipped()
            } else if viewModel.fit == .contain {
                VStack {
                    ImageView()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: viewModel.getImageViewWidth(size), height: viewModel.getImageViewHeight(size))

                    Spacer(minLength: 0)
                }
                .clipped()
            }
        }
    }

    @ViewBuilder
    private func ImageView() -> some View {
        Image(uiImage: viewModel.image!)
            .resizable()
    }
}
