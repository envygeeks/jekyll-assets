require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
task :default => [:spec]

task :analysis do
  require "open3"
  begin require "jekyll/utils/ansi"
  rescue LoadError
    require_relative "spec/support/ansi"
  end

  cmd = [
    "docker", "run", "--rm", "--env=CODE_PATH=#{Dir.pwd}", \
    "--volume='#{Dir.pwd}:/code'", "--volume=/var/run/docker.sock:/var/run/docker.sock", \
    "--volume=/tmp/cc:/tmp/cc", "-i", "codeclimate/codeclimate", "analyze"
  ]

  ansi = Jekyll::Utils::Ansi
  file = File.open(".analysis", "w+")
  Open3.popen3(cmd.shelljoin) do |_, out, err, _|
    while data = out.gets
      file.write data
      if data =~ /\A==/
        $stdout.print ansi.yellow(data)

      elsif data !~ %r!\A[0-9\-]+!
        $stdout.puts data

      else
        h, d = data.split(":", 2)
        $stdout.print ansi.cyan(h)
        $stdout.print ":", d
      end
    end

    while data = err.gets
      file.write data
      $stderr.print ansi.red(data)
    end
  end

  file.close
end
