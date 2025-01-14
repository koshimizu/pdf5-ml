<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet 
Module: Body elements stylesheet
Copyright © 2009-2009 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL    : http://www.antennahouse.com/
E-mail : info@antennahouse.com
****************************************************************
-->
<xsl:stylesheet version="2.0" 
 xmlns:fo="http://www.w3.org/1999/XSL/Format" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 exclude-result-prefixes="xs ahf"
>

    <!-- text is implemented in dita2fo_specializationelements.xsl -->
    <!-- note is implemented in dita2fo_note.xsl -->
    <!-- xref is implemented in dita2fo_xref.xsl -->
    <!-- ol, ul, dl, sl is implemented in dita2fo_list_elements.xsl -->
    
    <!-- 
     function:	div template
     param:	    
     return:	fo:wrapper with its contents
     note:		div is used for only grouping the contents
                It has no intended style
     -->
    <xsl:template match="*[contains(@class, ' topic/div ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsDiv'"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/div ')]">
        <fo:wrapper>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </fo:wrapper>
    </xsl:template>

    <!-- 
     function:	p template
     param:	    
     return:	fo:block with p's contents
     note:		none
     -->
    <xsl:template match="*[contains(@class, ' topic/p ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsP'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/p ')]">
        <fo:block>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <!-- 
     function:	ph template
     param:	    
     return:	fo:inline
     note:      no special formatting
                Call "processPh" for overriding from other plug-ins.
                2015-08-25 t.makita
     -->
    <xsl:template match="*[contains(@class, ' topic/ph ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsPh'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ph ')]">
        <xsl:call-template name="processPh"/>
    </xsl:template>
    
    <xsl:template name="processPh">
        <fo:inline>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    
    <!-- 
     function:    keyword template
     param:
     return:      fo:inline
     note:        no special formatting
                  Call "processKeyword" for easy override from other plug-ins.
                  2015-08-25 t.makita
                  Add DITA-OT generated @href processing.
                  2020-02-12 t.makita
     -->
    <xsl:template match="*[contains(@class, ' topic/keyword ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsKeyword'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/keyword ')]">
        <xsl:call-template name="processKeyword"/>
    </xsl:template>
    
    <xsl:template name="processKeyword">
        <xsl:param name="prmTopicRef" as="element()?" tunnel="yes" required="yes"/>
        <xsl:variable name="href" as="xs:string?" select="string(@href)"/>
        <xsl:variable name="destAttr" as="attribute()*">
            <xsl:choose>
                <xsl:when test="string($href)">
                    <xsl:call-template name="getDestinationAttr">
                        <xsl:with-param name="prmHref" select="$href"/>
                        <xsl:with-param name="prmElem" as="element()" select="."/>
                        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="exists($destAttr)">
                <fo:basic-link>
                    <xsl:call-template name="getAttributeSetWithLang"/>
                    <xsl:call-template name="ahf:getUnivAtts"/>
                    <xsl:copy-of select="$destAttr"/>
                    <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
                    <xsl:apply-templates/>
                </fo:basic-link>
            </xsl:when>
            <xsl:otherwise>
                <fo:inline>
                    <xsl:call-template name="getAttributeSetWithLang"/>
                    <xsl:call-template name="ahf:getUnivAtts"/>
                    <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
                    <xsl:apply-templates/>
                </fo:inline>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

    <!-- 
        function:	Section template
        param:	    
        return:	    Section contents
        note:		Call "processSection" for overriding from other plug-ins.
                    2015-08-25 t.makita
    -->
    <xsl:template match="*[contains(@class, ' topic/section ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsSection'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/section ')]">
        <xsl:call-template name="processSection"/>
    </xsl:template>
    
    <xsl:template name="processSection">
        <fo:block>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <!-- 
        function:	Section title template
        param:	    
        return:	    Section title list
        note:		
    -->
    <xsl:template match="*[contains(@class, ' topic/section ')]/*[contains(@class, ' topic/title ')]" mode="MODE_GET_STYLE" as="xs:string*" priority="2">
        <xsl:sequence select="'atsHeader5Body'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/section ')]/*[contains(@class, ' topic/title ')]" priority="2">
        
        <fo:list-block>
            <xsl:call-template name="getAttributeSetWithLang">
                <xsl:with-param name="prmAttrSetName" select="'atsHeader5List'"/>
            </xsl:call-template>
            <xsl:call-template name="ahf:getIdAtts"/>
            <xsl:call-template name="ahf:getLocalizationAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <fo:list-item>
                <fo:list-item-label end-indent="label-end()">
                    <fo:block>
                        <xsl:call-template name="getAttributeSetWithLang">
                            <xsl:with-param name="prmAttrSetName" select="'atsHeader5Label'"/>
                        </xsl:call-template>
                        <xsl:call-template name="getVarValueWithLang">
                            <xsl:with-param name="prmVarName" select="'Level5_Label_Char'"/>
                        </xsl:call-template>
                    </fo:block>
                </fo:list-item-label>
                <fo:list-item-body start-indent="body-start()">
                    <fo:block>
                        <xsl:call-template name="getAttributeSetWithLang"/>
                        <xsl:apply-templates/>
                    </fo:block>
                </fo:list-item-body>
            </fo:list-item>
        </fo:list-block>
    </xsl:template>
    
    <!-- 
        function:	Sectiondiv template
        param:	    
        return:	    fo:wrapper
        note:		2011-10-27 t.makita
    -->
    <xsl:template match="*[contains(@class, ' topic/sectiondiv ')]" mode="MODE_GET_STYLE" as="xs:string*">
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/sectiondiv ')]">
        
        <fo:wrapper>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </fo:wrapper>
    </xsl:template>
    
    <!-- 
        function:	Example template
        param:	    
        return:	    Example contents
        note:		
    -->
    <xsl:template match="*[contains(@class, ' topic/example ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsExample'"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/example ')]">
        <fo:block>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    
    <!-- 
        function:	Example title template
        param:	    
        return:	    Example title list
        note:		
    -->
    <xsl:template match="*[contains(@class, ' topic/example ')]/*[contains(@class, ' topic/title ')]" mode="MODE_GET_STYLE" as="xs:string*" priority="2">
        <xsl:sequence select="'atsHeader5List'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/example ')]/*[contains(@class, ' topic/title ')]" priority="2">
        
        <fo:list-block>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getIdAtts"/>
            <xsl:call-template name="ahf:getLocalizationAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <fo:list-item>
                <fo:list-item-label end-indent="label-end()">
                    <fo:block>
                        <xsl:call-template name="getAttributeSetWithLang">
                            <xsl:with-param name="prmAttrSetName" select="'atsHeader5Label'"/>
                        </xsl:call-template>
                        <xsl:call-template name="getVarValueWithLang">
                            <xsl:with-param name="prmVarName" select="'Level5_Label_Char'"/>
                        </xsl:call-template>
                    </fo:block>
                </fo:list-item-label>
                <fo:list-item-body start-indent="body-start()">
                    <fo:block>
                        <xsl:call-template name="getAttributeSetWithLang">
                            <xsl:with-param name="prmAttrSetName" select="'atsHeader5Body'"/>
                        </xsl:call-template>
                        <xsl:apply-templates/>
                    </fo:block>
                </fo:list-item-body>
            </fo:list-item>
        </fo:list-block>
    </xsl:template>
        
    
    <!-- 
     function:	fig template
     param:	    
     return:	fo:block
     note:		Generate id attribute for figure list.
     -->
    <xsl:template match="*[contains(@class, ' topic/fig ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsFig'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fig ')]">
        <xsl:variable name="figAttrs" as="attribute()*">
            <xsl:call-template name="getAttributeSetWithLang"/>
        </xsl:variable>
        <fo:block>
            <xsl:copy-of select="$figAttrs"/>
            <xsl:copy-of select="ahf:getDisplayAtts(.,$figAttrs)"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:if test="empty(@id) and child::*[contains(@class, ' topic/title ')]">
                <xsl:call-template name="ahf:generateIdAttr"/>
            </xsl:if>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates select="*[contains(@class,' topic/desc ')]"/>
            <xsl:apply-templates select="*[not(contains(@class,' topic/title '))][not(contains(@class,' topic/desc '))]"/>
        </fo:block>
        <!-- process title last -->
        <xsl:apply-templates select="*[contains(@class,' topic/title ')]"/>
    </xsl:template>
    
    <!-- fig/desc -->
    <xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/desc ')]" mode="MODE_GET_STYLE" as="xs:string*" priority="2">
        <xsl:sequence select="'atsFigDesc'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/desc ')]" priority="2">
        <fo:block>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <!-- fig/title -->
    <xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]" mode="MODE_GET_STYLE" as="xs:string*" priority="2">
        <xsl:sequence select="'atsFigTitle'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]" priority="2">
        <xsl:variable name="figTitlePrefix" as="xs:string">
            <xsl:call-template name="ahf:getFigTitlePrefix">
                <xsl:with-param name="prmFig" select="parent::*[1]"/>
            </xsl:call-template>
        </xsl:variable>
        
        <fo:block>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:value-of select="$figTitlePrefix"/>
            <xsl:text>&#x00A0;</xsl:text>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <!-- 
     function:	figgroup template
     param:	    
     return:	fo:block
     note:		
     -->
    <xsl:template match="*[contains(@class, ' topic/figgroup ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:variable name="isFiggroupInTable" as="xs:boolean" select="exists(ancestor::*[contains(@class,' topic/entry ')])"/>
        <xsl:sequence select="if ($isFiggroupInTable) then 'atsFiggroupInTable' else 'atsFiggroup'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/figgroup ')]">
        <xsl:variable name="figgroup" as="element()" select="."/>
        <xsl:variable name="isLastFiggroup"  as="xs:boolean" select="exists(ancestor::*[contains(@class,' topic/fig ')][(@frame='all') or (@frame='bottom') or (@frame='topbot')]/child::*[position() eq last()]/descendant-or-self::*[contains(@class, ' topic/figgroup ')][. is $figgroup][not(child::*[contains(@class,' topic/title ')])])"/>
        <fo:block>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:if test="$isLastFiggroup">
                <!-- add some spacing -->
                <xsl:call-template name="getAttributeSetWithLang">
                    <xsl:with-param name="prmAttrSetName" select="'atsFiggroupLastSpacing'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
        </fo:block>
        <!-- process title last -->
        <xsl:apply-templates select="*[contains(@class,' topic/title ')]"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/figgroup ')]/*[contains(@class, ' topic/title ')]" mode="MODE_GET_STYLE" as="xs:string*" priority="2">
        <xsl:variable name="isFiggroupInTable" as="xs:boolean" select="exists(ancestor::*[contains(@class,' topic/entry ')])"/>
        <xsl:sequence select="if ($isFiggroupInTable) then 'atsFiggroupTitleInTable' else 'atsFiggroupTitle'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/figgroup ')]/*[contains(@class, ' topic/title ')]" priority="2">
        <xsl:variable name="title" as="element()" select="."/>
        <xsl:variable name="isLastFiggroupTitle" select="exists(ancestor::*[contains(@class,' topic/fig ')][string(@frame) = ('all','bottom','topbot')]/child::*[position()=last()]/descendant::*[contains(@class, ' topic/title ')][. is $title])"/>
        <fo:block>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:if test="$isLastFiggroupTitle">
                <!-- add some spacing -->
                <xsl:copy-of select="ahf:getAttributeSet('atsFiggroupLastTitleSpacing')"/>
            </xsl:if>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <!-- 
     function:	image template
     param:	    
     return:	fo:external-graphic (fo:block)
     note:		Add block/inline specific attribute-set.
                2015-06-04 t.makita
     -->
    <xsl:template match="*[contains(@class, ' topic/image ')]">
        <xsl:choose>
            <xsl:when test="string(@placement) eq 'break'">
                <!-- block level image -->
                <xsl:choose>
                    <xsl:when test="$pAutoScaleDownToFit">
                        <fo:block-container>
                            <fo:block>
                                <xsl:copy-of select="ahf:getAttributeSet('atsImageAutoScallDownToFitBlock')"/>
                                <xsl:copy-of select="ahf:getImageBlockAttr(.)"/>
                                <xsl:call-template name="ahf:processImage"/>
                                <xsl:apply-templates/>
                            </fo:block>
                        </fo:block-container>                    
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block>
                            <xsl:copy-of select="ahf:getImageBlockAttr(.)"/>
                            <xsl:call-template name="ahf:processImage"/>
                            <xsl:apply-templates/>
                        </fo:block>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- inline level image -->
                <xsl:call-template name="ahf:processImage"/>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="ahf:processImage" as="element()*">
        <xsl:param name="prmImage"    required="no" as="element()" select="."/>
        <xsl:choose>
            <xsl:when test="$prmImage/@longdescref">
                <fo:basic-link>
                    <xsl:attribute name="external-destination" select="concat('url(',$prmImage/@longdescref,')')"/>
                    <fo:external-graphic>
                        <xsl:call-template name="ahf:getUnivAtts"/>
                        <xsl:copy-of select="ahf:getImageCommonAttr($prmImage)"/>
                        <xsl:copy-of select="ahf:getFoStyleAndProperty($prmImage)"/>
                    </fo:external-graphic>
                </fo:basic-link>
            </xsl:when>
            <xsl:otherwise>
                <fo:external-graphic>
                    <xsl:call-template name="ahf:getUnivAtts"/>
                    <xsl:copy-of select="ahf:getImageCommonAttr($prmImage)"/>
                    <xsl:copy-of select="ahf:getFoStyleAndProperty($prmImage)"/>
                </fo:external-graphic>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:function name="ahf:getImageUrl" as="xs:string">
        <xsl:param name="prmImage" as="element()"/>
        <xsl:choose>
            <xsl:when test="string($prmImage/@scope) eq 'external'">
                <xsl:sequence select="concat('url(',string($prmImage/@href),')')"/>
            </xsl:when>
            <xsl:when test="$pImageInOutputFolder">
                <xsl:sequence select="concat('url(',string($prmImage/@href),')')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="concat('url(',$pMapDirUrl,string($prmImage/@href),')')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="ahf:getImageCommonAttr" as="attribute()*">
        <xsl:param name="prmImage" as="element()"/>
    
        <xsl:if test="$prmImage/@href">
            <!--xsl:message select="'$prmImage/@href=',string($prmImage/@href)"/>
            <xsl:message select="'$pMapDirUrl=',$pMapDirUrl"/-->
            <xsl:variable name="url" as="xs:string" select="ahf:getImageUrl($prmImage)"/>
            <!--xsl:message select="'$url=',$url"/-->
            <xsl:attribute name="src" select="$url"/>
        </xsl:if>
    
        <xsl:variable name="height" select="ahf:getLength(string($prmImage/@height))"/>
        <xsl:variable name="width"  select="ahf:getLength(string($prmImage/@width))"/>
        <xsl:variable name="scale"  select="normalize-space($prmImage/@scale)"/>
        <xsl:variable name="placement" select="string($prmImage/@placement)"/>
        
        <xsl:choose>
            <xsl:when test="string($width) or string($height)">
                <xsl:if test="string($width)">
                    <xsl:attribute name="content-width" select="$width"/>
                </xsl:if>
                <xsl:if test="string($height)">
                    <xsl:attribute name="content-height" select="$height"/>
                </xsl:if>
                <xsl:if test="string($width) and string($height)">
                    <xsl:attribute name="scaling" select="'non-uniform'"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$placement eq 'break'">
                <xsl:choose>
                    <xsl:when test="string($scale)">
                        <xsl:attribute name="scaling" select="'uniform'"/>
                        <xsl:attribute name="content-width" select="concat(normalize-space($scale),'%')"/>
                    </xsl:when>
                    <xsl:when test="$pAutoScaleDownToFit">
                        <xsl:copy-of select="ahf:getAttributeSet('atsImageAutoScallDownToFit')"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="string($scale)">
                <xsl:attribute name="scaling" select="'uniform'"/>
                <xsl:attribute name="content-width" select="concat(normalize-space($scale),'%')"/>
            </xsl:when>
        </xsl:choose>
        
        <!-- alt -->
        <xsl:if test="$prmImage/*[contains(@class, ' topic/alt ')] and $pMakeAltText">
            <xsl:variable name="altText" as="xs:string">
                <xsl:variable name="tempAltText" as="xs:string*">
                    <xsl:apply-templates select="$prmImage/*[contains(@class, ' topic/alt ')]" mode="TEXT_ONLY"/>
                </xsl:variable>
                <xsl:sequence select="string-join($tempAltText,'')"/>
            </xsl:variable>
            <xsl:attribute name="axf:alttext" select="$altText"/>
        </xsl:if>
        
        <!--inline/block specific attributes -->
        <xsl:call-template name="getAttributeSetWithLang">
            <xsl:with-param name="prmAttrSetName" select="if ($placement eq 'break') then 'atsImageBreak' else 'atsImageInline'"/>
            <xsl:with-param name="prmElem" select="$prmImage"/>
        </xsl:call-template>

    </xsl:function>
    
    <xsl:function name="ahf:getLength" as="xs:string">
        <xsl:param name="prmLen" as="xs:string"/>
        
        <xsl:variable name="lengthStr" select="normalize-space($prmLen)"/>
        <xsl:variable name="unit" select="ahf:getPropertyUnit($lengthStr)"/>
        <xsl:choose>
            <xsl:when test="not(string($prmLen))">
                <xsl:sequence select="''"/>
            </xsl:when>
            <xsl:when test="not(string($unit))">
                <!-- If no unit is specified, adopt "px" -->
                <xsl:sequence select="concat($lengthStr,$cUnitPx)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$lengthStr"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="ahf:getImageBlockAttr" as="attribute()*">
        <xsl:param name="prmImage" as="element()"/>
        <xsl:if test="exists($prmImage/@align)">
            <xsl:variable name="align" as="xs:string" select="string($prmImage/@align)"/>
            <xsl:choose>
                <xsl:when test="$align eq 'left'">
                    <xsl:attribute name="text-align" select="'start'"/>
                </xsl:when>
                <xsl:when test="$align eq 'right'">
                    <xsl:attribute name="text-align" select="'end'"/>
                </xsl:when>
                <xsl:when test="$align eq 'center'">
                    <xsl:attribute name="text-align" select="'center'"/>
                </xsl:when>
                <xsl:when test="$align eq 'current'">
                    <!-- treat as inherited value -->
                    <xsl:attribute name="text-align" select="'inherited-attribute-value(text-align)'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:function>
    
    <!-- 
     function:	alt template
     param:	    
     return:	none
     note:		alt is handled in ahf:getImageCommonAttr
     -->
    <xsl:template match="*[contains(@class, ' topic/alt ')]">
    </xsl:template>
    
    <!-- 
     function:	object template
     param:	    
     return:	none
     note:		Element object is not supported because:
                1. Object without foreign/unknown is for HTML output.
                2. Object with foreign/unkown causes parser error.
                   Content type of foreign is ANY. However this means
                   DITA DTD needs SVG, MathML, etc DTDs.
     -->
    <xsl:template match="*[contains(@class, ' topic/object ')]">
        <xsl:call-template name="warningContinue">
            <xsl:with-param name="prmMes">
                <xsl:value-of select="ahf:replace($stMes041,('%file','%class'),(string(@xtrf),string(@classid)))"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    
    <!-- 
     function:	param template
     param:	    none
     return:	none
     note:		This template will not be activated.
     -->
    <xsl:template match="*[contains(@class, ' topic/param ')]">
    </xsl:template>
    
    <!-- 
     function:	pre template
     param:	    none
     return:	fo:block
     note:		Call "processPre" for overriding from other plug-ins.
                2015-08-25 t.makita
     -->
    <xsl:template match="*[contains(@class, ' topic/pre ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsPre'"/>
    </xsl:template>    
    
    <xsl:template match="*[contains(@class, ' topic/pre ')]">
        <xsl:call-template name="processPre"/>
    </xsl:template>
    
    <xsl:template name="processPre">
        <xsl:variable name="preAttr" as="attribute()*">
            <xsl:call-template name="getAttributeSetWithLang"/>
        </xsl:variable>
        <fo:block>
            <xsl:copy-of select="$preAttr"/>
            <xsl:copy-of select="ahf:getDisplayAtts(.,$preAttr)"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <!-- 
     function:	lines template
     param:	    
     return:	fo:block
     note:		
     -->
    <xsl:template match="*[contains(@class, ' topic/lines ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsLines'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/lines ')]">
        <xsl:variable name="linesAttr" as="attribute()*">
            <xsl:call-template name="getAttributeSetWithLang"/>
        </xsl:variable>
        <fo:block>
            <xsl:copy-of select="$linesAttr"/>
            <xsl:copy-of select="ahf:getDisplayAtts(.,$linesAttr)"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <!-- 
     function:	cite template
     param:	    
     return:	fo:inline
     note:		
     -->
    <xsl:template match="*[contains(@class, ' topic/cite ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsCite'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/cite ')]">
        <xsl:variable name="citePrefix" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'Cite_Prefix'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="citeSuffix" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'Cite_Suffix'"/>
            </xsl:call-template>
        </xsl:variable>
        <fo:inline>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:value-of select="$citePrefix"/>
            <xsl:apply-templates/>
            <xsl:value-of select="$citeSuffix"/>
        </fo:inline>
    </xsl:template>
    
    <!-- 
     function:	lq template
     param:	    
     return:	fo:block
     note:		Different from xref/@href, DITA-OT doesn't do special processing for lq/@href.
                Treate @scope="peer" as external considering DITA-OT standard processing.
                If <longdescref> exists, its attributes precede the attributes of <lq>.
                (2011-10-27 t.makita)
                Change lq/@href processing. Remove fo:basic-link generation temporary. 
                - If it is started by "#", it is a usual id. (DITA-OT 1.8.5 or later)
                - Otherwise it is a raw href. (Until DITA-OT 1.8.4)
                2014-10-29 t.makita
                Fix the fo:basic-link generation by getting the DITA-OT version.
                As DITA-OT doesn't maintain longdescref/@href, it is no longer used.
                2014-11-10 t.makita
     -->
    <xsl:template match="*[contains(@class, ' topic/lq ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsLq'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/lq ')]">
        <xsl:param name="prmTopicRef" tunnel="yes" required="yes"  as="element()?"/>
        <xsl:variable name="longQuoteRef" select="child::*[contains(@class,' topic/longquoteref ')]" as="element()?"/>
        
        <xsl:variable name="type"   select="if (exists($longQuoteRef)) then string($longQuoteRef/@type) else string(@type)" as="xs:string"/>
        <xsl:variable name="scope"  select="if (exists($longQuoteRef)) then string($longQuoteRef/@scope) else string(@scope)" as="xs:string"/>
        <xsl:variable name="format" select="if (exists($longQuoteRef)) then string($longQuoteRef/@format) else string(@format)" as="xs:string"/>
        <xsl:variable name="href" select="if (exists($longQuoteRef)) then string($longQuoteRef/@href) else string(@href)" as="xs:string"/>
        
        <xsl:variable name="prmScope" as="xs:string">
            <xsl:choose>
                <xsl:when test="($format eq 'dita') or ($scope eq 'local')">
                    <xsl:sequence select="'local'"/>
                </xsl:when>
                <xsl:when test="($scope eq 'external') or ($scope eq 'peer')">
                    <xsl:sequence select="'external'"/>
                </xsl:when>
                <xsl:when test="($type eq 'external')">
                    <xsl:sequence select="'external'"/>
                </xsl:when>
                <xsl:when test="($type eq 'internal')">
                    <xsl:sequence select="'local'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="''"/><!-- unknown -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="isOt185OrLater" as="xs:boolean">
            <xsl:variable name="compResult" as="xs:integer?" select="ahf:compareOtVersion($pOtVersion,'1.8.5')"/>
            <xsl:choose>
                <xsl:when test="empty($compResult)">
                    <xsl:sequence select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="not($compResult eq -1)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <fo:block>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
            <xsl:if test="@reftitle">
                <fo:block>
                    <xsl:call-template name="getAttributeSetWithLang">
                        <xsl:with-param name="prmAttrSetName" select="'atsLqRefTitle'"/>
                    </xsl:call-template>
                    <xsl:choose>
                        <xsl:when test="$isOt185OrLater">
                            <xsl:variable name="destAttr" as="attribute()*">
                                <xsl:call-template name="getDestinationAttr">
                                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                                    <xsl:with-param name="prmHref" select="string(@href)"/>
                                    <xsl:with-param name="prmElem" select="."/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="exists($destAttr)">
                                    <fo:basic-link>
                                        <xsl:copy-of select="$destAttr"/>
                                        <xsl:value-of select="@reftitle"/>
                                    </fo:basic-link>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@reftitle"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="string($href)">
                                    <fo:basic-link>
                                        <xsl:copy-of select="ahf:makeBasicLinkDestination($href,$prmScope,.)"/>
                                        <xsl:value-of select="@reftitle"/>
                                    </fo:basic-link>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@reftitle"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </xsl:if>
        </fo:block>
    </xsl:template>
    
    <!-- 
        function:	longquoteref template
        param:	    none
        return:	    none
        note:		Ignore in normal context.
    -->
    <xsl:template match="*[contains(@class, ' topic/longquoteref ')]">
    </xsl:template>
        
    
    <!-- 
     function:    q template
     param:       none
     return:      fo:inline
     note:		
     -->
    <xsl:template match="*[contains(@class, ' topic/q ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsQ'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/q ')]">
        <xsl:variable name="qPrefix" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'Q_Prefix'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="qSuffix" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'Q_Suffix'"/>
            </xsl:call-template>
        </xsl:variable>
        <fo:inline>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:value-of select="$qPrefix"/>
            <xsl:apply-templates/>
            <xsl:value-of select="$qSuffix"/>
        </fo:inline>
    </xsl:template>
    
    <!-- 
        function:	longdescref template
        param:	    none
        return:	    Nothing
        note:		Longdescref is for HTML output. (2011-10-26 t.makita)
    -->
    <xsl:template match="*[contains(@class, ' topic/longdescref ')]">
    </xsl:template>
        
    <!-- 
        function:   draft-comment template
        param:      none
        return:     fo:block
        note:       This template does not support multi-language.
    -->
    <xsl:template match="*[contains(@class, ' topic/draft-comment ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsDraftComment'"/>
    </xsl:template>    
    
    <xsl:template match="*[contains(@class,' topic/draft-comment ')]">
        <xsl:variable name="draftCommentTitlePrefix" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'Draft_Comment_Title_Prefix'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="draftCommentAuthor" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'Draft_Comment_Author'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="draftCommentTime" as="xs:string">
            <xsl:call-template name="getVarValue">
                <xsl:with-param name="prmVarName" select="'Draft_Comment_Time'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="draftCommentDisposition" as="xs:string">
            <xsl:call-template name="getVarValue">
                <xsl:with-param name="prmVarName" select="'Draft_Comment_Disposition'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="draftCommentTitleSuffix" as="xs:string">
            <xsl:call-template name="getVarValue">
                <xsl:with-param name="prmVarName" select="'Draft_Comment_Title_Suffix'"/>
            </xsl:call-template>
        </xsl:variable>
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsDraftComment')"/>
            <xsl:call-template name="ahf:getIdAtts"/>
            <xsl:call-template name="ahf:getLocalizationAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsDraftCommentTitle')"/>
                <xsl:value-of select="$draftCommentTitlePrefix"/>
                <xsl:if test="string(@author)">
                    <xsl:value-of select="$draftCommentAuthor"/>
                    <xsl:value-of select="@author"/>
                </xsl:if>
                <xsl:if test="string(@time)">
                    <xsl:value-of select="$draftCommentTime"/>
                    <xsl:value-of select="@time"/>
                </xsl:if>
                <xsl:if test="string(@disposition)">
                    <xsl:value-of select="$draftCommentDisposition"/>
                    <xsl:value-of select="@disposition"/>
                </xsl:if>
                <xsl:value-of select="$draftCommentTitleSuffix"/>
            </fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
        
    <!-- 
        function:	fn template
        param:      
        return:	    fo:basic-link(fo:footnote)
        note:		BUG-FIX: Don't generate any element if @id exists.
                    2015-05-26 t.makita
    -->
    <xsl:template match="*[contains(@class,' topic/fn ')]">
        <xsl:param name="prmMakeCover" required="no" as="xs:boolean" select="false()"/>
        <xsl:param name="prmGetContent" required="no" tunnel="yes" as="xs:boolean" select="false()"/>
        
        <xsl:variable name="fn" select="."/>
        
        <!-- This stylesheet outputs footnote as postnote -->
        <xsl:choose>
            <xsl:when test="$prmMakeCover"/>
            <xsl:when test="$prmGetContent"/>
            <xsl:when test="@id">
                <xsl:comment>
                    <xsl:text>fn/@id="</xsl:text>
                    <xsl:value-of select="string(@id)"/>
                    <xsl:text>"</xsl:text>
                </xsl:comment>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="fnPrefix" as="xs:string">
                    <xsl:call-template name="ahf:getFootnotePrefix"/>
                </xsl:variable>
                <xsl:variable name="id">
                    <xsl:call-template name="ahf:generateId"/>
                </xsl:variable>
                <xsl:if test="string($id)">
                    <fo:basic-link internal-destination="{$id}">
                        <xsl:copy-of select="ahf:getAttributeSet('atsFnPrefix')"/>
                        <xsl:value-of select="$fnPrefix"/>
                    </fo:basic-link>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
        function:	Generate footnote prefix
        param:		prmFn
        return:	    Footnote title prefix
        note:		If <glossentry> elements contain <fn>, this stylesheet sets 0 to $fnPreviousAmount
                    and count <fn> from the nearest ancestor <glossentry>.
                    This means that fn must be outputted per <glossentry>.
                    2011-10-12 t.makita
    -->
    <xsl:template name="ahf:getFootnotePrefix" as="xs:string">
        <xsl:param name="prmFn" required="no" as="element()" select="."/>
        <xsl:param name="prmTopicRef" tunnel="yes" required="yes" as="element()?"/>
        
        <xsl:variable name="isGlossEntry" as="xs:boolean" select="exists($prmFn/ancestor::*[contains(@class,' glossentry/glossentry ')])"/>
        <xsl:variable name="footnoteTagPrefix" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'Footnote_Tag_Prefix'"/>
                <xsl:with-param name="prmElem" select="$prmFn"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="footnoteTagSuffix" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'Footnote_Tag_Suffix'"/>
                <xsl:with-param name="prmElem" select="$prmFn"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$prmFn/@callout">
                <xsl:sequence select="string($prmFn/@callout)"/>
            </xsl:when>
            <xsl:when test="$pDisplayFnAtEndOfTopic">
                <xsl:variable name="topic" as="element()" select="$prmFn/ancestor::*[contains(@class, ' topic/topic ')][position() eq last()]"/>
                <xsl:variable name="fnPreviousAmount" as="xs:integer">
                    <xsl:variable name="topicId" select="ahf:generateId($topic,$prmTopicRef)"/>
                    <xsl:choose>
                        <xsl:when test="$isGlossEntry">
                            <xsl:sequence select="xs:integer(0)"/>
                        </xsl:when>
                        <xsl:when test="exists($footnoteNumberingMap/descendant::*[string(@id) eq $topicId]/@count)">
                            <xsl:sequence select="xs:integer($footnoteNumberingMap/descendant::*[string(@id) eq $topicId]/@prev-count)"/>        
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="xs:integer(0)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="fnCurrentAmount" as="xs:integer">
                    <xsl:variable name="parentTopic" select="$prmFn/ancestor::*[contains(@class, ' topic/topic ')][1]"/>
                    <xsl:choose>
                        <xsl:when test="$isGlossEntry">
                            <xsl:sequence select="count($parentTopic//*[contains(@class,' topic/fn ')][not(contains(@class,' pr-d/synnote '))][not(@callout)][. &lt;&lt; $prmFn]|$prmFn)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="count($topic//*[contains(@class,' topic/fn ')][not(contains(@class,' pr-d/synnote '))][not(@callout)][. &lt;&lt; $prmFn]|$prmFn)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="fnNumber" select="$fnPreviousAmount + $fnCurrentAmount" as="xs:integer"/>
                <xsl:sequence select="concat($footnoteTagPrefix,string($fnNumber),$footnoteTagSuffix)"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- THe order to get parent of footnote:
                     1. glossdef
                     2. table (tgroup, desc)
                     3. simpletable
                     4. lists (ol, ul, dl)
                 -->
                <xsl:variable name="ancestorTopic"  select="$prmFn/ancestor::*[contains(@class, ' topic/topic ')][1]" as="element()"/>
                <xsl:variable name="parentElements" as="element()*">
                    <xsl:choose>
                        <xsl:when test="$prmFn/ancestor::*[contains(@class, ' glossentry/glossdef ')]">
                            <xsl:sequence select="$prmFn/ancestor::*[contains(@class, ' glossentry/glossdef ')][1]"/>
                        </xsl:when>
                        <xsl:when test="$prmFn/ancestor::*[contains(@class, ' topic/tgroup ')][. &gt;&gt; $ancestorTopic][position() eq last()]">
                            <xsl:variable name="tgroup" as="element()" select="$prmFn/ancestor::*[contains(@class, ' topic/tgroup ')][. &gt;&gt; $ancestorTopic][position() eq last()]"/>
                            <xsl:if test="$tgroup is $tgroup/parent::*[contains(@class,' topic/table ')]/*[contains(@class, ' topic/tgroup ')][1]">
                                <xsl:sequence select="$tgroup/parent::*[contains(@class,' topic/table ')]/*[contains(@class, ' topic/desc ')]"/>
                            </xsl:if>
                            <xsl:sequence select="$tgroup"/>
                        </xsl:when>
                        <xsl:when test="$prmFn/ancestor::*[contains(@class, ' topic/desc ')][parent::*[contains(@class,' topic/table ')]][. &gt;&gt; $ancestorTopic][position() eq last()]">
                            <xsl:variable name="desc" as="element()" select="$prmFn/ancestor::*[contains(@class, ' topic/desc ')][parent::*[contains(@class,' topic/table ')]][. &gt;&gt; $ancestorTopic][position() eq last()]"/>
                            <xsl:sequence select="$desc"/>
                            <xsl:sequence select="$desc/parent::*[contains(@class,' topic/table ')]/*[contains(@class,' topic/tgroup ')][1]"/>
                        </xsl:when>
                        <xsl:when test="$prmFn/ancestor::*[contains(@class, ' topic/simpletable ')][. &gt;&gt; $ancestorTopic][position() eq last()]">
                            <xsl:sequence select="$prmFn/ancestor::*[contains(@class, ' topic/simpletable ')][. &gt;&gt; $ancestorTopic][position() eq last()]"/>
                        </xsl:when>
                        <xsl:when test="$prmFn/ancestor::*[ahf:seqContains(@class, (' topic/ul ',' topic/ol ',' topic/dl '))][. &gt;&gt; $ancestorTopic][position() eq last()]">
                            <xsl:sequence select="$prmFn/ancestor::*[ahf:seqContains(@class, (' topic/ul ',' topic/ol ',' topic/dl '))][. &gt;&gt; $ancestorTopic][position() eq last()]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="empty($parentElements)">
                        <!-- This case is error because <fn> does not have relevant parent element. -->
                        <xsl:variable name="fnContent" select="if (string-length(string($prmFn)) le 20) then string($prmFn) else concat(substring($prmFn,1,20),'...')"/>
                        <xsl:call-template name="warningContinue">
                            <xsl:with-param name="prmMes" select="ahf:replace($stMes037,('%cont','%file'),($fnContent,string($prmFn/@xtrf)))"/>
                        </xsl:call-template>
                        <xsl:sequence select="''"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="fnNumber" as="xs:integer" select="ahf:getFootnoteNumber($prmFn,$parentElements)"/>
                        <xsl:sequence select="concat($footnoteTagPrefix,string($fnNumber),$footnoteTagSuffix)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="ahf:getFootnotePrefix" as="xs:string">
        <xsl:param name="prmFn" as="element()"/>
        <xsl:param name="prmTopicRef" as="element()"/>
        
        <xsl:call-template name="ahf:getFootnotePrefix">
            <xsl:with-param name="prmFn" select="$prmFn"/>
            <xsl:with-param name="prmTopicRef" tunnel="yes" select="$prmTopicRef"/>
        </xsl:call-template>
    </xsl:function>
    
    <!-- 
        function:    Generate footnote prefix from given parent element
        param:       prmFn, prmParentElem
        return:      Footnote title prefix
        note:        Used to generate prefix when outputting footonote.
    -->
    <xsl:function name="ahf:getFootnotePrefix2" as="xs:string">
        <xsl:param name="prmFn" as="element()"/>
        <xsl:param name="prmParentElem" as="element()+"/>
    
        <xsl:choose>
            <xsl:when test="$prmFn/@callout">
                <xsl:sequence select="string($prmFn/@callout)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="fnNumber" as="xs:string" select="string(ahf:getFootnoteNumber($prmFn, $prmParentElem))"/>
                <xsl:variable name="footnoteTagPrefix" as="xs:string">
                    <xsl:call-template name="getVarValueWithLang">
                        <xsl:with-param name="prmVarName" select="'Footnote_Tag_Prefix'"/>
                        <xsl:with-param name="prmElem" select="$prmFn"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="footnoteTagSuffix" as="xs:string">
                    <xsl:call-template name="getVarValueWithLang">
                        <xsl:with-param name="prmVarName" select="'Footnote_Tag_Suffix'"/>
                        <xsl:with-param name="prmElem" select="$prmFn"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:sequence select="concat($footnoteTagPrefix,$fnNumber,$footnoteTagSuffix)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
        
    <!-- 
        function:    Get footonote number from parent element
        param:       prmFn, prmParentElem
        return:      footnote number
        note:        Sometimes $prmParentElement is composed of <desc>, <tgroup>
    -->
    <xsl:function name="ahf:getFootnoteNumber" as="xs:integer">
        <xsl:param name="prmFn" as="element()"/>
        <xsl:param name="prmParentElem" as="element()+"/>
        <xsl:variable name="fnNumbers" as="xs:integer+">
            <xsl:for-each select="$prmParentElem">
                <xsl:variable name="parent" as="element()" select="."/>
                <xsl:sequence select="count((if ($prmFn/ancestor::*[. is $parent]) then $prmFn else (),$parent//*[contains(@class,' topic/fn ')][not(contains(@class,' pr-d/synnote '))][not(@callout)][. &lt;&lt; $prmFn]))"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="fnNumber" as="xs:integer" select="sum($fnNumbers)"/>
        <xsl:sequence select="$fnNumber"/>
    </xsl:function>

    <!-- 
        function:    term template
        param:	    
        return:      fo:inline
        note:        Call "processTerm" for overriding from other plug-ins.
                     2015-08-25 t.makita
                     Add DITA-OT generated @href processing.
                     2020-02-12 t.makita
    -->
    <xsl:template match="*[contains(@class, ' topic/term ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsTerm'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class,' topic/term ')]">
        <xsl:call-template name="processTerm"/>
    </xsl:template>
    
    <xsl:template name="processTerm">
        <xsl:param name="prmTopicRef" as="element()?" tunnel="yes" required="yes"/>
        <xsl:variable name="href" as="xs:string?" select="string(@href)"/>
        <xsl:variable name="destAttr" as="attribute()*">
            <xsl:choose>
                <xsl:when test="string($href)">
                    <xsl:call-template name="getDestinationAttr">
                        <xsl:with-param name="prmHref" select="$href"/>
                        <xsl:with-param name="prmElem" as="element()" select="."/>
                        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="exists($destAttr)">
                <fo:basic-link>
                    <xsl:call-template name="getAttributeSetWithLang"/>
                    <xsl:call-template name="ahf:getUnivAtts"/>
                    <xsl:copy-of select="$destAttr"/>
                    <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
                    <xsl:apply-templates/>
                </fo:basic-link>
            </xsl:when>
            <xsl:otherwise>
                <fo:inline>
                    <xsl:call-template name="getAttributeSetWithLang"/>
                    <xsl:call-template name="ahf:getUnivAtts"/>
                    <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
                    <xsl:apply-templates/>
                </fo:inline>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
        function:    text template
        param:	    
        return:      fo:wrapper
        note:        Text is only a container for text.
                     Generate a fo:wrapper. (2011-10-27 t.makita)
    -->
    <xsl:template match="*[contains(@class,' topic/text ')]">
        <fo:wrapper>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </fo:wrapper>
    </xsl:template>
    
    <!-- 
        function:	tm
        param:      
        return:	  fo:inline
        note:		none
    -->
    <xsl:template match="*[contains(@class, ' topic/tm ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsTm'"/>
    </xsl:template>    
    
    <xsl:template match="*[contains(@class,' topic/tm ')]">
        <fo:inline>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
            <fo:inline>
                <xsl:call-template name="getAttributeSetWithLang">
                    <xsl:with-param name="prmAttrSetName" select="'atsTmSymbol'"/>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="string(@tmtype) eq 'tm'">
                        <xsl:variable name="tmSymbolTm" as="xs:string">
                            <xsl:call-template name="getVarValueWithLang">
                                <xsl:with-param name="prmVarName" select="'Tm_Symbol_Tm'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$tmSymbolTm"/>
                    </xsl:when>
                    <xsl:when test="string(@tmtype) eq 'reg'">
                        <xsl:variable name="tmSymbolReg" as="xs:string">
                            <xsl:call-template name="getVarValueWithLang">
                                <xsl:with-param name="prmVarName" select="'Tm_Symbol_Reg'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$tmSymbolReg"/>
                    </xsl:when>
                    <xsl:when test="string(@tmtype) eq 'service'">
                        <xsl:variable name="tmSymbolService" as="xs:string">
                            <xsl:call-template name="getVarValueWithLang">
                                <xsl:with-param name="prmVarName" select="'Tm_Symbol_Service'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:call-template name="getAttributeSetWithLang">
                            <xsl:with-param name="prmAttrSetName" select="'atsTmSymbolSm'"/>
                        </xsl:call-template>
                        <xsl:value-of select="$tmSymbolService"/>
                    </xsl:when>
                </xsl:choose>
            </fo:inline>
        </fo:inline>
    </xsl:template>
        
    
    <!-- ========================
          Common templates
         ======================== -->
    <!-- 
     function:	Make fo:basic-link attribute external-destination/internal-destination
     param:		prmHref, prmScope
     return:	attribute()*
     note:		
     -->
    <xsl:function name="ahf:makeBasicLinkDestination" as="attribute()*">
        <xsl:param name="prmHref" as="xs:string"/>
        <xsl:param name="prmScope" as="xs:string"/>
        <xsl:param name="prmElement" as="element()"/>
        
        <xsl:choose>
            <xsl:when test="($prmScope='external')
                         or (contains($prmHref,'://'))
                         or (starts-with($prmHref,'/'))
                         or (matches($prmHref,'^[a-zA-Z]:\\'))">
                <!-- external link -->
                <xsl:variable name="isLinkToPdf" select="matches(lower-case($prmHref),'\.pdf#')"/>
                <xsl:choose>
                    <xsl:when test="$isLinkToPdf">
                        <xsl:variable name="modifiedHref" select="replace($prmHref,'(\.PDF#|\.pdf#)','$1nameddest=')"/>
                        <xsl:attribute name="external-destination" select="concat('url(', $modifiedHref, ')')"/>
                        <xsl:attribute name="axf:action-type" select="'gotor'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="external-destination" select="concat('url(', $prmHref, ')')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- Internal link -->
                <!-- DITA-OT 1.5.2 BUG 3138354: DITA-OT doesn't rewite lq/@href
                     Following code is a temporary solution, (Use 'topicByOid')
                     2010/12/16 t.makita
                 -->
                <xsl:variable name="destElementId" 
                              select="substring-after(substring-after($prmHref,'#'),'/')" 
                              as="xs:string"/>
                <xsl:variable name="topicId" 
                              select="if (string($destElementId)) then substring-before(substring-after($prmHref,'#'), '/') else (substring-after($prmHref,'#'))" 
                              as="xs:string"/>
                <xsl:variable name="topicElement" 
                              select="key('topicByOid', $topicId, $root)[1]" 
                              as="element()?"/>
                <xsl:variable name="destElement" 
                              select="if (exists($topicElement)) then key('elementById',$destElementId,$topicElement)[1] else ()" 
                              as="element()?"/>
                <xsl:choose>
                    <!-- link to local element in the topic -->
                    <xsl:when test="exists($destElement)">
                        <xsl:variable name="destIdAtr" select="ahf:getIdAtts($destElement,(),true())" as="attribute()*"/>
                        <xsl:attribute name="internal-destination" select="string($destIdAtr[1])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- link to topic -->
                        <xsl:if test="empty($topicElement)">
                            <xsl:call-template name="errorExit">
                                <xsl:with-param name="prmMes"
                                                select="ahf:replace($stMes074,('%href','%file', '%element'),($prmHref,string($prmElement/@xtrf), name($prmElement)))"/>
                            </xsl:call-template>
                        </xsl:if>
                        <!-- get topic's id -->
                        <xsl:variable name="topicIdAtr" select="ahf:getIdAtts($topicElement,(),true())" as="attribute()*"/>
                        <xsl:attribute name="internal-destination" select="string($topicIdAtr[1])"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
     function:  Generate fig title prefix
     param:     prmTopicRef, prmFig
     return:    Table title prefix string
     note:      Count outer-most fig only not to count imagemap in fig.
                Image map has a @class="+ topic/fig ut-d/imagemap".
                2020-03-22 t.makita
     -->
    <xsl:template name="ahf:getFigTitlePrefix" as="xs:string">
        <xsl:param name="prmTopicRef" tunnel="yes" required="yes" as="element()?"/>
        <xsl:param name="prmFig" required="no" as="element()" select="."/>
        
        <xsl:variable name="titlePrefix" as="xs:string">
            <xsl:choose>
                <xsl:when test="$pAddNumberingTitlePrefix">
                    <xsl:variable name="figureGroupingLevelMax" as="xs:integer" select="ahf:getFigureNumberingGroupLevel($prmTopicRef)"/>
                    <xsl:variable name="titlePrefixPart" as="xs:string" select="ahf:genLevelTitlePrefixByCount($prmTopicRef,$figureGroupingLevelMax)"/>
                    <xsl:choose>
                        <xsl:when test="string($titlePrefixPart)">
                            <xsl:sequence select="concat($titlePrefixPart,$cTitleSeparator)"/>        
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="$titlePrefixPart"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="topic" as="element()" select="$prmFig/ancestor::*[contains(@class, ' topic/topic ')][position()=last()]"/>
        
        <xsl:variable name="figPreviousAmount" as="xs:integer">
            <xsl:sequence select="ahf:getFigPreviousAmount($topic,$prmTopicRef)"/>
        </xsl:variable>
        
        <xsl:variable name="figCurrentAmount" as="xs:integer">
            <xsl:sequence select="count($topic//*[contains(@class,' topic/fig ')][exists(*[contains(@class,' topic/title ')])][empty(ancestor::*[contains(@class,' topic/fig ')])][not(ahf:isFloatFigure(.))][. &lt;&lt; $prmFig]|$prmFig)"/>
        </xsl:variable>
        <xsl:variable name="figNumber" select="$figPreviousAmount + $figCurrentAmount" as="xs:integer"/>
        
        <xsl:sequence select="concat($cFigureTitle,$titlePrefix,string($figNumber))"/>
    </xsl:template>

    <xsl:function name="ahf:getFigTitlePrefix" as="xs:string">
        <xsl:param name="prmTopicRef" as="element()"/>
        <xsl:param name="prmFig" as="element()"/>
    
        <xsl:call-template name="ahf:getFigTitlePrefix">
            <xsl:with-param name="prmTopicRef" tunnel="yes" select="$prmTopicRef"/>
            <xsl:with-param name="prmFig" select="$prmFig"/>
        </xsl:call-template>
    </xsl:function>

</xsl:stylesheet>