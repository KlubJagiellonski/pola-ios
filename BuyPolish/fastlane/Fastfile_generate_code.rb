platform :ios do

    desc "Generate code using Sourcery. Require pod installation before."
    lane :generate_code do
      ENV["SOURCERY_EXECUTABLE"] = "Pods/Sourcery/bin/sourcery"
      sourcery(config: "PolaTests/.sourcery.yml")
    end

  end
