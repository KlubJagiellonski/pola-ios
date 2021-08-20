require_relative 'shared_constants'

platform :ios do

    desc %(Bump version and build number
    Options:  
    - version - new version number
    )
    lane :deploy do |options|
        # bump_version(
        #     version: options[:version]
        # )
        match
    end

  end
