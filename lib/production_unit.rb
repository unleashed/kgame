class ProductionUnit
  attr_reader :planet, :info

  def initialize(planet, info)
    @planet, @info = planet, info
    @info.each do |k, v|
      # add methods for every attribute
      class << self; self; end.send :define_method, k do
        v
      end
    end
    def upgradeable?(resources = planet.resources, options = {})
      return nil if options[:name] and self.name != options[:name]
      return resources.meets?(self, options) if resources
      return @info[:link]
    end
  end

  def build!
    planet.build! self
  end

  def level_up_wait?(resources = planet.resources)
    t = Time.now
    estimated = 0.0
    estimated += (metal - resources.metal).to_f/resources.metal_rate if metal > resources.metal
    estimated += (crystal - resources.crystal).to_f/resources.crystal_rate if crystal > resources.crystal
    estimated += (deuterium - resources.deuterium).to_f/resources.deuterium_rate if deuterium > resources.deuterium
    estimated.ceil
  end
end
