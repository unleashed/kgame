require 'production_list'
require 'building'

class Buildings < ProductionList
  def initialize(mech, planet)
    super(mech, planet, Building)
  end

  def self.slicecount
    3   # number of <td> per building
  end

  private

  def go_to
    @mech.click(@mech.current_page.link_with :text => /(Edif.*cio|Construc.*)/)
  end
end
