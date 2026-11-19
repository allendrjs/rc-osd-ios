import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: AppSession
    @StateObject private var viewModel = LoginViewModel()
    @State private var showPassword = false
    @FocusState private var focusedField: Field?

    private enum Field { case studentId, password }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header
                form
            }
            .padding(24)
            .frame(maxWidth: 420)
            .background(Color.osdaSurface)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.osdaBorder, lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 48)
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.osdaBackground.ignoresSafeArea())
        .onTapGesture { focusedField = nil }
    }

    private var header: some View {
        VStack(spacing: 4) {
            Image(systemName: "building.columns.fill")
                .font(.system(size: 32))
                .foregroundStyle(Color.osdaPrimary)
                .frame(width: 72, height: 72)
                .background(Circle().fill(Color.osdaPrimaryMuted.opacity(0.4)))
                .accessibilityHidden(true)
                .padding(.bottom, 12)

            Text("Office for Student Discipline")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.osdaHeading)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Text("Sign in with your Student ID")
                .font(.subheadline)
                .foregroundStyle(Color.osdaMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 24)
    }

    private var form: some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldLabel("STUDENT ID *")
            TextField("e.g. CT23-0002", text: $viewModel.studentId)
                .textContentType(.username)
                .keyboardType(.asciiCapable)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .submitLabel(.next)
                .focused($focusedField, equals: .studentId)
                .onSubmit { focusedField = .password }
                .modifier(InputFieldStyle(isFocused: focusedField == .studentId))
                .accessibilityLabel("Student ID")

            fieldLabel("PASSWORD *")
                .padding(.top, 8)
            HStack(spacing: 8) {
                Group {
                    if showPassword {
                        TextField("", text: $viewModel.password)
                    } else {
                        SecureField("", text: $viewModel.password)
                    }
                }
                .textContentType(.password)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.go)
                .focused($focusedField, equals: .password)
                .onSubmit(submit)
                .accessibilityLabel("Password")

                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundStyle(Color.osdaMuted)
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel(showPassword ? "Hide password" : "Show password")
            }
            .modifier(InputFieldStyle(isFocused: focusedField == .password, trailingPadding: 4))

            if let message = viewModel.errorMessage {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(Color.osdaError)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityLabel("Error: \(message)")
            }

            Button(action: submit) {
                HStack(spacing: 8) {
                    if viewModel.isLoading {
                        ProgressView().tint(Color.osdaOnPrimary)
                    }
                    Text(viewModel.isLoading ? "Signing in..." : "Sign In")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, minHeight: 52)
                .foregroundStyle(Color.osdaOnPrimary)
                .background(Color.osdaPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .padding(.top, 12)
            .disabled(viewModel.isLoading)
        }
        .disabled(viewModel.isLoading)
        .onChange(of: viewModel.errorMessage) { message in
            if let message { UIAccessibility.post(notification: .announcement, argument: message) }
        }
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color.osdaMuted)
            .accessibilityHidden(true)
    }

    private func submit() {
        focusedField = nil
        Task {
            if let response = await viewModel.login() {
                session.signIn(with: response)
            }
        }
    }
}

private struct InputFieldStyle: ViewModifier {
    let isFocused: Bool
    var trailingPadding: CGFloat = 14

    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundStyle(Color.osdaHeading)
            .padding(.leading, 14)
            .padding(.trailing, trailingPadding)
            .frame(minHeight: 52)
            .background(Color.osdaSurface)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isFocused ? Color.osdaPrimary : Color.osdaBorder, lineWidth: isFocused ? 1.5 : 1)
            )
    }
}

#Preview {
    LoginView().environmentObject(AppSession())
}
