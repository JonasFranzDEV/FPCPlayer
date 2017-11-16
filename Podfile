# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
workspace 'Floatplane Club'

target 'Floatplane Authenticator' do
    project ‘Floatplane Authenticator/Floatplane Authenticator.xcodeproj’
    use_frameworks!

    pod 'Voucher'
    pod 'SwiftKeychainWrapper'
end

target 'Floatplane Club' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Floatplane Club
  pod 'Voucher'

  target 'Floatplane ClubTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Floatplane ClubUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
