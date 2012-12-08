<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<!-- http://www.ibm.com/developerworks/xml/library/x-tipmultxsl.html -->
<!-- 
In general, run cmdstart.bat to open a shell that is ready for either python or java/saxon commands.

To install Python:
This will work with either standard or cmdstart.bat shells invoked.
1. Download and run latest Windows Python installer (*.msi)
2. Add the python path to the %path% variable: set %path%;C:\Python26
3. Open a command shell and enter python \-\-help to test the installation.

To convert rst files into docutils XML:
This will work with either standard or cmdstart.bat shells invoked.
1. Copy your rst source files into the docutils directory which you previously placed in the DITA OT root folder.
2. cd into the docutils directory
3. Run the tools/rst2xml.py tool to convert each rst file into well-formed XML:
C:\DITA-OT1.5.2\docutils>python tools/rst2xml.py \-\-help
Usage
=====
  rst2xml.py [options] [<source> [<destination>]]

To convert well-formed docutils XML files into DITA maps and topics:
This will work only with the cmdstart.bat shell invoked.
1. Navigate your file explorer to the DITA OT directory
2. Double-click on startcmd.bat to open up a prepared DOT shell environment
3. cd into the docutils directory
4. Execute the docutils XML to DITA transform:
C:\DITA-OT1.5.2\docutils>java net.sf.saxon.Transform
  -s:result_rst2xml-help.xml
  -xsl:xsl/docutils2map.xsl
  -o:my_result_rst2xml-help.ditamap
  C:\DITA-OT1.5.2\docutils>java net.sf.saxon.Transform -s:result_montecristo.xml -xsl:xsl/docutils2map.xsl -o:my_result_montecristo.ditamap
-->

<!-- this declaration applies to the map that is implicit in the document being parsed -->
<xsl:output method="xml" indent="yes"
	doctype-public="-//OASIS//DTD DITA Map//EN"
	doctype-system="../dtd/map.dtd"/>

<!-- generic topic -->
<xsl:output method="xml" indent="yes" name="dita-topic"
	doctype-public="-//OASIS//DTD DITA Topic//EN"
	doctype-system="../dtd/topic.dtd"/>

<!-- concept -->
<xsl:output method="xml" indent="yes" name="dita-concept"
	doctype-public="-//OASIS//DTD DITA Concept//EN"
	doctype-system="../dtd/concept.dtd"/>

<!-- task -->
<xsl:output method="xml" indent="yes" name="dita-task"
	doctype-public="-//OASIS//DTD DITA Task//EN"
	doctype-system="../dtd/task.dtd"/>

<!-- reference -->
<xsl:output method="xml" indent="yes" name="dita-reference"
	doctype-public="-//OASIS//DTD DITA Reference//EN"
	doctype-system="../dtd/reference.dtd"/>

<!-- overrideable parameters -->
<xsl:param name="outdir" select="output-demo"/>

<!--
	<xsl:for-each select="//document|//section|//topic">
	</xsl:for-each>
-->

<xsl:template match="/">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="document">
<map> <!-- need fallthrough logic to capture topicref tree structure; this generates a flat manifest -->
	<!-- conforming docutils document is like a DITA concept; any section will be terminated by the end of the document.
	     Therefore we can use a for-each loop to scoop up sections once the fallthrough for document is done.
	-->
	<xsl:variable name="navtitle"><xsl:value-of select="child::title"/></xsl:variable>
	<!-- use the first of any multiple @ids values as the topicid and evantual filename -->
	<xsl:variable name="topicid"><xsl:value-of select="tokenize(@ids,' ')[1]"/></xsl:variable>
	<xsl:variable name="type"><xsl:value-of select="name()"/></xsl:variable>
	<!-- pass the directory value into this string as an overrideable parameter -->
	<xsl:variable name="filename" select="concat('output3/concept_',$topicid,'.dita')" />
	<!-- create map entry -->
	<topicref href="{$filename}" navtitle="{$navtitle}">
		<!-- Create topic chunks -->
		<xsl:result-document href="{$filename}" format="dita-concept">
			<concept id="{$topicid}">
				<title><xsl:value-of select="$navtitle"/></title>
				<prolog>
					<metadata>
						<othermeta name="type" content="{$type}"/>
					</metadata>
				</prolog>
				<conbody>
					<xsl:apply-templates/> <!-- use modes on sections to reserve them for next step -->
				</conbody>
				<!-- Note: to properly depect nesting child topics, the section loop should be here. -->
			</concept>
		</xsl:result-document>
	</topicref>
	<xsl:comment>topicrefs after this point are children of the above topicref</xsl:comment>
	<!-- now collection sections as proper child topics -->
	<xsl:for-each select="//section|//topic">
		<xsl:variable name="navtitle"><xsl:value-of select="child::title"/></xsl:variable>
		<!-- use the first of any multiple @ids values as the topicid and evantual filename -->
		<xsl:variable name="topicid"><xsl:value-of select="tokenize(@ids,' ')[1]"/></xsl:variable>
		<xsl:variable name="type"><xsl:value-of select="name()"/></xsl:variable>
		<!-- pass the directory value into this string as an overrideable parameter -->
		<xsl:variable name="filename" select="concat('output3/topic_',$topicid,'.dita')" />
		<!-- create map entry -->
		<topicref href="{$filename}" navtitle="{$navtitle}">
			<!-- Create topic chunks; select format based on analyzed infotype, if possible (use  -->
			<xsl:result-document href="{$filename}" format="dita-topic">
				<topic id="{$topicid}" outputclass="{$type}">
					<title><xsl:value-of select="$navtitle"/></title>
					<prolog>
						<metadata>
							<othermeta name="Generator" content="docutils2DITA migration process"/>
						</metadata>
					</prolog>
					<body>
						<xsl:apply-templates/>
					</body>
				</topic>
			</xsl:result-document>
		</topicref>
	</xsl:for-each>
</map>
</xsl:template>

<xsl:template match="topic">
		<xsl:variable name="navtitle"><xsl:value-of select="child::title"/></xsl:variable>
		<!-- use the first of any multiple @ids values as the topicid and evantual filename -->
		<xsl:variable name="topicid"><xsl:value-of select="tokenize(@ids,' ')[1]"/></xsl:variable>
		<xsl:variable name="type"><xsl:value-of select="name()"/></xsl:variable>
		<!-- pass the directory value into this string as an overrideable parameter -->
		<xsl:variable name="filename" select="concat('output3/topic_',$topicid,'.dita')" />
		<!-- create map entry -->
		<topicref href="{$filename}" navtitle="{$navtitle}">
			<!-- Create topic chunks; select format based on analyzed infotype, if possible (use  -->
			<xsl:result-document href="{$filename}" format="dita-topic">
				<topic id="{$topicid}" outputclass="{$type}">
					<title><xsl:value-of select="$navtitle"/></title>
					<prolog>
						<metadata>
							<othermeta name="Generator" content="docutils2DITA migration process"/>
						</metadata>
					</prolog>
					<body>
						<xsl:apply-templates/>
					</body>
				</topic>
			</xsl:result-document>
		</topicref>
</xsl:template>

<xsl:template match="section">
<!-- Note that rst parsing generates a target element for each section by default (in effect, its own docid for xrefing to) -->
</xsl:template>

<xsl:template match="document/title|section/title|topic/title">
</xsl:template>


<!-- blocks -->

<xsl:template match="paragraph">
	<p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="block_quote">
	<lq><xsl:apply-templates/></lq>
</xsl:template>

<xsl:template match="literal_block">
	<pre><xsl:apply-templates/></pre>
</xsl:template>

<xsl:template match="comment">
	<xsl:comment><xsl:apply-templates/></xsl:comment>
</xsl:template>

<xsl:template match="note">
	<note><xsl:apply-templates/></note>
</xsl:template>
  

<xsl:template match="system_message/paragraph[1]">
</xsl:template>
  
<xsl:template match="system_message">
	<xsl:variable name="sysmsg"><xsl:value-of select="paragraph[1]"/></xsl:variable>
	<!-- parse sysmsg into quoted part and preceding message. -->
	<xsl:variable name="msg">
		<xsl:value-of select="substring-before($sysmsg,' &quot;')"/>
	</xsl:variable>
	<xsl:variable name="remap">
		<xsl:analyze-string select="$sysmsg" regex='("[^"]*")+'>			<xsl:matching-substring>
				<xsl:value-of select="translate(.,'&quot;','')"/>			</xsl:matching-substring>		</xsl:analyze-string>
	</xsl:variable>
	<!-- case msg of: "Unknown interpreted text role" -->
	  <!-- &remap contains the only data for whatever processing you do next -->
	<!-- case msg of: "Unknown directive type" -->
	  <!-- the rest of the content takes specific processing based on type -->
	<xsl:choose>
		<xsl:when test='$remap="code_block"'>
			<codeblock><xsl:apply-templates/></codeblock>
		</xsl:when>
		<xsl:when test='$remap="code"'>
			<codeblock><xsl:apply-templates/></codeblock>
		</xsl:when>
		<xsl:when test='$remap="snippet"'>
			<pre><xsl:apply-templates/></pre>
		</xsl:when>
		<xsl:when test='$remap="math"'>
			<foreign outputclass="math"><xsl:apply-templates/></foreign>
		</xsl:when>
		<xsl:when test='$remap="graph"'>
			<foreign outputclass="graph"><xsl:apply-templates/></foreign>
		</xsl:when>
		<xsl:when test='$remap="piechart"'>
			<foreign outputclass="piechart"><xsl:apply-templates/></foreign>
		</xsl:when>
		<xsl:when test='$remap="book"'>
			<cite outputclass="math"><xsl:apply-templates/></cite>
		</xsl:when>
		<xsl:otherwise>
			<xsl:message>Required cleanup, <xsl:value-of select="$msg"/>: <xsl:value-of select="$remap"/></xsl:message>
			<required-cleanup remap="{$remap}"><xsl:apply-templates/></required-cleanup>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="problematic">
	<required-cleanup><b>problematic: </b><xsl:apply-templates/></required-cleanup>
</xsl:template>


<!-- lists and data structures -->

<xsl:template match="option_list">
	<simpletable outputclass="option_list">
		<xsl:apply-templates/>
	</simpletable>
</xsl:template>

<xsl:template match="option_list_item">
	<strow>
		<xsl:apply-templates/>
	</strow>
</xsl:template>

<xsl:template match="option_group">
	<stentry>
		<xsl:apply-templates/>
	</stentry>
</xsl:template>

<xsl:template match="description">
	<stentry>
		<xsl:apply-templates/>
	</stentry>
</xsl:template>

<xsl:template match="option">
	<synph>
		<xsl:apply-templates/>
	</synph>
	<xsl:if test="position()!=last()">, </xsl:if>
</xsl:template>

<xsl:template match="option_string">
	<kwd>
		<xsl:apply-templates/>
	</kwd>
</xsl:template>

<xsl:template match="option_argument">
	<xsl:if test="@delimiter">
		<delim>
		  	<xsl:value-of select="@delimiter"/>
	  	</delim>
	</xsl:if>
	<var>
		<xsl:apply-templates/>
	</var>
</xsl:template>



<xsl:template match="bullet_list">
	<ul>
		<xsl:apply-templates/>
	</ul>
</xsl:template>

<xsl:template match="list_item">
	<li>
		<xsl:apply-templates/>
	</li>
</xsl:template>

<xsl:template match="enumerated_list">
	<ol>
		<xsl:apply-templates/>
	</ol>
</xsl:template>


<xsl:template match="field_list">
	<dl outputclass="field_list">
		<xsl:apply-templates/>
	</dl>
</xsl:template>

<xsl:template match="field">
	<dlentry>
		<xsl:apply-templates/>
	</dlentry>
</xsl:template>

<xsl:template match="field_name">
	<dt>
		<xsl:apply-templates/>
	</dt>
</xsl:template>

<xsl:template match="field_body">
	<dd>
		<xsl:apply-templates/>
	</dd>
</xsl:template>


<xsl:template match="definition_list">
	<dl outputclass="definition_list">
		<xsl:apply-templates/>
	</dl>
</xsl:template>

<xsl:template match="definition_list_item">
	<dlentry>
		<xsl:apply-templates/>
	</dlentry>
</xsl:template>

<xsl:template match="term">
	<dt>
		<xsl:apply-templates/>
	</dt>
</xsl:template>

<xsl:template match="definition">
	<dd>
		<xsl:apply-templates/>
	</dd>
</xsl:template>


<!-- refs -->

<xsl:template match="reference">
	<xref href="{@refuri}" scope="external"><xsl:apply-templates/></xref>
</xsl:template>

<xsl:template match="footnote_reference">
	<xref href="{@refuri}" outputclass="footnote_reference"><xsl:apply-templates/></xref>
</xsl:template>

<xsl:template match="citation_reference">
	<xref href="{@refuri}" outputclass="citation_reference"><xsl:apply-templates/></xref>
</xsl:template>

<xsl:template match="reference[@refname]">
	<xref href="{@refuri}" outputclass="reference-refname"><xsl:value-of select="@refname"/>: <xsl:apply-templates/></xref>
</xsl:template>

<xsl:template match="title_reference">
	<xref href="{@refuri}" outputclass="title_reference"><xsl:apply-templates/></xref>
</xsl:template>

<xsl:template match="substitution_reference">
	<xref href="{@refuri}" outputclass="substitution_reference"><xsl:apply-templates/></xref>
</xsl:template>

<xsl:template match="target">
	<xsl:comment>target:
	 id=<xsl:value-of select="@id"/>
	 name=<xsl:value-of select="@name"/>
	 refuri=<xsl:value-of select="@refuri"/>
	 </xsl:comment>
</xsl:template>


<!-- inlines -->

<xsl:template match="strong">
	<b>
	  <xsl:apply-templates/>
	</b>
</xsl:template>

<xsl:template match="emphasis">
	<i>
	  <xsl:apply-templates/>
	</i>
</xsl:template>

<xsl:template match="abbreviation">
	<keyword outputclass="abbreviation">
	  <xsl:apply-templates/>
	</keyword>
</xsl:template>

<xsl:template match="acronym">
	<keyword outputclass="acronym">
	  <xsl:apply-templates/>
	</keyword>
</xsl:template>

<xsl:template match="subscript">
	<sub>
	  <xsl:apply-templates/>
	</sub>
</xsl:template>

<xsl:template match="superscript">
	<sup>
	  <xsl:apply-templates/>
	</sup>
</xsl:template>

<xsl:template match="inline">
	<keyword outputclass="inline">
	  <xsl:apply-templates/>
	</keyword>
</xsl:template>

<xsl:template match="literal"><!-- analogous to an "inline pre"; no data semantic -->
	<tt>
	  <xsl:apply-templates/>
	</tt>
</xsl:template>



</xsl:stylesheet>
