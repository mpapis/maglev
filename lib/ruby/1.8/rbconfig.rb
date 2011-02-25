# In other implementation this file gets created by mkconfig.rb when ruby
# is built. It's usually used to describe various settings and other
# information used in the build For more informations refer to pickaxe
# p.183
#
# Various files in the MSpec libs require this Module. At this point it's
# hard coded rather than generated to fulfill the mspec requirement.

# TODO: To get a per-install view of this, without having to generate the
# data each time the vm starts up, we can do the real work, once, when
# prims are loaded, then have rbconfig.rb reference that data.  For right
# now, we'll just calculate each time.

module Config
  RUBY_VERSION == "1.8.7" or
    raise "ruby lib version (1.8.7) doesn't match executable version (#{RUBY_VERSION})"
  VERSION = '1.8'
  ARCH = `uname -m`.chomp

  # Note: MAGLEV_HOME and TOPDIR should end up being the same
  # in a default installation
  MAGLEV_HOME = ENV['MAGLEV_HOME']

  # TODO: MRI puts rbconfig in the architecture specific subdir of
  # .../lib/ruby/1.8/<archdir>/rbconfig.rb
  TOPDIR = File.dirname(__FILE__).chomp!("/lib/ruby/1.8")
  DESTDIR = '' unless defined? DESTDIR

  CONFIG = {}
  CONFIG['prefix']            = MAGLEV_HOME
  CONFIG['exec_prefix']       = MAGLEV_HOME
  CONFIG['bindir']            = File.join(MAGLEV_HOME, 'bin')
  CONFIG['sysconfdir']        = File.join(MAGLEV_HOME, 'etc')
  CONFIG['includedir']        = File.join(MAGLEV_HOME, 'lib/ruby/1.8/include')
  CONFIG['libdir']            = File.join(MAGLEV_HOME, 'lib')

  CONFIG['rubylibdir']        = File.join(CONFIG['libdir'], 'ruby', VERSION)
  CONFIG['archdir']           = File.join(CONFIG['rubylibdir'], ARCH)
  CONFIG['topdir']            = CONFIG['archdir']

  CONFIG['sitedir']           = File.join(CONFIG['libdir'], 'ruby', 'site_ruby')
  CONFIG['sitelibdir']        = File.join(CONFIG['sitedir'], VERSION)
  CONFIG['sitearchdir']       = File.join(CONFIG['sitelibdir'], ARCH)

  CONFIG['DESTDIR']           = DESTDIR

  # CONFIG['sbindir']         = File.join(MAGLEV_HOME, 'sbin')
  # CONFIG['libexecdir']      = File.join(MAGLEV_HOME, 'libexec')
  CONFIG['datadir']           = File.join(MAGLEV_HOME, 'share')
  CONFIG['datarootdir']       = File.join(MAGLEV_HOME, 'share')
  CONFIG['docdir']            = File.join(CONFIG['datarootdir'], 'doc')
  CONFIG['infodir']           = File.join(CONFIG['datarootdir'], 'info')
  CONFIG['htmldir']           = CONFIG['docdir']

  CONFIG['vendordir']         = File.join(CONFIG['libdir'], 'vendor_ruby')
  CONFIG['vendorlibdir']      = File.join(CONFIG['vendordir'], VERSION)
  CONFIG['vendorarchdir']     = File.join(CONFIG['vendorlibdir'], ARCH)

  # TODO SHELL
  # TODO PATH_SEPARATOR
  CONFIG['arch']              = ARCH
  CONFIG['ruby_version']      = '1.8'
  cpu_os = Exception.__cpu_os_kind
  CONFIG['host_os']           = %w( not_used sparc_solaris linux-gnu PowerPC_AIX
                                    darwin9.0 x86_64_solaris Itanium_HP-UX)[ cpu_os  - 1]
  if cpu_os == 7
    CONFIG['DLEXT'] = 'sl' # HPUX
  else
    CONFIG['DLEXT'] = 'so' # other unix
  end

  CONFIG["LN_S"]            = "ln -s"
  CONFIG["SET_MAKE"]        = ""
  CONFIG["INSTALL_PROGRAM"] = "$(INSTALL)"
  CONFIG["INSTALL_SCRIPT"]  = "$(INSTALL)"
  CONFIG["INSTALL_DATA"]    = "$(INSTALL) -m 644"
  CONFIG["RM"]              = "rm -f"
  CONFIG["CP"]              = "cp"
  CONFIG["MAKEDIRS"]        = "mkdir -p"
             
  CONFIG['EXEEXT']            = ''
  CONFIG['LIBEXT']            = 'a'
  CONFIG['OBJEXT']            = 'o'
  CONFIG['ruby_install_name'] = 'maglev-ruby'  # The name of the interpreter executable
  CONFIG['RUBY_INSTALL_NAME'] = CONFIG['ruby_install_name']
  CONFIG['RUBY_SO_NAME']      = CONFIG['ruby_install_name']
  CONFIG['BASERUBY']          = 'ruby'  # MRI ruby used to build maglev-ruby?

  MAKEFILE_CONFIG = CONFIG # Some C extensions require both hashes to be present
  MAKEFILE_CONFIG['CC']             = ENV["CC"] || 'cc '
  MAKEFILE_CONFIG['CPP']            = ENV["CPP"] || 'cc -E '
  MAKEFILE_CONFIG['CXX']            = ENV["CXX"] || 'c++'
  MAKEFILE_CONFIG['CFLAGS']         = ' -fPIC -DTARGET_RT_MAC_CFM=0 -fno-omit-frame-pointer -fno-strict-aliasing -fexceptions $(cflags) '
  MAKEFILE_CONFIG['CPPFLAGS']       = ' -D_XOPEN_SOURCE -D_DARWIN_C_SOURCE $(DEFS) $(cppflags) '
  MAKEFILE_CONFIG['CXXFLAGS']       = MAKEFILE_CONFIG['CFLAGS'] + ' $(cxxflags) '
  MAKEFILE_CONFIG['OUTFLAG']        = ' -o '
  MAKEFILE_CONFIG['COMMON_HEADERS'] = 'ruby.h'
  if CONFIG['host_os'] =~ /darwin/
    MAKEFILE_CONFIG['LDSHARED']     = MAKEFILE_CONFIG["CC"] + ' -dynamic -bundle -undefined dynamic_lookup '
    MAKEFILE_CONFIG['LDFLAGS']      = ' -bundle '
    MAKEFILE_CONFIG['ARCH_FLAG']    = ' -arch x86_64 '
  else
    MAKEFILE_CONFIG['LDSHARED']     = MAKEFILE_CONFIG["CC"] + ' -shared '
    MAKEFILE_CONFIG['LDFLAGS']      = ''
    MAKEFILE_CONFIG['ARCH_FLAG']    = ' -m64 '
  end
  MAKEFILE_CONFIG['LDSHAREDXX']     = MAKEFILE_CONFIG['LDSHARED']

  MAKEFILE_CONFIG['configure_args'] = ''
end

RbConfig = Config
