require_relative 'shared_constants'

platform :ios do

    desc %(Bump version and build number
    Options:  
    - version - new version number
    )
    lane :deploy do |options|
        bump_version(
            version: options[:version]
        )
        match
        build_app
        upload_to_testflight(
            skip_waiting_for_build_processing: true
        )
    end

  end
