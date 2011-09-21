class DJjour::Bonjour
  def self.register
    DNSSD.register Socket.gethostname.gsub(/\W/,'_'), '_djjour._tcp', nil, 1337 do |r|
      puts "registered #{r.fullname}" if r.flags.add?
    end
  end
end
