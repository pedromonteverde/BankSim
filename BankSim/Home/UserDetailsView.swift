//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI

struct UserDetailsView: View {

    @StateObject var viewModel: HomeViewModel

    var body: some View {
        VStack {
            Text("👤 User: \(viewModel.userName)" )
        }
    }
}
