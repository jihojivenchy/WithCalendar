# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ScheduleCalendarProject' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ScheduleCalendarProject

  pod 'UIColor_Hex_Swift', '~> 5.1.7'
  pod 'TextFieldEffects'
  pod 'Tabman', '~> 3.0'
  pod 'lottie-ios' 
  pod 'NVActivityIndicatorView'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/wowansm/Chameleon.git', :branch => 'swift5'
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end