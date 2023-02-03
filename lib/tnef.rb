require "tnef/version"
require "tnef/executable"

require "tmpdir"
require "fileutils"

module Tnef

  def self.unpack(winmail_io, &block)
    in_tmp_dir do |dir|
      IO.popen("#{Tnef::Executable.path} --number-backups --save-body --body-pref th -K --directory=#{dir}", "wb") do |tnef|
        tnef.write(winmail_io.read)
        tnef.close
      end

      Dir.glob("#{dir}/*").select { |node| File.file?(node) }.sort.each do |file|
        yield(file)
      end
    end
  end

  def self.in_tmp_dir(&block)
    yield(Dir.mktmpdir)
  end
end
