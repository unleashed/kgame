module PlanetHash
  def planet_hash
    @planet_hash ||= {}
  end

  def planet_hash_update!(mech)
    parse_planets(mech.current_page.parser)
  end

  private

  def parse_planets(nokodoc)
    planet_options = nokodoc.xpath('//td[@class="header"]/table[@class="header"]/select')
    planet_options.children.each do |p|
      # Nokogiri on JRuby does provide Nokogiri::XML::Text for whitespace! :/
      next if p.is_a? Nokogiri::XML::Text
      # &nbsp; is not classified as a SPACE character, even though it is an HTML space, so we must use NOT graph in the regexp
      md = /(?<name>(.*))[^[:graph:]]\[(?<coords>(\d+:\d+:\d+))\]/.match(p.children.text)
      if md
        planet_hash[md[:coords]] = { :name => md[:name].chop, :link => p.attribute('value').value, :selected => p.attribute('selected') ? true : false }
      else
        STDERR.puts "Option in html planet select '#{p.children.text}' not matched against regexp"
      end
    end
    planet_hash
  end
end
