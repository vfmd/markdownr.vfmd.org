# vfmd Markdownr

[vfmd Markdownr] is a simple website for trying out the [vfmd] Markdown parser.

[vfmd Markdownr] is a fork of [Markdownr.com] by Sam [Soff.es]. The original
[Markdownr.com] uses [Redcarpet] to parse markdown input, while [vfmd Markdownr]
uses (what else) [vfmd].

The server code is written in Ruby, and the [vfmd parser] is written in C++, with
the interfacing managed through [SWIG]. Whenever the text changes, the text is sent
to the server and the result is fetched and displayed.

[vfmd Markdownr]: http://markdownr.vfmd.org/
[vfmd]: http://www.vfmd.org/
[Soff.es]: http://soff.es/
[Redcarpet]: http://github.com/vmg/redcarpet
[Markdownr.com]: http://markdownr.com/
[vfmd parser]: http://github.com/vfmd/vfmd-src/
[SWIG]: http://www.swig.org/
