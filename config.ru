$:.push('/Users/johny/.rvm/gems/ruby-1.9.2-p290@3.1/gems/rack-1.3.0/lib/')
$:.push('/Users/johny/.rvm/gems/ruby-1.9.2-p290@3.1/gems/rack-legacy-0.2.0/lib/')
$:.push('/Users/johny/.rvm/gems/ruby-1.9.2-p290@3.1/gems/rack-rewrite-1.0.2/lib/')

require 'rack'
require 'rack-legacy'
require 'rack-rewrite'

INDEXES = ['index.html','index.php', 'index.cgi']

use Rack::Rewrite do
  rewrite %r{(.*/$)}, lambda {|match, rack_env|
    to_return = rack_env['PATH_INFO']
    INDEXES.each do |index|
      if File.exists?(File.join(Dir.getwd, rack_env['PATH_INFO'], index))
        to_return = rack_env['PATH_INFO'] + index
      end
    end
    
    to_return
  }
end

use Rack::Legacy::Php, Dir.getwd
use Rack::Legacy::Cgi, Dir.getwd
run Rack::File.new Dir.getwd
