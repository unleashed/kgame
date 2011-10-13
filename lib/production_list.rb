require 'pagenavigation'
require 'building'

class ProductionList
  attr_accessor :list, :busy_until
  attr_reader :mech, :planet

  include Enumerable
  include PageNavigation

  def each(&block)
    list.each(&block)
  end

  def [](*args, &block)
    list.[](*args, &block)
  end

  def last
    list[-1]
  end

  def initialize(mech, planet, unitklass)
    @mech = mech
    @planet = planet
    @busy_until = Time.now - 1
    @page = nil
    @unitklass = unitklass
  end

  def list(update = false)
    update! if @list.nil? or update
    @list
  end

  def busy?
    Time.now <= busy_until
  end

  def busy_time_left
    busy_until - Time.now
  end

  def upgradeable(resources = planet.resources, options = {})
    list.find_all do |b|
      b.upgradeable?(resources, options)
    end
  end

  private

  def go_to
    raise 'Unimplemented go_to method! Must be implemented by classes inheriting ProductionList'
  end

  # default search XPath
  def self.searchxpath
    '//table[@width="530"]/td[@class="l"]/table/tr/td'
  end

  def parse(nokodoc = page.parser)
    # the xpath gives 3 elements for every building in form of td tags
    # first is a td with an image linking to building info
    # second is a td with a building info link and its name (in the link)
    # from this one we can get energy and time requirements as text
    # third one contains metal, crystal and deuterium requirements
    @list = []
    nokodoc.xpath(self.class.searchxpath).each_slice(self.class.slicecount) do |tds|
      @list << @unitklass.new(planet, tds)
    end
  end
end
