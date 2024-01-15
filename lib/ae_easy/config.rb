require 'dh_easy/config'
require 'ae_easy/core'

DhEasy::Config::Local.default_file_path_list.insert(0, 'ae_easy.yml')
DhEasy::Config::Local.default_file_path_list.insert(0, 'ae_easy.yaml')

# (Deprecated) Alias to DhEasy module.
AeEasy = ::DhEasy unless defined? ::AeEasy
