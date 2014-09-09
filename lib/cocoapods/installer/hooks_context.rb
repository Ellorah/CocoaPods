module Pod
  class Installer
    # Context object designed to be used with the HooksManager which describes
    # the context of the installer.
    #
    class HooksContext
      # @return [String] The path to the sandbox root (`Pods` directory).
      #
      attr_accessor :sandbox_root

      # @return [Array<UmbrellaTargetDescription>] The list of
      #         the CocoaPods umbrella targets generated by the installer.
      #
      attr_accessor :umbrella_targets

      # @return [HooksContext] Convenience class method to generate the
      #         static context.
      #
      def self.generate(sandbox, aggregate_targets)
        umbrella_targets_descriptions = []
        aggregate_targets.each do |umbrella|
          desc = UmbrellaTargetDescription.new
          desc.user_project_path = umbrella.user_project_path
          desc.user_target_uuids = umbrella.user_target_uuids
          desc.specs = umbrella.specs
          desc.platform_name = umbrella.platform.name
          desc.platform_deployment_target = umbrella.platform.deployment_target.to_s
          desc.cocoapods_target_label = umbrella.label
          umbrella_targets_descriptions << desc
        end

        result = new
        result.sandbox_root = sandbox.root.to_s
        result.umbrella_targets = umbrella_targets_descriptions
        result
      end

      # Pure data class which describes and umbrella target.
      #
      class UmbrellaTargetDescription
        # @return [String] The path of the user project
        #         integrated by this target.
        #
        attr_accessor :user_project_path

        # @return [Array<String>] The list of the UUIDs of the
        #         user targets integrated by this umbrella
        #         target.  They can be used to find the
        #         targets opening the project They can be used
        #         to find the targets opening the project with
        #         Xcodeproj.
        #
        attr_accessor :user_target_uuids

        # @return [Array<Specification>] The list of the
        #         specifications of the target.
        #
        attr_accessor :specs

        # @return [Symbol] The platform (either `:ios` or `:osx`).
        #
        attr_accessor :platform_name

        # @return [String] The deployment target.
        #
        attr_accessor :platform_deployment_target

        # @return [String] The label for the target.
        #
        attr_accessor :cocoapods_target_label
      end
    end
  end
end