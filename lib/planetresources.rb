class PlanetResources
  RESOURCES = [:metal, :crystal, :deuterium, :darkmatter, :energy, :messages]

  attr_accessor *RESOURCES, :energy_used, :energy_total, :fields
  attr_reader :mech, :planet

  include PageNavigation

  def update!
    lasttime = lastupdate
    lastmetal = metal
    lastcrystal = crystal
    lastdeuterium = deuterium

    super

    difftime = lastupdate - lasttime
    @metal_rate = (metal - lastmetal).to_f / difftime
    @crystal_rate = (crystal - lastcrystal).to_f / difftime
    @deuterium_rate = (deuterium - lastdeuterium).to_f / difftime
  end

  [:metal_rate, :crystal_rate, :deuterium_rate].each do |m|
    meth = m.to_s
    define_method(meth) do
      update! if instance_variable_get("@#{meth}").nil?
      instance_variable_get("@#{meth}")
    end
    define_method(meth + '!') do
      update!
      instance_variable_get("@#{meth}")
    end
  end

  def initialize(mech, planet, options = {})
    @mech, @planet = mech, planet
    resources = RESOURCES.each do |r|
      instance_variable_set("@#{r.to_s}", options[:r] || 0)
    end
    @fields = Hash.new do |k|
      0
    end
    @planet.go_to!
    parse
  end

  def meets?(other, options = {})
    options = {:fields => true, :energy => true, :metal => true, :crystal => true, :deuterium => true, :darkmatter => false}.merge options
    # don't fill the planet, leave that to the user
    return false if options[:fields] and not fields[:available] > 1
    RESOURCES[0,5].map do |r|
      # we should not check against negative resources:
      # ie. comparing a deficit in energy of -800 against a 0 requirement would return false if just asking if -800 >= 0.
      # if a requirement is == 0, it always is met
      if options[r]
        ores = other.send(r)
        ores <= 0 ? true : self.send(r) >= ores
      else
        true
      end
    end.all?
  end

  def meets_energy?(other)
    energy - other.energy >= 0
  end

  def energy_overrun?
    energy_used > energy_total
  end

  def energy_available
    energy_total - energy_used
  end

  private

  def go_to
    # resources are shown everywhere while at the same planet, but not fields
    @mech.click(@mech.current_page.link_with :text => /(Edif.*cio|Construc.*)/)
  end

  def parse(nokodoc = page.parser)
    # looks for the values for Metal, Crystal, Deuterium, Dark Matter, Energy, Messages
    # it does so scanning for the known xpath of Metal, going up and getting all the table data
    # note: this has been tested under Ruby's Nokogiri. JRuby's Nokogiri may not work here without some modifications
    resources = RESOURCES.each
    if nokodoc
      nokodoc.xpath('//td[@class="header"]/font').first.ancestors[1].xpath('td').each do |e|
        r = resources.next
        # sanitize integers (bad habit of having "3.500" instead of "3500" or "3_500"
        text = e.text.gsub '.', '_'
        if r == :energy
          # energy is specified as "available/total"
          @energy, @energy_total = text.split('/').map &:to_i
          @energy_used = @energy_total - @energy
        else
          instance_variable_set("@#{r.to_s}", text.to_i)
        end
      end
      parse_fields nokodoc
    end
  end

  def parse_fields(nokodoc)
    md = /\s*(?<fields_used>(.*))\s*\/\s*(?<fields_total>(.*))\s+quedan\s+(?<fields_available>(.*))\s+campos libres/.match(nokodoc.inner_text)
    @fields = { :used => md[:fields_used].gsub('.', '_').to_i, :total => md[:fields_total].gsub('.', '_').to_i, :available => md[:fields_available].gsub('.', '_').to_i }
  end
end
