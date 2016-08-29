<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#">

  <xsl:output method="html"/>
  <xsl:variable name="about" select="/rdf:RDF/rdf:Description[1]/@rdf:about"/>
  <xsl:variable name="title" select="/rdf:RDF/rdf:Description[1]/dcterms:title"/>
  <xsl:variable name="comment" select="/rdf:RDF/rdf:Description[1]/rdfs:comment"/>
  <xsl:variable name="modified" select="/rdf:RDF/rdf:Description[1]/dcterms:modified"/>
  <xsl:variable name="publisher" select="/rdf:RDF/rdf:Description[1]/dcterms:publisher/@rdf:resource"/>
  <xsl:variable name="seeAlso" select="/rdf:RDF/rdf:Description[1]/rdfs:seeAlso/@rdf:resource"/>
  <xsl:variable name="versionInfo" select="/rdf:RDF/rdf:Description/owl:versionInfo"/>
  <xsl:template match="/rdf:RDF">
    <html>
      <head>
        <title>
          <xsl:value-of select="$title"/>
        </title>
        <style>
          body { width: 80%; margin: 0 auto; }
          header { text-align: center; }
          h1 { font-size: 2em; }
          h2 { font-size: 1.7em; }
          h3 { font-size: 1.4em; }
          h4 { margin-bottom: 0.25em; }
          body { font-family: sans-serif; background: url(assets/cream_pixels.png);}
          table { width: 100%; margin: 15px 0; border-collapse: collapse; }
          tr { border: 1px solid #ccc; }
          th { background-color: #ddd; padding: 5px; font-size: 120%; text-align:center; font-weight: bold; }
          td { vertical-align: top; padding: 5px; border: 1px solid #ccc; }
          td:first-child { width: 150px; font-weight: bold; white-space: nowrap; }
          tr.about td:nth-child(2) { font-size: 120%; font-family: monospace; }
        </style>
      </head>
      <body>
        <header>
          <img src="assets/Islandora.png"/>
          <h1>
            <xsl:value-of select="$title"/>
          </h1>
          <table>
            <tr class="about">
              <td>Namespace</td>
              <td>
                <xsl:value-of select="$about"/>
              </td>
            </tr>
            <xsl:if test="not($comment = '')">
              <tr class="comment">
                <td>Description</td>
                <td>
                  <xsl:value-of select="$comment"/>
                </td>
              </tr>
            </xsl:if>
            <xsl:if test="not($versionInfo = '')">
              <tr class="version">
                <td>Version</td>
                <td>
                  <xsl:value-of select="$versionInfo"/>
                </td>
              </tr>
            </xsl:if>
            <xsl:if test="not($modified = '')">
              <tr>
                <td>Last Modified</td>
                <td>
                  <xsl:value-of select="$modified"/>
                </td>
              </tr>
            </xsl:if>
            <xsl:if test="$publisher != ''">
              <tr>
                <td>Published by</td>
                <td>
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="$publisher"/>
                    </xsl:attribute>
                    <xsl:value-of select="$publisher"/>
                  </a>
                </td>
              </tr>
            </xsl:if>
            <xsl:if test="$seeAlso != ''">
              <tr>
                <td>See Also</td>
                <td>
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="$seeAlso"/>
                    </xsl:attribute>
                    <xsl:value-of select="$seeAlso"/>
                  </a>
                </td>
              </tr>
            </xsl:if>
          </table>
        </header>
        <!-- table of contents -->
        <div class="table-of-contents">
          <h2>Table of Contents</h2>
          <xsl:for-each select="/rdf:RDF/rdfs:Class">
            <xsl:sort select="@rdf:about"/>
            <xsl:if test="position() = 1">
              <h3>Classes</h3>
            </xsl:if>
            <xsl:call-template name="toc-entry"/>
          </xsl:for-each>
          <xsl:for-each select="/rdf:RDF/rdf:Property">
            <xsl:sort select="@rdf:about"/>
            <xsl:if test="position() = 1">
              <h3>Properties</h3>
            </xsl:if>
            <xsl:call-template name="toc-entry"/>
          </xsl:for-each>
        </div>
        <!-- class list -->
        <div class="contents">
          <h2>Entity Definitions</h2>
          <xsl:for-each select="/rdf:RDF/rdfs:Class">
            <xsl:sort select="@rdf:about"/>
            <xsl:if test="position() = 1">
              <h3>Classes</h3>
            </xsl:if>
            <xsl:call-template name="main-entry"/>
          </xsl:for-each>
          <!-- properties list -->
          <xsl:for-each select="/rdf:RDF/rdf:Property">
            <xsl:sort select="@rdf:about"/>
            <xsl:if test="position() = 1">
              <h3>Properties</h3>
            </xsl:if>
            <xsl:call-template name="main-entry"/>
          </xsl:for-each>
        </div>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="display-uri">
    <xsl:param name="label"/>
    <xsl:param name="uri"/>
    <xsl:variable name="name">
      <xsl:choose>
        <xsl:when test="/*/namespace::*[starts-with($uri,.)]">
          <xsl:for-each select="/*/namespace::*">
            <xsl:if test="starts-with($uri,.)"><xsl:value-of select="name()"/>:<xsl:value-of select="substring-after($uri,.)"/></xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$uri"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$uri != ''">
      <li>
        <xsl:value-of select="$label"/>
        <xsl:text>: </xsl:text>
        <a href="$uri">
          <xsl:value-of select="$name"/>
        </a>
      </li>
    </xsl:if>
  </xsl:template>
  <xsl:template name="toc-entry">
    <xsl:variable name="id">
      <xsl:value-of select="substring-after(@rdf:about,$about)"/>
    </xsl:variable>
    <xsl:if test="$id != ''">
      <a href="#{$id}">
        <xsl:value-of select="$id"/>
      </a>
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>
  <xsl:template name="main-entry">
    <xsl:variable name="id">
      <xsl:value-of select="substring-after(@rdf:about,$about)"/>
    </xsl:variable>
    <xsl:if test="$id != ''">
      <div id="{$id}">
        <table>
          <tr>
            <th colspan="2" id="{$id}">
              <xsl:value-of select="$id"/>
            </th>
          </tr>
          <tr class="label">
            <td>Label</td>
            <td>
              <xsl:value-of select="rdfs:label"/>
            </td>
          </tr>
          <xsl:if test="rdfs:comment != ''">
            <tr class="comment">
              <td>Description</td>
              <td>
                <xsl:value-of select="rdfs:comment"/>
              </td>
            </tr>
          </xsl:if>
          <xsl:if test="rdfs:subClassOf/@rdf:resource">
            <xsl:call-template name="display-uri">
              <xsl:with-param name="label">Subclass of</xsl:with-param>
              <xsl:with-param name="uri" select="rdfs:subClassOf/@rdf:resource"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="rdfs:subPropertyOf/@rdf:resource">
            <xsl:call-template name="display-uri">
              <xsl:with-param name="label">Subproperty of</xsl:with-param>
              <xsl:with-param name="uri" select="rdfs:subPropertyOf/@rdf:resource"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="rdfs:domain/@rdf:resource">
            <xsl:call-template name="display-uri">
              <xsl:with-param name="label">Domain</xsl:with-param>
              <xsl:with-param name="uri" select="rdfs:domain/@rdf:resource"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="rdfs:range/@rdf:resource">
            <tr class="range">
              <td>Range</td>
              <td>
                <a href="{rdfs:range/@rdf:resource}">xsd:<xsl:value-of select="substring-after(rdfs:range/@rdf:resource,'#')"/></a>
              </td>
            </tr>
          </xsl:if>
          <xsl:if test="skos:exactMatch/@rdf:resource">
            <tr class="skos">
              <td>Exact match</td>
              <td>
                <a href="{skos:exactMatch/@rdf:resource}">
                  <xsl:value-of select="skos:exactMatch/@rdf:resource"/>
                </a>
              </td>
            </tr>
          </xsl:if>
          <xsl:if test="skos:closeMatch/@rdf:resource">
            <tr class="skos">
              <td>Close match</td>
              <td>
                <a href="{skos:closeMatch/@rdf:resource}">
                  <xsl:value-of select="skos:closeMatch/@rdf:resource"/>
                </a>
              </td>
            </tr>
          </xsl:if>
        </table>
      </div>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
