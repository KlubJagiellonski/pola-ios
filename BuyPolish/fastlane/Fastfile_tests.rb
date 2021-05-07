import 'shared_constants.rb'

swiftformat_executable = "Pods/SwiftFormat/CommandLineTool/swiftformat"
testplan_full = "Full"

platform :ios do
  lane :tests do
    check_project_structure
    check_formatting
    scan(testplan: testplan_full)
  end

  lane :record_snapshots do
    snapshots_paths = [
      "PolaTests/__Snapshots__",
      "PolaTests/UI/__Snapshots__",
      "PolaUITests/Tests/__Snapshots__"
    ]

    snapshots_paths.each {|path| clear_derived_data(derived_data_path:path)}
    scan(
      testplan: testplan_full,
      fail_build: false
    )
    commit_and_push_if_ci(
      message: "Record snapshot :camera:",
      path: snapshots_paths
    )
  end

  lane :check_project_structure do
    synx
    ensure_no_changes(
      path: "Pola.xcodeproj",
      show_diff: false,
      error_message: "Project structure is different than synx output. Run `fastlane ios format` to synchronize project with file structure."
    )
  end

  lane :check_formatting do
    swiftformat(
      executable: swiftformat_executable,
      lint: true
    )

  end

  lane :format do
    synx

    swiftformat(
      executable: swiftformat_executable,
    )
  end

end
