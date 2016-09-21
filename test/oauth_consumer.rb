require 'rubygems'
require 'sinatra'
require 'omniauth'
require 'omniauth-deviantart'

configure do
  set :sessions, true
  set :inline_templates, true
end

use OmniAuth::Builder do
  provider(
    :deviantart, 5230, '0dde8517b7c8881437d965e815f59c97',
    scope: 'browse user user.manage note feed gallery browse.mlt collection comment.post message stash publish')
end

get '/' do
  erb "<a href='/auth/deviantart'>Login with deviantART</a><br>"
end

get '/auth/:provider/callback' do
  result = request.env['omniauth.auth']
  open('test/output_pipe', 'w') do |f|
    f.write(JSON.pretty_generate(result))
  end
  erb "<a href='/'>Top</a><br>
       <h1>#{params[:provider]}</h1>
       <pre>#{JSON.pretty_generate(result)}</pre>"
end

Thread.new do
  named_pipe = File.open('test/output_pipe', 'r')
  named_pipe.size
  sleep 1
  exit 0
end
