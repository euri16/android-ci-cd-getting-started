module Fastlane
    module Actions
        module SharedValues
            ANDROID_VERSION_NAME = :ANDROID_VERSION_NAME
        end

        class GetAndroidVersionNameAction < Action
            def self.run(params)
                path = params[:path]

                major = 0
                foundMajor = false
                minor = 0
                foundMinor = false
                patch = 0
                foundPatch = false

                data = File.read(path)
                data.each_line do |line|
                    if (line.start_with?("MAJOR"))
                        foundMajor = true
                        major = line.delete("MAJOR=").to_i
                    elsif (line.start_with?("MINOR"))
                        foundMinor = true
                        minor = line.delete("MINOR=").to_i
                    elsif (line.start_with?("PATCH"))
                        foundPatch = true
                        patch = line.delete("PATCH=").to_i
                    end
                end

                if (!foundMajor)
                    UI.error "MAJOR not found in file, please ensure file contains 'MAJOR=0' declaration"
                    raise "Illegal Argument Exception : No MAJOR variable in file"
                end
                if (!foundMinor)
                    UI.error "MINOR not found in file, please ensure file contains 'MINOR=0' declaration"
                    raise "Illegal Argument Exception : No MINOR variable in file"
                end
                if (!foundPatch)
                    UI.error "PATCH not found in file, please ensure file contains 'PATCH=0' declaration"
                    raise "Illegal Argument Exception : No PATCH variable in file"
                end

                versionName = "#{major}.#{minor}.#{patch}"
                UI.message "Android version name #{versionName}"
                return Actions.lane_context[SharedValues::ANDROID_VERSION_NAME] = versionName
            end

            def self.description
                'This action reads the Android version name'
            end

            def self.is_supported?(platform)
                platform == :android
            end

            def self.author
                "iceque"
            end

            def self.available_options
                [
                    FastlaneCore::ConfigItem.new(key: :path,
                                       description: "Path to your version.properties file",
                                       optional: false)
               ]
            end

            def self.output
                [
                    ['ANDROID_VERSION_NAME', 'Current version name']
                ]
            end

            def self.example_code
                [
                    'get_android_version_name(
                        path: "/path/to/version.properties"
                        type: "patch"
                    )'
                ]
            end

            def self.category
                :project
            end
        end
    end
end