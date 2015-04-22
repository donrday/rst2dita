========
rst2dita
========

Migrate reStructuredText documents into DITA maps and topics via the Python rst2xml process

(Worth noting, now there is also this separate project, `rst2dita roundtrip <https://github.com/mgcalo/rst2dita/>`, which includes a topic-to-rst transform.)

==========
Background
==========

*To a writer whose only tool is a flat text editor, formatted text is the next best thing to a real DITA editor.*

This project extends an initial proof of concept pilot which was documented at http://learningbywrote.com/blog/2011/04/creating-dita-topics-using-restructuredtext/


About reStructuredText
----------------------
reStructuredText is a well-documented example of the family of intuitive markup styles known as 
`lightweight markup <http://en.wikipedia.org/wiki/Lightweight_markup_language>`_ (which includes various wikitext dialects).

Popular examples of lightweight markup include the `MediaWiki <http://en.wikipedia.org/wiki/MediaWiki>`_, Eclipse-based `Mylyn <http://www.eclipse.org/mylyn/>`_, and `Creole <http://en.wikipedia.org/wiki/Creole_(markup)>`_ wikitext styles and their particular tools. DITA converters exist for some of these, notably for the `Mylyn project <http://help.eclipse.org/helios/index.jsp?topic=/org.eclipse.mylyn.wikitext.help.ui/help/Markup-Conversion.html>`_.

reStructuredText (also called rst or sometimes--conflicting with 'RESTful' API usage--reST) is popular in the Python programming community and has gained a recent boost in visibility by being recognized as a strategic markup strategy for materials in the Gutenberg Project. The part that appealed most to me about rst as a format is that the Python docutils toolkit includes a parser that generates an XML representation of the fully normalized document structure. **Having an XML representation of a lightweight markup makes the subsequent migration as DITA vastly simpler and more reliable.**

Process
-------

Posts created using popular markdown syntaxes are typically created in a flat text editor, typically supported by a "live-rendering" view that gives visual feedback and integrated help (for example, see `Online reStructuredText editor <http://rst.ninjs.org/>`_).

With content in hand, use the rst2xml.py Python tool to generate an intermediate xml representation. This is then converted into a DITA map and related subtopics using a set of XSLT transforms. 

License
-------
Originally contributed by Don R. Day with the intention of the package being compliant with the DITA Open Toolkit suite of tools and plugins. Therefore the Apache Software License 2.0 shall apply to files in this repository.
