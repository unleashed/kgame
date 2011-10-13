#
# KGame scraper - An XGProyect scraper library
# Copyright (c) 2011 Alejandro Martinez Ruiz - alex (at) flawedcode [dot] org
#
# Originally written as an scraper for http://mundok.sytes.net:8080 (KGame)
# Functional for XGProyect v2.9.9 Rp1 ExTreme repack (http://xgproyect.net)
#
# This program/library is licensed under the 3-clause BSD license ("New BSD").
# See LICENSE or http://www.opensource.org/licenses/BSD-3-Clause for details.
#

require 'browser'
require 'planet'
require 'flights'

class KGame
  # default URI
  URI = 'http://mundok.sytes.net:8080/'
  # a race has to be selected on registration form
  RACES = ['humano', 'vampiro', 'lobo', 'asgard']

  attr_reader :mech, :home, :planets

  include PlanetHash

  def initialize(uri = URI)
    @uri = uri
    @planets = []
    @flights = nil
    @mech = Browser.new
    puts "User agent: #{@mech.user_agent}"
  end

  def register(user, pass, email, race = :humano)
    # race = humano, vampiro, lobo, asgard
    race = race.to_s.downcase
    raise "Unknown race #{race}" unless RACES.include? race

    page = @mech.get(@uri)
    regpage = @mech.click(page.link_with :text => /Reg.*strate/)
    form = regpage.forms.first
    form.character = user
    form.passwrd = pass
    form.email = email
    form.universe = 'index.php'
    form.raza = race
    form['rgt'] = 'on'	# .rgt does not work (checkboxes don't allow this?)
    form.click_button
  end

  def login(user, pass)
    page = @mech.get(@uri)
    form = page.forms.first
    form.username = user
    form.password = pass
    @home = form.click_button
    update_flights
    update_planets
  end

  def flights
    @flights ||= Flights.new(@mech)
  end

  def update_flights
    @flights ? @flights.update! : @flights = Flights.new(@mech)
  end

  def update_planets
    planet_hash_update!(@mech)
    # remove destroyed planets
    @planets.select! { |p| planet_hash.include? p.coords }
    # add new planets
    allcoords = @planets.map { |p| p.coords }
    planet_hash.each do |coords, info|
      @planets << Planet.new(@mech, coords) unless allcoords.include? coords
    end
    @planets
  end

  def upgradeable_planets(options = {})
    options = {:update => false, :buildings => true, :research => true}.merge options
    if options[:update]
      update_planets
      planets.each { |p| p.update! }
    end
    p = []
    p << upgradeable_planets_by_buildings if options[:buildings]
    p << upgradeable_planets_by_research if options[:research]
    p.flatten.uniq
  end

  [:buildings, :research].each do |list|
    define_method "upgradeable_planets_by_#{list}" do |options = {}|
      options = {:update_planets => false, :update_each => false}.merge options
      update_planets if options[:update_planets]
      # avoid checking continuously options[:update] by defining a lambda for find_all
      upgradeable__ = lambda do |p|
        plist = p.send list
        p unless plist.busy? or plist.upgradeable.empty?
      end
      upgradeable = options[:update_each] ? lambda { |p| p.update!; upgradeable__.call p } : upgradeable__
      planets.find_all &upgradeable
    end
  end

end
