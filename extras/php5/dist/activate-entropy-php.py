#!/usr/bin/env python

import os
import sys

prefix = '{prefix}'


# Create symlink to Apache conf file snippet which loads the PHP module.
# Different places for the symlink in Mac OS X Client / Server
#
httpd_conf_path = prefix + '/entropy-php.conf'

httpd_conf_symlink = '/etc/apache2/other/+entropy-php.conf'

if os.system("test -h " + httpd_conf_symlink):
	os.symlink(httpd_conf_path, httpd_conf_symlink)
	
# Activate default php.ini and pear.conf files if they don't exist.
# This prevents upgrade installs of the packge from clobbering local modifications
os.system("cd " + prefix + "/lib && test -e php.ini || cp php.ini-recommended php.ini")
os.system("cd " + prefix + "/etc && test -e pear.conf || cp pear.conf.default pear.conf")

result = os.system("apachectl restart") >> 8
sys.exit(result)

