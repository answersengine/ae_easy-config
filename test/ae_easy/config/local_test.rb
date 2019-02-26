require 'test_helper'

describe 'local' do
  describe 'unit test' do
    it 'should load a YAML file' do
      data = AeEasy::Config::Local.load_file './test/input/config.yaml'
      expected = {
        'my_config' => {
          'sublevel' => {
            'collection' => [
              {'item_a' => 'A', 'aaa' => '111'},
              {'item_b' => 'B', 'bbb' => '222'},
              {'item_c' => 'C', 'ccc' => 333}
            ],
            'hash' => {
              'ddd' => 444,
              'eee' => 'EEE'
            }
          },
          'value_f' => 'fff'
        }
      }
      assert_equal expected, data
    end

    it 'should get root keys from index' do
      config = AeEasy::Config::Local.new file_path: './test/input/config.yaml'
      data = config['my_config']
      expected = {
        'sublevel' => {
          'collection' => [
            {'item_a' => 'A', 'aaa' => '111'},
            {'item_b' => 'B', 'bbb' => '222'},
            {'item_c' => 'C', 'ccc' => 333}
          ],
          'hash' => {
            'ddd' => 444,
            'eee' => 'EEE'
          }
        },
        'value_f' => 'fff'
      }
      assert_equal expected, data
    end

    describe 'with config file' do
      before do
        @temp_file = Tempfile.new(['config', '.yaml'], './tmp', encoding: 'UTF-8')
        @temp_file.puts "my_config:"
        @temp_file.puts "  hash:"
        @temp_file.puts "    ddd: 444"
        @temp_file.puts "    eee: EEE"
        @temp_file.puts "  value_f: 'fff'"
        @temp_file.flush
        @expected_orig = {
          'my_config' => {
            'hash' => {
              'ddd' => 444,
              'eee' => 'EEE'
            },
            'value_f' => 'fff'
          }
        }
        AeEasy::Config::Local.clear_cache
      end

      after do
        @temp_file.unlink
      end

      it 'should clear cache' do
        data_orig = AeEasy::Config::Local.load_file @temp_file
        assert_equal @expected_orig, data_orig
        @temp_file.puts 'ggg: 777'
        @temp_file.flush
        data_cached = AeEasy::Config::Local.load_file @temp_file
        assert_equal @expected_orig, data_cached
        AeEasy::Config::Local.clear_cache
        data_new = AeEasy::Config::Local.load_file @temp_file
        refute_equal @expected_orig, data_new
        expected = {'ggg' => 777}.merge @expected_orig
        assert_equal expected, data_new
      end

      it 'should save cache' do
        data_orig = AeEasy::Config::Local.load_file @temp_file
        assert_equal @expected_orig, data_orig
        @temp_file.puts 'ggg: 777'
        @temp_file.flush
        data_new = AeEasy::Config::Local.load_file @temp_file
        assert_equal @expected_orig, data_new
      end

      it 'should force load' do
        data_orig = AeEasy::Config::Local.load_file @temp_file
        assert_equal @expected_orig, data_orig
        @temp_file.puts 'ggg: 777'
        @temp_file.flush
        data_new = AeEasy::Config::Local.load_file @temp_file, force: true
        refute_equal @expected_orig, data_new
        expected = {'ggg' => 777}.merge @expected_orig
        assert_equal expected, data_new
      end

      it 'should force load' do
        config = AeEasy::Config::Local.new file_path: @temp_file
        data_orig = config.local
        assert_equal @expected_orig, data_orig
        @temp_file.puts 'ggg: 777'
        @temp_file.flush
        data_cached = config.local
        assert_equal @expected_orig, data_cached
        config.reload
        data_new = config.local
        refute_equal @expected_orig, data_new
        expected = {'ggg' => 777}.merge @expected_orig
        assert_equal expected, data_new
      end

      it 'should convert to hash' do
        config = AeEasy::Config::Local.new file_path: @temp_file
        data = config.to_h
        assert_equal @expected_orig, data
      end
    end
  end
end
