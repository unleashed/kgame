require 'mechanize'

module Browser
  Browser = Mechanize

  def self.new
    Browser.new do |ag|
      ag.user_agent = UserAgent.get
      # Mechanize defaults to remember EVERYTHING in its history => mem hog!
      ag.max_history = 1
    end
  end

  module UserAgent
    USERAGENTS = [
      'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_7_1; es-es) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1',
      'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.872.0 Safari/535.2',
      'Mozilla/5.0 (compatible; Konqueror/2.2.2; Linux 2.4.14-xfs; X11; i686)',
      'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.0.1) Gecko/20030306 Camino/0.7',
      'Mozilla/5.0 (Windows; U; Win98; es-ES; rv:0.9.2) Gecko/20010726 Netscape6/6.1',
      'Mozilla/5.0 (Windows; U; Windows NT 5.1; es-ES) AppleWebKit/525.19 (KHTML, like Gecko) Chrome/0.2.153.1 Safari/525.19',
      'Mozilla/5.0 (X11; U; Linux i686; es-ES; rv:1.7.6) Gecko/20050405 Epiphany/1.6.1',
      'Mozilla/5.0 (X11; U; Linux i686; es-ES; rv:1.8.1.1) Gecko/20061205 Iceweasel/2.0.0.1',
      'Mozilla/5.0 (BlackBerry; U; BlackBerry 9850; es-ES) AppleWebKit/534.11+ (KHTML, like Gecko) Version/7.0.0.115 Mobile Safari/534.11+',
      'Mozilla/5.0 (SymbianOS/9.4; Series60/5.0 NokiaC6-00/20.0.042; Profile/MIDP-2.1 Configuration/CLDC-1.1; zh-hk) AppleWebKit/525 (KHTML, like Gecko) BrowserNG/7.2.6.9 3gpp-gba',
      'Mozilla/5.0 (X11; U; Linux armv7l; pt-PT; rv:1.9.2.3pre) Gecko/20100723 Firefox/3.5 Maemo Browser 1.7.4.8 RX-51 N900',
      'Mozilla/5.0 (Linux; U; Android 2.3.4; es-es; HTC Desire Build/GRJ22) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
      'Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0)',
      'Mozilla/5.0 (Maemo; Linux armv7l; rv:6.0a1) Gecko/20110526 Firefox/6.0a1 Fennec/6.0a1',
      'Mozilla/5.0 (X11; U; OpenBSD macppc; rv:1.8.1) Gecko/20070222 Minimo/0.016',
      'Opera/9.80 (J2ME/MIDP; Opera Mini/9.80 (S60; SymbOS; Opera Mobi/23.348; U; en) Presto/2.5.25 Version/10.54',
      'Opera/9.80 (Android 2.3.4; Linux; Opera Mobi/build-1107180945; U; es-ES) Presto/2.8.149 Version/11.10',
      'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_7; es-es) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Safari/530.17 Skyfire/2.0',
      'Mozilla/5.0 (PLAYSTATION 3; 3.55)',
      'Mozilla/5.0 (Windows NT 5.2; rv:7.0a1) Gecko/20110622 SeaMonkey/2.4a1',
      'Mozilla/5.0 (X11; FreeBSD amd64; rv:7.0a1) Gecko/20110622 SeaMonkey/2.4a1',
      'Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_5_7; es-es) AppleWebKit/530.19.2 (KHTML, like Gecko) Version/4.0.1 Safari/530.18',
      'Mozilla/5.0 (Windows; U; Win 9x 4.90; SG; rv:1.9.2.4) Gecko/20101104 Netscape/9.1.0285',
      'Mozilla/5.0 (compatible; Konqueror/4.5; FreeBSD) KHTML/4.5.4 (like Gecko)',
      'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)',
      'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; Media Center PC 6.0; InfoPath.3; MS-RTC LM 8; Zune 4.7)',
      'Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20100101 Firefox/5.0 Iceweasel/5.0',
      'Mozilla/5.0 (X11; U; Linux x86_64; es-ES) AppleWebKit/534.7 (KHTML, like Gecko) Epiphany/2.30.6 Safari/534.7',
      'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0a2) Gecko/20110613 Firefox/6.0a2',
      'Mozilla/5.0 (X11; Linux i686) AppleWebKit/535.1 (KHTML, like Gecko) Ubuntu/11.04 Chromium/14.0.825.0 Chrome/14.0.825.0 Safari/535.1',
      'Opera/9.80 (Windows NT 6.1; U; es-ES) Presto/2.9.181 Version/12.00'
    ]

    def self.get(index = nil)
      index ? USERAGENTS[index] : USERAGENTS[rand(USERAGENTS.size)]
    end
  end

end
