require 'production_list'
require 'technology'

class Research < ProductionList
  def initialize(mech, planet)
    super(mech, planet, Technology)
  end

  def self.slicecount
    4	# number of <td> per tech
  end

  private

  def go_to
    @mech.click(@mech.current_page.link_with :text => /Investiga/)
  end
end
