import 'shared_constants.rb'

swiftformat_executable = "Pods/SwiftFormat/CommandLineTool/swiftformat"

platform :ios do

  private_lane :commit_and_push_if_ci do |options|
    if is_ci

      if !options[:message]
        message "No message specified!".red
      end
      message = options[:message]

      if !options[:path]
        path "No path specified!".red
      end
      path = options[:path]

      set_git_config_user(
        name: "pola-ci",
        email: "pola@klubjagiellonski.pl"
      )
      git_commit(
        message: message,
        path: path
      )
      push_to_git_remote
    end
  end

end
