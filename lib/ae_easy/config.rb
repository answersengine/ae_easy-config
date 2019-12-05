require 'dh_easy/config'
require 'ae_easy/core'

DhEasy::Config::Local.default_file_path_list << 'ae_easy.yaml'
DhEasy::Config::Local.default_file_path_list << 'ae_easy.yml'

# (Deprecated) Alias to DhEasy module.
AeEasy = ::DhEasy unless defined? ::AeEasy
