# this is kind of a hack to include page navigation capabilities to classes

module PageNavigation
  def update!
    update_page!
    parse
  end

  def page
    @page || update_page!
  end

  def lastupdate
    @lastupdate
  end

  def go_to!
    planet.go_to! if planet
    @page = go_to
  end

  private

  def update_page!
    # we are being requested to reload our page.
    # first off, let's make sure we are in the correct planet and/or page
    go_to!
    # update the last access time and return the page
    @lastupdate = Time.now
    @page
  end

  def parse(nokodoc = page.parser)
    raise 'Includers of PageNavigation should define a parse(nokodoc) method!'
  end

  def planet
    # you must override this method should this resource be loaded from a planet
    nil
  end

  # fallback go_to method reloads the current page
  def go_to
    @mech.get(@mech.current_page.uri)
  end
end
