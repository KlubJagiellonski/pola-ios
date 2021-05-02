import 'shared_constants.rb'

platform :ios do

    desc %(Bump version and build number
    Options:  
    - version - new version number
    )
    lane :bump_version do |options|
      if !options[:version]
        raise "No version specified!".red
      end
      version = options[:version]
  
      increment_version_number_in_plist(
        version_number: version,
        target: App_sheme
      )
      build_number = increment_build_number_in_plist(
        target: App_sheme
      )

      snapshot_path = "PolaUITests/Tests/__Snapshots__/InformationPageUITests/testOpenInformationPage.1.png"
      delete_files(file_pattern:snapshot_path)
      scan(
        scheme: App_sheme,
        testplan: "BumpVersion",
        fail_build: false
      )

      plist_path = "Pola/SupportingFiles/Pola-Info.plist"
      commit_and_push_if_ci(
        message: "Bump version to #{version} build number to #{build_number}",
        path: [plist_path, snapshot_path]
      )

    end

  end
