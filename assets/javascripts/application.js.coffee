
HtmlDisplay =
  richText: 1
  rawHtml: 2

$ ->
  form = $('form#notepad_form')
  notepad = $('textarea#notepad')
  output = $('div#output')
  html_output = $('textarea#html-output')
  richtext_switch = $('a#richtext-switch')
  rawhtml_switch = $('a#rawhtml-switch')
  loading = $('div#loading')

  last_markdown = notepad.val();
  last_html_display = HtmlDisplay.richText;

  # Process markdown
  process = ->
    markdown = notepad.val()
    return if markdown == last_markdown
    loading.show()
    jQuery.ajax(
      url: form.attr('action')
      data: markdown
      type: 'POST'
      headers:
        'Content-Type': 'text/x-markdown'
        'Accept': 'text/html'
      dataType: 'html'
    ).done (data) ->
      output.html(data)
      html_output.val(data)
      loading.hide()
      last_markdown = markdown

  # Toggle output
  show_output = (htmlDisplay) ->
    return if last_html_display == htmlDisplay
    if htmlDisplay == HtmlDisplay.richText
      activate_output_switch(richtext_switch)
      output.show()
      html_output.hide()
    else if htmlDisplay == HtmlDisplay.rawHtml
      activate_output_switch(rawhtml_switch)
      output.hide()
      html_output.show()
    last_html_display = htmlDisplay

  activate_output_switch = (sw) ->
    for s in [richtext_switch, rawhtml_switch]
      if s == sw
        s.addClass('active')
      else
        s.removeClass('active')
    sw.blur()

  # Add event for keyup and focus
  notepad.keyup(process)
  notepad.focus()

  # Add event for toggle link
  # toggle_output.click(toggle)
  rawhtml_switch.click ->
    show_output(HtmlDisplay.rawHtml)
  richtext_switch.click ->
    show_output(HtmlDisplay.richText)
