require 'production_unit'

class Technology < ProductionUnit

  def initialize(planet, tds)
    info = parse_level_time_reqs(tds[1])
    info.merge!(parse_build_reqs(tds[2]))
    info[:link] = parse_upgrade_link(tds[3])
    super(planet, info)
  end

  private

  def parse_level_time_reqs(lvltmreq)
    name = lvltmreq.xpath('a').inner_text
    md = /\(Nivel\s+(?<level>(.+))\)/.match(lvltmreq.inner_text)
    level = md ? md[:level].gsub('.', '_').to_i : 0
    md = /Tiempo:(\s+(?<days>(\d+\.*\d+))d){0,1}\s+(?<hours>(\d\d))h\s+(?<minutes>(\d\d))m\s+(?<seconds>(\d\d))s/.match(lvltmreq.inner_text)
    if md
      seconds = md[:seconds].gsub('.', '_').to_i
      minutes = md[:minutes].gsub('.', '_').to_i
      hours = md[:hours].gsub('.', '_').to_i
      days = md[:days] ? md[:days].gsub('.', '_').to_i : 0
      time = seconds + minutes * 60 + hours * 3600 + days * 86400
    else
      STDERR.puts "Failed to parse time reqs in #{self.class}"
      time = 0
    end
    {:name => name, :level => level, :time => time}
  end

  def parse_build_reqs(bldreq)
    md = /[^[:graph:]]*Requiere:(\s+Metal:\s+(?<metal>((\d+\.){0,}\d+)))?(\s+Cristal:\s+(?<crystal>((\d+\.){0,}\d+)))?(\s+Deuterio:\s+(?<deuterium>((\d+\.){0,}\d+)))?/.match(bldreq.inner_text)
    puts "Failed to parse build reqs in #{self.class}" unless md
    metal = md[:metal] || "0"
    crystal = md[:crystal] || "0"
    deuterium = md[:deuterium] || "0"
    md = /\((?<energy_required>([+|-].*))\s+Energ.*a\)/.match(bldreq.inner_text)
    energy_req = md ? md[:energy_required].gsub('.', '_').to_i : 0
    {:metal => metal.gsub('.', '_').to_i, :crystal => crystal.gsub('.', '_').to_i, :deuterium => deuterium.gsub('.', '_').to_i, :energy => -energy_req }
  end

  def parse_upgrade_link(bldreq)
    links = bldreq.ancestors[0].xpath('td/a')
    links.empty? ? nil : links.first[:href]
  end
end
