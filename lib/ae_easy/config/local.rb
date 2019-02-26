module AeEasy
  module Config
    # Manage configuration from a file.
    class Local
      # Configuration loaded from local configuarion file (see #load).
      #
      # @return [Hash,nil] `nil` when nothing has been loaded.
      attr_reader :local

      # Clear cache.
      def self.clear_cache
        @@local = {}
      end

      # Convert to hash.
      #
      # @return [Hash]
      def to_h
        local
      end

      # Load into or from cache a configuration file contents.
      #
      # @param [String] file_path Configuration file path.
      # @param [Hash] opts ({}) Configuration options.
      # @option opts [Boolean] :force (false) Will reload configuration file
      #   when `true`.
      #
      # @return [Hash] Configuration file contents.
      def self.load_file file_path, opts = {}
        opts = {
          force: false
        }.merge opts
        key = file_path = File.expand_path file_path
        @@local ||= {}
        return @@local[key] if !opts[:force] && @@local.has_key?(key)

        @@local[key] = YAML.load_file(file_path) || {}
        @@local[key].freeze
      end

      # Get configuration key contents.
      #
      # @param [String] key Configuration option key.
      #
      # @return [Object,nil]
      def [](key)
        local[key]
      end

      # Local configuration file path.
      #
      # @return [String] Configuration local file path. Default is
      #   `./ae_easy.yaml`
      def file_path
        @file_path ||= File.expand_path(File.join('.', 'ae_easy.yaml'))
      end

      # Loads a local configuration file.
      #
      # @param [Hash] opts ({}) Configuration options.
      # @option opts [String] :file_path (nil) Configuration file path to load (see
      #   #file_path for configuration default file.)
      # @option opts [Boolean] :force (false) Will reload configuration file
      #   when `true`.
      def load opts = {}
        opts = {
          file_path: nil,
          force: false
        }.merge opts
        @file_path = opts[:file_path] || file_path
        @local = self.class.load_file(file_path, opts)
      end

      # Reloads local configuration file.
      def reload
        load force: true
      end

      # Initialize.
      #
      # @param [Hash] opts ({}) Configuration options (see #load).
      def initialize opts = {}
        load opts
      end
    end
  end
end
