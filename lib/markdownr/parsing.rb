require 'vfmd'
require 'unmarkdown'

module Markdownr
  module Parsing
    module_function

    def markdown(text, options = {})
      return '' unless text and text.length > 0

      document = Vfmd::VfmdDocument.new()
      document.setContent(text)

      outputByteArray = Vfmd::VfmdByteArray.new()
      htmlRenderer = Vfmd::HtmlRenderer.new()
      htmlRenderer.setOutputDevice(Vfmd::VfmdBufferOutputDevice.new(outputByteArray))
      htmlRenderer.render(document.parseTree())

      return outputByteArray.toString().strip()
    end

    def unmarkdown(html)
      Unmarkdown.parse(html, allow_scripts: true, fenced_code_blocks: true)
    end
  end
end
