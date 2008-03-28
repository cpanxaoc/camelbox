
# This is CPAN.pm's systemwide configuration file. This file provides
# defaults for users, and the values can be changed in a per-user
# configuration file. The user-config file is being looked for as
# ~/.cpan/CPAN/MyConfig.pm.

$CPAN::Config = {
  'build_cache' => q[10],
  'build_dir' => q[C:\perl\.cpan\build],
  'cache_metadata' => q[1],
  'cpan_home' => q[C:\perl\.cpan],
  'dontload_hash' => {  },
  'ftp' => q[C:\WINDOWS\system32\ftp.EXE],
  'ftp_proxy' => q[],
  'getcwd' => q[cwd],
  'gpg' => q[],
  'gzip' => q[C:\apps\unxutils\usr\local\wbin\gzip.EXE],
  'histfile' => q[C:\perl\.cpan\histfile],
  'histsize' => q[100],
  'http_proxy' => q[],
  'inactivity_timeout' => q[0],
  'index_expire' => q[1],
  'inhibit_startup_message' => q[0],
  'keep_source_where' => q[C:\perl\.cpan\sources],
  'lynx' => q[C:\apps\unxutils\usr\local\wbin\lynx.EXE -cfg=C:\apps\unxutils\usr\local\wbin\lynx.cfg],
  'make' => q[C:\apps\unxutils\dmake\dmake.EXE],
  'make_arg' => q[],
  'make_install_arg' => q[],
  'makepl_arg' => q[],
  'ncftp' => q[],
  'ncftpget' => q[],
  'no_proxy' => q[],
  'pager' => q[C:\apps\unxutils\usr\local\wbin\less.EXE],
  'prerequisites_policy' => q[ask],
  'scan_cache' => q[atstart],
  'shell' => q[],
  'tar' => q[C:\apps\unxutils\usr\local\wbin\tar.EXE],
  'term_is_latin' => q[1],
  'unzip' => q[C:\apps\unxutils\usr\local\wbin\unzip.EXE],
  'urllist' => [q[http://www.perl.com/CPAN/], q[http://mirrors.gossamer-threads.com/CPAN], q[http://mirror.uta.edu/CPAN], q[http://mirror.hyperian.net/CPAN]],
  'wget' => q[],
};
1;
__END__
