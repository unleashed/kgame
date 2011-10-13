require 'pagenavigation'

# TODO: actually scrape all the flights, currently just checks for an attacking flight

class Flights
  attr_reader :mech, :flights

  include PageNavigation

  def initialize(mech)
    @mech = mech
    @attacks = {}
    @flights = {:attacks => @attacks}
    parse
  end

  def update!
    @attacks = {}
    @flights = {:attacks => @attacks}
    super
  end

  def parse(nokodoc = page.parser)
    att = nokodoc.xpath('//span[@class="flight attack"]')
    return nil if att.empty?
    attstr = att.first.ancestors[1].inner_text
    r = /(?<fleet_number>(\w+)) flotas de (?<offender>(\w+))\s+se dirige desde el planeta (?<off_planetname>(.*))\s+\[(?<off_planet>(\d+:\d+:\d+))\] hacia el planeta (?<def_planetname>(.*))\s+\[(?<def_planet>(\d+:\d+:\d+))\]. Con la misi.*n de: Atacar\s+ppofs\w+ = (?<eta>(\d+));/
    md = r.match attstr
    if md
      @attacks[md[:def_planet]] ||= []
      @attacks[md[:def_planet]] << { :eta => Time.now + md[:eta].to_i, :offender => md[:offender], :from => md[:off_planet], :number => md[:fleet_number] }
    end
    @flights[:attacks] = @attacks
    prune
  end

  private

  def go_to
    @mech.click(@mech.current_page.link_with :text => /General/)
  end

  def prune
    # remove old fleets attacking
    t = Time.now
    @attacks.each do |coords, info|
      info.reject! do |i|
        i[:eta] < t
      end
      info.sort_by! do |i|
        i[:eta] - t
      end
    end
  end
end
