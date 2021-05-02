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
        target: 'Pola'
      )
      build_number = increment_build_number_in_plist(
        target: 'Pola'
      )

    end

  end
