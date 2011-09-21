class DJjour::CLI
  def self.run(*arguments)
    DNSSD.register Socket.gethostname.gsub(/\./,'_'), '_djjour._tcp', nil, 1337 do |r|
      puts "registered #{r.fullname}" if r.flags.add?
    end

    DJjour::Client.run!
  end
end
