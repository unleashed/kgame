require 'buildings'
require 'research'
require 'planetresources'
require 'planethash'

class Planet
  include PageNavigation
  include PlanetHash

  attr_accessor :planet_id, :resources, :buildings, :research

  alias_method :coords, :planet_id

  def initialize(mech, planet_id)
    @mech, @planet_id = mech, planet_id
    planet_hash_update!(@mech)
  end

  def build!(unit)
    go_to!
    puts "#{Time.now} - #{coords}: Construyendo #{unit.name} (#{unit.level+1}) por M: #{unit.metal} C: #{unit.crystal} D: #{unit.deuterium} en #{unit.time} segundos"
    @mech.get(unit.link)
    unit.time
  end

  def upgradeable?(options = {})
    options = { :buildings => {}, :research => {} }.merge! options
    all = options.delete :all
    options.each do |k, v|
      v.merge! all
    end if all
    buildings.upgradeable(resources, options[:buildings]) + research.upgradeable(resources, options[:research])
  end

  def current?
    planet_hash_update!(@mech)
    get_current_planet_id(@mech.current_page.parser) == planet_id
  end

  def resources(update = false)
    @resources ||= PlanetResources.new @mech, self
    @resources.update! if update
    @resources
  end

  def buildings(update = false)
    @buildings ||= Buildings.new @mech, self
    @buildings.update! if update
    @buildings
  end

  def research(update = false)
    @research ||= Research.new @mech, self
    @research.update! if update
    @research
  end

  private

    def go_to
      current? ? @mech.current_page : @mech.get(link_for(@mech.current_page.parser, planet_id))
    end

    # called by pagenav on update! method call
    def parse(nokodoc = page.parser)
      resources.update!
      research.update!
      buildings.update!
    end

    # these probably don't belong here, but it is convenient as we can update
    # the list of planets by reading the planet <select> options from the page
    # returns [k, v]
    def find_planet_by(nokodoc)
      # get the selected value for planet
      planet_hash.find do |k, v|
        yield(k, v)
      end
    end

    def get_current_planet_id(nokodoc)
      find_planet_by(nokodoc) do |k, v|
        v[:selected]
      end.first
    end

    def link_for(nokodoc, planet_id)
      find_planet_by(nokodoc) do |k, v|
        k == planet_id
      end.last[:link]
    end
end
