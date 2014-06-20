require 'sinatra'

module Markdownr
  class Application < Sinatra::Application
    include Parsing

    DEFAULT_MARKDOWN = "### vfmd dingus\n" +
                       "\n" +
                       "This is a demo for the [vfmd]\n" +
                       "Markdown parser.\n" +
                       "\n" +
                       "You can type in Markdown on the\n" +
                       "left and see it parsed and rendered\n" +
                       "by [vfmd] on the right.\n" +
                       "\n" +
                       "This demo is a fork of [Markdownr]\n" +
                       "by Sam [Soff.es], modified\n" +
                       "to use *vfmd* as the Markdown parser\n" +
                       "(instead of *Redcarpet*).\n" +
                       "\n" +
                       "[vfmd]: http://www.vfmd.org/\n" +
                       "[Soff.es]: http://soff.es/\n" +
                       "[Markdownr]: http://markdownr.com/\n"
                       .freeze()

    DEFAULT_HTML = Parsing.markdown(DEFAULT_MARKDOWN).freeze

    # Homepage
    get '/' do
      erb :home
    end

    # API Docs
    get '/api/?' do
      erb :api
    end

    # API
    post '/api/v1/convert' do
      body = request.body.read
      unless body && body.length > 0
        status 400
        return 'You must post content to be converted.'
      end

      # I couldn't figure out the built-in accept stuff, so here we go.
      accepts = env['HTTP_ACCEPT'].split(',').map do |item|
        item = item.strip.sub(/^(.*)(;.+)$/, "\1")
      end
      content_type = env['CONTENT_TYPE']

      # Preliminary checks
      if accepts.include?('text/x-markdown')
        status 400
        return 'markdownr.vfmd.org does not convert HTML to Markdown.'
      end

      unless content_type.include?('text/x-markdown')
        status 400
        return 'You must post `text/x-markdown`.'
      end

      # Markdown -> HTML
      if accepts.include?('text/html')
        headers 'Content-Type' => 'text/html; charset=utf8'
        return markdown(body)
      end

      # Markdown -> text (parse tree)
      if accepts.include?('text/plain')
        headers 'Content-Type' => 'text/plain; charset=utf8'
        return markdown(body, parse_tree: true)
      end

      status 406
      'You must explicitly accept `text/x-markdown` or `text/plain`.'
    end

  end
end
