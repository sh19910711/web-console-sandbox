lib = File.expand_path('../vendor/web-console/lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sinatra/base'
require 'mruby_sandbox'
require 'json'
require 'web_console/context'

class App < Sinatra::Base
  get '/' do
    slim :index
  end

  post '/eval' do
    begin
      output = mrb.eval(params[:input])
      { msg: 'ok', output: output }.to_json
    rescue StandardError => e
      { msg: 'error', error: e }.to_json
    end
  end

  private

    def mrb
      $mrb ||= new_mrb
    end

    def new_mrb
      MrubySandbox::MrubySandbox.new
    end
end

run App
