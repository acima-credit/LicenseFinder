# frozen_string_literal: true

module LicenseFinder
  module SharedHelpers
    class Cmd
      def self.run(command)
        out, err = with_temp_files(2) do |out_tmp, err_tmp|
          pid = Process.spawn command, out: out_tmp, err: err_tmp
          Process.wait pid
        end
        [out, err, $CHILD_STATUS]
      end

      def self.with_temp_files(nr)
        files   = nr.times.map { |x| Tempfile.new "file_#{x}" }
        results = []

        yield(*files)

        files.map do |tmp|
          tmp.rewind
          res = tmp.read
          tmp.close
          tmp.unlink
          res
        end
      end
    end
  end
end
