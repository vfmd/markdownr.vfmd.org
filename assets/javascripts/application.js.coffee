
HtmlDisplay =
  noHtml: 0
  richText: 1
  rawHtml: 2

OutputType =
  htmlOutput: 1
  parseTreeOutput: 2

$ ->
  form = $('form#notepad_form')
  notepad = $('textarea#notepad')
  output = $('div#output')
  raw_output = $('textarea#raw-output')
  richtext_switch = $('a#richtext-switch')
  rawhtml_switch = $('a#rawhtml-switch')
  parsetree_switch = $('a#parsetree-switch')
  loading = $('div#loading')

  last_markdown = notepad.val();
  last_html_display = HtmlDisplay.richText;
  last_output_type = OutputType.htmlOutput;
  current_output_type = OutputType.htmlOutput;

  # Process markdown
  process = ->
    markdown = notepad.val()
    return if markdown == last_markdown && current_output_type == last_output_type
    switch current_output_type
      when OutputType.htmlOutput
        convert_vfmd(markdown, current_output_type, 'text/html', 'html')
      when OutputType.parseTreeOutput
        convert_vfmd(markdown, current_output_type, 'text/plain', 'text')
    last_markdown = markdown
    last_output_type = current_output_type

  convert_vfmd = (text, outputType, accept, reply_type) ->
    loading.show()
    jQuery.ajax(
      url: form.attr('action')
      data: text
      type: 'POST'
      headers:
        'Content-Type': 'text/x-markdown'
        'Accept': accept
      dataType: reply_type
    ).done (data) ->
      if outputType == OutputType.htmlOutput
        output.html(data)
      raw_output.val(data)
      loading.hide()

  # Toggle output
  show_output = (outputType, htmlDisplay) ->
    return if last_html_display == htmlDisplay
    if last_output_type != outputType
      current_output_type = outputType
      process()
    if outputType == OutputType.htmlOutput
      if htmlDisplay == HtmlDisplay.richText
        activate_output_switch(richtext_switch)
        output.show()
        raw_output.hide()
      else if htmlDisplay == HtmlDisplay.rawHtml
        activate_output_switch(rawhtml_switch)
        output.hide()
        raw_output.show()
    else if outputType == OutputType.parseTreeOutput
      activate_output_switch(parsetree_switch)
      output.hide()
      raw_output.show()
    last_output_type = outputType
    last_html_display = htmlDisplay

  activate_output_switch = (sw) ->
    for s in [richtext_switch, rawhtml_switch, parsetree_switch]
      if s == sw
        s.addClass('active')
      else
        s.removeClass('active')
    sw.blur()

  # Add event for keyup and focus
  notepad.keyup(process)
  notepad.focus()

  # Add event for toggle link
  richtext_switch.click ->
    show_output(OutputType.htmlOutput, HtmlDisplay.richText)
  rawhtml_switch.click ->
    show_output(OutputType.htmlOutput, HtmlDisplay.rawHtml)
  parsetree_switch.click ->
    show_output(OutputType.parseTreeOutput, HtmlDisplay.noHtml)
