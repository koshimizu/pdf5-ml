<?xml version='1.0' encoding="UTF-8" ?>
<!--
    ****************************************************************
    DITA to XSL-FO Stylesheet
    Module: Table templates
    Copyright © 2009-2019 Antenna House, Inc. All rights reserved.
    Antenna House is a trademark of Antenna House, Inc.
    URL    : http://www.antennahouse.com/
    E-mail : info@antennahouse.com
    ****************************************************************
-->
<xsl:stylesheet version="2.0" 
 xmlns:fo="http://www.w3.org/1999/XSL/Format" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 xmlns:ahs="http://www.antennahouse.com/names/XSLT/Document/Layout"
 exclude-result-prefixes="xs ahf ahs"
>
    <!-- **************************** 
            Table Templates
         ****************************-->
    
    <!-- Class name of fo:retrieve-table-marker to insert continued word to fo:table-header-->
    <xsl:variable name="mcTableHeaderContinuedWord" as="xs:string" select="'mcTableHeaderContinuedWord'"/>
    <!-- Class name of fo:retrieve-table-marker to insert table/desc to fo:table-header-->
    <xsl:variable name="mcTableHeaderTableDesc" as="xs:string" select="'mcTableHeaderTableDesc'"/>
    <!-- Class name of fo:retrieve-table-marker to insert continued word to fo:table-footer -->
    <xsl:variable name="mcTableFooterContinuedWord" as="xs:string" select="'mcTableFooterContinuedWord'"/>
    
    <!-- @outputclass value to insert or not to insert "Continued" word to fo:table-header-->
    <xsl:variable name="ocTableTitleContinued" as="xs:string">
        <xsl:call-template name="getVarValue">
            <xsl:with-param name="prmVarName" select="'OcTableTitleContinued'"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="ocNoTableTitleContinued" as="xs:string">
        <xsl:call-template name="getVarValue">
            <xsl:with-param name="prmVarName" select="'OcNoTableTitleContinued'"/>
        </xsl:call-template>
    </xsl:variable>
    <!-- @outputclass value to insert or not to insert "Continued" word to fo:table-footer-->
    <xsl:variable name="ocTableFooterContinued" as="xs:string">
        <xsl:call-template name="getVarValue">
            <xsl:with-param name="prmVarName" select="'OcTableFooterContinued'"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="ocNoTableFooterContinued" as="xs:string">
        <xsl:call-template name="getVarValue">
            <xsl:with-param name="prmVarName" select="'OcNoTableFooterContinued'"/>
        </xsl:call-template>
    </xsl:variable>

    <!-- @outputclass regx value for table alignment -->
    <xsl:variable name="ocTableAlignRegx" as="xs:string">
        <xsl:call-template name="getVarValue">
            <xsl:with-param name="prmVarName" select="'OcTableAlignRegx'"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="ocTableAlignReplaceGroup" as="xs:string">
        <xsl:call-template name="getVarValue">
            <xsl:with-param name="prmVarName" select="'OcTableAlignReplaceGroup'"/>
        </xsl:call-template>
    </xsl:variable>
    

    <!-- 
     function:  table[@orient="land"] template
     param:	    
     return:    fo:bloc-container
     note:      Table will be lotated by 90 degrees counterclockwise from the text flow.
     -->
    <xsl:template match="*[contains(@class, ' topic/table ')][string(@orient) eq 'land']" priority="4">
        <fo:block-container>
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="'atsBlockContainerForLandscapeTable'"/>
            </xsl:call-template>
            <xsl:next-match/>
        </fo:block-container>
    </xsl:template>

    <!-- 
     function:  table[@pgwide="1"] template
     param:	    
     return:    fo:bloc-container
     note:      Table will be positioned from left page margin to right page margin.
                Change implementation method to force table width to full.
                See also ahf:getTablePgwideAttr.
                2016-09-23 t.makita
     -->
    <xsl:template match="*[contains(@class, ' topic/table ')][string(@pgwide) eq '1']" priority="2">
        <fo:block-container>
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="'atsBlockContainerForPgWideTable'"/>
            </xsl:call-template>
            <xsl:next-match/>
        </fo:block-container>
    </xsl:template>

    <!-- 
     function:  table template
     param:	    
     return:    fo:wrapper
     note:      SPEC: Remove deprecated table/title positioning for the end of table
                      Remove footnote generation. Instead it is moved to tgroup template
                      2018-01-05 t.makita
     -->
    <xsl:template match="*[contains(@class, ' topic/table ')]">
        <xsl:variable name="tableAttr" select="ahf:getTableAttr(.)" as="element()"/>
        <xsl:variable name="outputContinuedWordInTableTitle" as="xs:boolean" select="ahf:outputContinuedWordInTableTitle(.)"/>
        <xsl:variable name="outputContinuedWordInTableFooter" as="xs:boolean" select="ahf:outputContinuedWordInTableFooter(.)"/>
        <fo:wrapper>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:if test="empty(@id) and child::*[contains(@class, ' topic/title ')]">
                <xsl:call-template name="ahf:generateIdAttr"/>
            </xsl:if>
            <xsl:apply-templates select="*[contains(@class, ' topic/tgroup ')]">
                <xsl:with-param name="prmTable" tunnel="yes" select="."/>
                <xsl:with-param name="prmTableAttr" tunnel="yes" select="$tableAttr"/>
                <xsl:with-param name="prmOutputContinuedWordInTableTitle" tunnel="yes" select="$outputContinuedWordInTableTitle"/>
                <xsl:with-param name="prmOutputContinuedWordInTableFooter" tunnel="yes" select="$outputContinuedWordInTableFooter"/>
                <xsl:with-param name="prmTableTitle" tunnel="yes" select="*[contains(@class,' topic/title ')]"/>
                <xsl:with-param name="prmTableDesc" tunnel="yes" select="*[contains(@class,' topic/desc ')]"/>
            </xsl:apply-templates>
        </fo:wrapper>
    </xsl:template>

    <!-- 
     function:  generate continued word in fo:table-header or fo:table-footer
     param:     prmTable
     return:    xs:boolean
     note:      Disable generation for nested table.
     -->
    <xsl:function name="ahf:outputContinuedWordInTableTitle" as="xs:boolean">
        <xsl:param name="prmTable" as="element()"/>
        <xsl:choose>
            <xsl:when test="empty($prmTable/*[contains(@class, ' topic/title' )])">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:when test="exists($prmTable/ancestor::*[ahf:seqContains(string(@class),(' topic/entry ',' topic/stentry '))])">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:when test="$pOutputTableTitleContinued and not(ahf:hasOutputClassValue($prmTable,$ocNoTableTitleContinued))">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:when test="not($pOutputTableTitleContinued) and ahf:hasOutputClassValue($prmTable,$ocTableTitleContinued)">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="ahf:outputContinuedWordInTableFooter" as="xs:boolean">
        <xsl:param name="prmTable" as="element()"/>
        <xsl:choose>
            <xsl:when test="exists($prmTable/ancestor::*[ahf:seqContains(string(@class),(' topic/entry',' topic/stentry '))])">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:when test="$pOutputTableFooterContinued and not(ahf:hasOutputClassValue($prmTable,$ocNoTableFooterContinued))">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:when test="not($pOutputTableFooterContinued) and ahf:hasOutputClassValue($prmTable,$ocTableFooterContinued)">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 
     function:  build table attributes
     param:     prmTable
     return:    element()
     note:      outputclass="align-left/align-center/align-right" is adopted as table attribute if specified.	
     -->
    <xsl:function name="ahf:getTableAttr" as="element()">
        <xsl:param name="prmTable" as="element()"/>
        <dummy>
            <xsl:attribute name="frame"  select="if (exists($prmTable/@frame))  then string($prmTable/@frame) else 'all'"/>
            <xsl:attribute name="colsep" select="if (exists($prmTable/@colsep)) then string($prmTable/@colsep) else '1'"/>
            <xsl:attribute name="rowsep" select="if (exists($prmTable/@rowsep)) then string($prmTable/@rowsep) else '1'"/>
            <xsl:attribute name="pgwide" select="if (exists($prmTable/@pgwide)) then string($prmTable/@pgwide) else '0'"/>
            <xsl:attribute name="rowheader" select="if (exists($prmTable/@rowheader)) then string($prmTable/@rowheader) else 'norowheader'"/>
            <xsl:attribute name="scale"  select="if (exists($prmTable/@scale))  then string($prmTable/@scale) else '100'"/>
            <xsl:copy-of select="$prmTable/@class"/>
        </dummy>
    </xsl:function>
    
    <!-- 
     function:  table/desc template
     param:	    
     return:    fo:block
     note:      Set $prmDoInherit=true() for getAttributeSetWithLang to avoid thead style inheritance when adding "Continued" word in table title.
                2019-02-13 t.makita
     -->
    <xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/desc ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsTableDesc'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/desc ')]">
        <fo:block>
            <xsl:call-template name="getAttributeSetWithLang">
                <xsl:with-param name="prmDoInherit" select="true()"/>
            </xsl:call-template>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <!-- 
     function:  table/title template
     param:     prmOutputContinuedWordInTableTitle
     return:    fo:block
     note:      If table/title is called from fo:table-header generation, add fo:retrieve-table-marker to add "Continued" word.
                If called from fo:marker generation, add "Continued" word.
                Set $prmDoInherit=true() for getAttributeSetWithLang to avoid thead style inheritance when adding "Continued" word in table title.
                2019-02-13 t.makita
     -->
    <xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsTableTitle'"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]" priority="2">
        <xsl:param name="prmOutputContinuedWordInTableTitle" tunnel="yes" as="xs:boolean"/>
        <xsl:param name="prmGenContinuedWord" as="xs:boolean" required="no" select="false()"/>
        <xsl:variable name="tableTitlePrefix" as="xs:string">
            <xsl:call-template name="ahf:getTableTitlePrefix">
                <xsl:with-param name="prmTable" select="parent::*[1]"/>
            </xsl:call-template>
        </xsl:variable>
        <fo:block>
            <xsl:call-template name="getAttributeSetWithLang">
                <xsl:with-param name="prmDoInherit" select="true()"/>
            </xsl:call-template>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:value-of select="$tableTitlePrefix"/>
            <xsl:text>&#x00A0;</xsl:text>
            <xsl:apply-templates/>
            <xsl:if test="$prmOutputContinuedWordInTableTitle">
                <fo:retrieve-table-marker retrieve-class-name="{$mcTableHeaderContinuedWord}"/>
            </xsl:if>
            <xsl:if test="$prmGenContinuedWord">
                <fo:inline>
                    <xsl:call-template name="getAttributeSet">
                        <xsl:with-param name="prmAttrSetName" select="'atsNormal'"/>
                    </xsl:call-template>
                    <xsl:call-template name="getVarValue">
                        <xsl:with-param name="prmVarName" select="'TableHeaderContinuationWord'"/>
                    </xsl:call-template>
                </fo:inline>
            </xsl:if>
        </fo:block>
    </xsl:template>
    
    <!-- 
     function:  Extract start-indent, end-indent, text-align properties for fo:table-and-cation from tgroup level attribute
     param:     prmProps
     return:    attribute()*
     note:      Sortout properties for fo:table-and-caption and fo:table.
                2020-05-25 t.makita
     -->
    <xsl:function name="ahf:extractTableAndCaptionProperty" as="attribute()*">
        <xsl:param name="prmProps" as="attribute()*"/>
        <xsl:sequence select="$prmProps[name() = ('start-indent','end-indent','text-align')]"/>
    </xsl:function>
    
    <!-- 
     function:  tgroup template
     param:     prmTableAttr and etc
     return:	fo:table-and-caption
     note:      Add space-before when there is no table/tite,desc.
                2016-07-24 t.makita
                SPEC: Output table/title & desc for the first occurrence of table/tgroup in fo:table-cation.
                      Output "Continued" word in fo:table-header if $prmOutputContinuedWordInTableTitle is true().
                      Output "Continued" word in fo:table-footer if $prmOutputContinuedWordInTableFooter is true().
                      Generate footnote per table/tgroup
                      2019-01-05 t.makita
                Adopt fo:prop authored both table, tgroup.
                Simplify the element correspondence:
                table→fo:table-and-caption
                tgroup→fo:table
                2020-05-24 t.makita
     -->
    <xsl:template match="*[contains(@class, ' topic/tgroup ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsTable'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/tgroup ')]">
        <xsl:param name="prmTableAttr" required="yes" tunnel="yes" as="element()"/>
        <xsl:param name="prmOutputContinuedWordInTableTitle" required="yes" tunnel="yes" as="xs:boolean"/>
        <xsl:param name="prmOutputContinuedWordInTableFooter" required="yes" tunnel="yes" as="xs:boolean"/>
        <xsl:param name="prmTableTitle" required="yes" tunnel="yes" as="element()?"/>
        <xsl:param name="prmTableDesc"  required="yes" tunnel="yes" as="element()?"/>
        
        <xsl:variable name="tgroup" as="element()" select="."/>
        <xsl:variable name="table" as="element()" select="$tgroup/parent::*"/>
        <xsl:variable name="isFirstTgroup" as="xs:boolean" select="empty(preceding-sibling::*[contains(@class, ' topic/tgroup ')])"/>
        <xsl:variable name="tgroupAttr" select="ahf:addTgroupAttr($tgroup, $prmTableAttr)" as="element()"/>
        <xsl:variable name="colSpec" as="element()*">
            <xsl:apply-templates select="child::*[contains(@class, ' topic/colspec ')]"/>
        </xsl:variable>
        <xsl:variable name="tableAttr" as="attribute()*">
            <xsl:call-template name="getAttributeSetWithLang"/>
        </xsl:variable>
        <xsl:variable name="outputTableCaption" as="xs:boolean">
            <xsl:choose>
                <xsl:when test="not($isFirstTgroup)">
                    <xsl:sequence select="false()"/>
                </xsl:when>
                <xsl:when test="exists($prmTableTitle) and $prmOutputContinuedWordInTableTitle">
                    <xsl:sequence select="false()"/>
                </xsl:when>
                <xsl:when test="exists($prmTableTitle) or exists($prmTableDesc)">
                    <xsl:sequence select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="cols" as="xs:string" select="string($tgroup/@cols)"/>
        <fo:table-and-caption>
            <xsl:call-template name="getAttributeSetWithLang">
                <xsl:with-param name="prmAttrSetName" select="'atsTableAndCaption'"/>
            </xsl:call-template>
            <xsl:copy-of select="ahf:getOutputClassTableAlignAttr($table)"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty($table)"/>
            <xsl:if test="$outputTableCaption">
                <fo:table-caption>
                    <xsl:call-template name="getAttributeSet">
                        <xsl:with-param name="prmAttrSetName" select="'atsTableCaption'"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="$prmTableTitle"/>
                    <xsl:apply-templates select="$prmTableDesc"/>
                </fo:table-caption>
            </xsl:if>
            <fo:table>
                <xsl:copy-of select="$tableAttr"/>
                <xsl:call-template name="ahf:getUnivAtts"/>
                <xsl:call-template name="ahf:getTablePgwideAttr ">
                    <xsl:with-param name="prmTgroupAttr" select="$tgroupAttr"/>
                </xsl:call-template>
                <xsl:copy-of select="ahf:getScaleAtts($tgroupAttr,$tableAttr)"/>
                <xsl:copy-of select="ahf:getFrameAtts($tgroupAttr,$tableAttr)"/>
                <xsl:copy-of select="ahf:getFoStyleAndProperty($tgroup)"/>
                <!-- Copy fo:table-column -->
                <xsl:apply-templates select="$colSpec" mode="MODE_COPY_COLSPEC"/>
                <xsl:choose>
                    <xsl:when test="*[contains(@class,' topic/thead ')]">
                        <xsl:apply-templates select="*[contains(@class, ' topic/thead ')]">
                            <xsl:with-param name="prmTgroup"     tunnel="yes" select="$tgroup"/>
                            <xsl:with-param name="prmTgroupAttr" tunnel="yes" select="$tgroupAttr"/>
                            <xsl:with-param name="prmColSpec"    tunnel="yes" select="$colSpec"/>
                            <xsl:with-param name="prmIsFirstTgroup" tunnel="yes" select="$isFirstTgroup"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:when test="$prmOutputContinuedWordInTableTitle">
                        <xsl:call-template name="genTheaderForContinuedWord">
                            <xsl:with-param name="prmCols" select="$cols"/>
                            <xsl:with-param name="prmIsFirstTgroup" select="$isFirstTgroup"/>
                            <xsl:with-param name="prmTgroupAttr" tunnel="yes" select="$tgroupAttr"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="$prmOutputContinuedWordInTableFooter">
                    <xsl:call-template name="genTfooterForContinuedWord">
                        <xsl:with-param name="prmCols" select="$cols"/>
                        <xsl:with-param name="prmTgroupAttr" tunnel="yes" select="$tgroupAttr"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:apply-templates select="*[contains(@class, ' topic/tbody ')]">
                    <xsl:with-param name="prmTgroup"     tunnel="yes" select="$tgroup"/>
                    <xsl:with-param name="prmTgroupAttr" tunnel="yes" select="$tgroupAttr"/>
                    <xsl:with-param name="prmColSpec"    tunnel="yes" select="$colSpec"/>
                    <xsl:with-param name="prmIsFirstTgroup" tunnel="yes" select="$isFirstTgroup"/>
                </xsl:apply-templates>
            </fo:table>
        </fo:table-and-caption>
        <xsl:if test="not($pDisplayFnAtEndOfTopic)">
            <xsl:call-template name="makeFootNote">
                <xsl:with-param name="prmElement" as="element()+">
                    <xsl:if test="$tgroup is $tgroup/parent::*[contains(@class,' topic/table ')]/*[contains(@class,' topic/tgroup ')][1]">
                        <xsl:sequence select="$tgroup/parent::*[contains(@class,' topic/table ')]/*[contains(@class,' topic/desc ')]"/>
                    </xsl:if>
                    <xsl:sequence select="$tgroup"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- 
     function:  build tgroup attributes
     param:     prmTgroup, prmTableAttr
     return:    element()
     note:      
     -->
    <xsl:function name="ahf:addTgroupAttr" as="element()">
        <xsl:param name="prmTgroup"    as="element()"/>
        <xsl:param name="prmTableAttr" as="element()"/>
        <dummy>
            <xsl:copy-of select="$prmTableAttr/@*"/>
            <xsl:copy-of select="$prmTgroup/@cols"/>
            <xsl:copy-of select="$prmTgroup/@colsep"/>
            <xsl:copy-of select="$prmTgroup/@rowsep"/>
            <xsl:copy-of select="$prmTgroup/@align"/>
        </dummy>
    </xsl:function>

    <!-- 
     function:  Get table align attribute
     param:     prmTable
     return:    attribute()
     note:      This template controls table alignment (text-align of fo:table-and-caption) not defined in DITA.
     -->
    <xsl:function name="ahf:getOutputClassTableAlignAttr" as="attribute()?">
        <xsl:param name="prmTable" as="element()"/>
        <xsl:variable name="outputClassTableAlign" as="xs:string" select="ahf:getOutputClassRegx($prmTable,$ocTableAlignRegx,$ocTableAlignReplaceGroup)"/>
        <xsl:if test="string($outputClassTableAlign)">
            <xsl:attribute name="text-align" select="$outputClassTableAlign"/>
        </xsl:if>
    </xsl:function>
    
    <!-- 
     function:  Get pgwide attributes
     param:     prmTgroupAttr
     return:    attribute()
     note:      width="100%" will be generated.
     -->
    <xsl:template name="ahf:getTablePgwideAttr" as="attribute()*">
        <xsl:param name="prmTgroupAttr" required="yes" as="element()"/>
        <xsl:if test="string($prmTgroupAttr/@pgwide) eq '1'">
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="'atsPgWideTable'"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- 
     function:  Generate fo:table-header with "Continued" word when tgroup/thead is empty
     param:     prmTableTitle, prmTableDesc, prmCols, prmIsFirstTgroup, prmTgroupAttr
     return:    fo:table-header
     note:      table/desc is controled by fo:retrive-table-marker because it is needed in only first table header.
                Took into account the case when table/@frame="none/sides/bottom".
                2020-08-13 t.makita
     -->
    <xsl:template name="genTheaderForContinuedWord">
        <xsl:param name="prmTableTitle" as="element()?" tunnel="yes" required="yes"/>
        <xsl:param name="prmTableDesc" as="element()?"  tunnel="yes" required="yes"/>
        <xsl:param name="prmCols" as="xs:string" required="yes"/>
        <xsl:param name="prmIsFirstTgroup" as="xs:boolean" required="yes"/>
        <xsl:param name="prmTgroupAttr" tunnel="yes" required="yes"/>
        
        <fo:table-header>
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="'atsTableHeaderWoThead'"/>
            </xsl:call-template>
            <fo:table-row>
                <xsl:call-template name="getAttributeSet">
                    <xsl:with-param name="prmAttrSetName" select="'atsTableRowCaption'"/>
                </xsl:call-template>
                <xsl:if test="$prmTgroupAttr/@frame = ('none','sides','bottom')">
                    <xsl:call-template name="getAttributeSet">
                        <xsl:with-param name="prmAttrSetName" select="'atsTableRowCaptionWithNoTopFrame'"/>
                    </xsl:call-template>
                </xsl:if>
                <fo:table-cell>
                    <xsl:attribute name="number-columns-spanned" select="$prmCols"/>
                    <xsl:call-template name="getAttributeSet">
                        <xsl:with-param name="prmAttrSetName" select="'atsTableHeaderCaptionCell'"/>
                    </xsl:call-template>
                    <xsl:choose>
                        <xsl:when test="$prmIsFirstTgroup">
                            <xsl:apply-templates select="$prmTableTitle"/>
                            <xsl:if test="exists($prmTableDesc)">
                                <fo:retrieve-table-marker retrieve-class-name="{$mcTableHeaderTableDesc}"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <fo:retrieve-table-marker retrieve-class-name="{$mcTableHeaderContinuedWord}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:table-cell>
            </fo:table-row>
        </fo:table-header>
    </xsl:template>
    
    <!-- 
     function:  Generate fo:table-footer that includes "Continued" word
     param:     prmCols, prmTgroupAttr
     return:    fo:table-footer
     note:      Took into account the case when table/@frame="none/sides/top".
                2020-08-13 t.makita
     -->
    <xsl:template name="genTfooterForContinuedWord">
        <xsl:param name="prmCols" as="xs:string" required="yes"/>
        <xsl:param name="prmTgroupAttr" tunnel="yes" required="yes"/>
        <fo:table-footer>
            <xsl:call-template name="getAttributeSet">
                <xsl:with-param name="prmAttrSetName" select="'atsTfooter'"/>
            </xsl:call-template>
            <fo:table-row>
                <xsl:call-template name="getAttributeSet">
                    <xsl:with-param name="prmAttrSetName" select="'atsTableRowFooter'"/>
                </xsl:call-template>
                <fo:table-cell>
                    <xsl:attribute name="number-columns-spanned" select="$prmCols"/>
                    <xsl:call-template name="getAttributeSet">
                        <xsl:with-param name="prmAttrSetName" select="'atsTableFooterCell'"/>
                    </xsl:call-template>
                    <xsl:if test="$prmTgroupAttr/@frame = ('none','sides','top')">
                        <xsl:call-template name="getAttributeSet">
                            <xsl:with-param name="prmAttrSetName" select="'atsTableFooterCellWithNoBottomFrame'"/>
                        </xsl:call-template>
                    </xsl:if>
                    <fo:retrieve-table-marker retrieve-class-name="{$mcTableFooterContinuedWord}" retrieve-position-within-table="last-starting"/>
                </fo:table-cell>
            </fo:table-row>
        </fo:table-footer>
    </xsl:template>
    
    <!-- 
     function:  fo:table-column copy template
     param:     none
     return:	fo:table-column
     note:		
     -->
    <xsl:template match="fo:table-column" mode="MODE_COPY_COLSPEC">
        <xsl:copy>
            <xsl:copy-of select="@*[name() ne 'ahf:column-name']"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- 
     function:  colspec template
     param:     none
     return:    fo:table-column
     note:      Added border style "atsTableColumn" to set default border width. 2014-01-03 t.makita
     -->
    <xsl:template match="*[contains(@class, ' topic/colspec ')]">
        <fo:table-column>
            <xsl:copy-of select="ahf:getAttributeSet('atsTableColumn')"/>
            <xsl:copy-of select="ahf:getColSpecAttr(.)"/>
            <xsl:copy-of select="ahf:getLocalizationAtts(.)"/>
            <xsl:call-template name="ahf:getIdAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
        </fo:table-column>
    </xsl:template>
    
    <!-- 
     function:  build colspec attributes
     param:     prmColSpec
     return:    attribute()*
     note:      Generates XSL-FO property.
     -->
    <xsl:function name="ahf:getColSpecAttr" as="attribute()*">
        <xsl:param name="prmColSpec" as="element()"/>
    
        <!-- colname (Not defined in XSL-FO)-->
        <xsl:if test="exists($prmColSpec/@colname)">
            <xsl:attribute name="ahf:column-name" select="string($prmColSpec/@colname)"/>
        </xsl:if>
    
        <!-- colnum -->
        <xsl:choose>
            <xsl:when test="exists($prmColSpec/@colnum)">
                <xsl:attribute name="column-number" select="string($prmColSpec/@colnum)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="column-number" select="string(count($prmColSpec | $prmColSpec/preceding-sibling::*[contains(@class,' topic/colspec ')]))"/>
            </xsl:otherwise>
        </xsl:choose>
    
        <!-- colwidth -->
        <xsl:if test="exists($prmColSpec/@colwidth)">
            <xsl:variable name="colWidth">
                <xsl:call-template name="calc.column.width">
                    <xsl:with-param name="colwidth" select="string($prmColSpec/@colwidth)"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:attribute name="column-width" select="string($colWidth)"/>
        </xsl:if>
        
        <!-- colsep -->
        <xsl:if test="exists($prmColSpec/@colsep)">
            <xsl:variable name="colsep" as="xs:string" select="string($prmColSpec/@colsep)"/>
            <xsl:choose>
                <xsl:when test="$colsep eq '0'">
                    <xsl:attribute name="border-end-style" select="'none'"/>
                </xsl:when>
                <xsl:when test="$colsep eq '1'">
                    <xsl:attribute name="border-end-style" select="'solid'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    
        <!-- rowsep -->
        <xsl:if test="exists($prmColSpec/@rowsep)">
            <xsl:variable name="rowsep" as="xs:string" select="string($prmColSpec/@rowsep)"/>
            <xsl:choose>
                <xsl:when test="$rowsep eq '0'">
                    <xsl:attribute name="border-after-style" select="'none'"/>
                </xsl:when>
                <xsl:when test="$rowsep eq '1'">
                    <xsl:attribute name="border-after-style" select="'solid'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        
        <!-- align -->
        <xsl:if test="exists($prmColSpec/@align)">
            <xsl:variable name="align" as="xs:string" select="string($prmColSpec/@align)"/>
            <xsl:choose>
                <xsl:when test="$align eq 'char'">
                    <xsl:variable name="char" select="string($prmColSpec/@char)"/>
                    <xsl:choose>
                        <xsl:when test="string($char)">
                            <xsl:attribute name="text-align" select="$char"/>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="text-align" select="$align"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        
        <!-- rowheader -->
        <xsl:if test="exists($prmColSpec/@rowheader)">
            <xsl:attribute name="ahs:rowheader" select="string($prmColSpec/@rowheader)"/>
        </xsl:if>
        
    </xsl:function>
    
    <!-- 
     function:   thead template
     param:      prmTgroupAttr, prmColSpec, etc
     return:     fo:table-header
     note:       Output table/title, desc in fo:table-heade if $prmOutputContinuedWordInTableTitle is true
                 SPEC: If output "Continued" word in table title, make @background-color="transparent"
                 
                 The tunnel parameter $prmOutputContinuedWordInTableTitle does not exist if mode="MODE_GET_STYLE" template
                 is called from multiple language support in dita2fo_style_get.xsl.
     -->
    <xsl:template match="*[contains(@class, ' topic/thead ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsThead'"/>
        <xsl:variable name="outputContinuedWordInTableTitle" as="xs:boolean" select="ahf:outputContinuedWordInTableTitle(ancestor::*[contains(@class, ' topic/table ')][1])"/>
        <xsl:if test="$outputContinuedWordInTableTitle">
            <xsl:sequence select="'atsBgTransparent'"/>
        </xsl:if>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/thead ')]">
        <xsl:param name="prmTgroupAttr" required="yes" tunnel="yes" as="element()"/>
        <xsl:param name="prmColSpec" required="yes" tunnel="yes" as="element()*"/>
        <xsl:param name="prmOutputContinuedWordInTableTitle" required="yes" tunnel="yes" as="xs:boolean"/>
        <xsl:param name="prmIsFirstTgroup" required="yes" tunnel="yes" as="xs:boolean"/>
        <xsl:param name="prmTableTitle" required="yes" tunnel="yes" as="element()?"/>
        <xsl:param name="prmTableDesc"  required="yes" tunnel="yes" as="element()?"/>
        
        <xsl:variable name="thead" as="element()" select="."/>
        <xsl:variable name="theadAttr" as="element()" select="ahf:addTheadAttr($thead,$prmTgroupAttr)"/>
        <fo:table-header>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:if test="$prmOutputContinuedWordInTableTitle">
                <fo:table-row>
                    <xsl:call-template name="getAttributeSet">
                        <xsl:with-param name="prmAttrSetName" select="'atsTableRowCaption'"/>
                    </xsl:call-template>
                    <fo:table-cell>
                        <xsl:attribute name="number-columns-spanned" select="string($prmTgroupAttr/@cols)"/>
                        <xsl:call-template name="getAttributeSet">
                            <xsl:with-param name="prmAttrSetName" select="'atsTableHeaderCaptionCell'"/>
                        </xsl:call-template>
                        <xsl:choose>
                            <xsl:when test="$prmIsFirstTgroup">
                                <xsl:apply-templates select="$prmTableTitle"/>
                                <xsl:if test="exists($prmTableDesc)">
                                    <fo:retrieve-table-marker retrieve-class-name="{$mcTableHeaderTableDesc}"/>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <fo:retrieve-table-marker retrieve-class-name="{$mcTableHeaderContinuedWord}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:table-cell>
                </fo:table-row>
            </xsl:if>
            <xsl:apply-templates select="*[contains(@class, ' topic/row ')]">
                <xsl:with-param name="prmThead"        tunnel="yes" select="$thead"/>
                <xsl:with-param name="prmRowUpperAttr" tunnel="yes" select="$theadAttr"/>
                <xsl:with-param name="prmColSpec"      tunnel="yes" select="$prmColSpec"/>
            </xsl:apply-templates>
        </fo:table-header>
    </xsl:template>
    
    <!-- 
     function:  build thead attributes
     param:     prmThead, prmTgroupAttr
     return:    element()
     note:		
     -->
    <xsl:function name="ahf:addTheadAttr" as="element()">
        <xsl:param name="prmThead"      as="element()"/>
        <xsl:param name="prmTgroupAttr" as="element()"/>
        <dummy>
            <xsl:copy-of select="$prmTgroupAttr/@* except $prmTgroupAttr/@*[name() eq $pFoPropName]"/>
            <xsl:copy-of select="$prmThead/@valign"/>
            <xsl:copy-of select="ahf:getStylesheetProperty($prmThead)"/>"
        </dummy>
    </xsl:function>
    
    <!-- 
     function:  tbody template
     param:     prmTgroupAttr, prmColSpec
     return:    fo:table-body
     note:		
     -->
    <xsl:template match="*[contains(@class, ' topic/tbody ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsTbody'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/tbody ')]">
        <xsl:param name="prmTgroupAttr" required="yes" tunnel="yes" as="element()"/>
        <xsl:param name="prmColSpec" required="yes" tunnel="yes" as="element()*"/>
    
        <xsl:variable name="tbody" as="element()" select="."/>
        <xsl:variable name="tbodyAttr"  as="element()" select="ahf:addTbodyAttr($tbody,$prmTgroupAttr)"/>
        <fo:table-body>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates select="*[contains(@class, ' topic/row ')]">
                <xsl:with-param name="prmTbody"        tunnel="yes" select="$tbody"/>
                <xsl:with-param name="prmRowUpperAttr" tunnel="yes" select="$tbodyAttr"/>
                <xsl:with-param name="prmColSpec"      tunnel="yes" select="$prmColSpec"/>
            </xsl:apply-templates>
        </fo:table-body>
    </xsl:template>

    <!-- 
     function:  build tbody attributes
     param:     prmTbody, prmTgroupAttr
     return:    element()
     note:		
     -->
    <xsl:function name="ahf:addTbodyAttr" as="element()">
        <xsl:param name="prmTbody"      as="element()"/>
        <xsl:param name="prmTgroupAttr" as="element()"/>
        <dummy>
            <xsl:copy-of select="$prmTgroupAttr/@* except $prmTgroupAttr/@*[name() eq $pFoPropName]"/>
            <xsl:copy-of select="$prmTbody/@valign"/>
            <xsl:copy-of select="ahf:getStylesheetProperty($prmTbody)"/>"
        </dummy>
    </xsl:function>
    
    <!-- 
     function:  row template
     param:     prmRowUpperAttr, prmColSpec
     return:    fo:table-row
     note:      SPEC: If row belongs thead and output "Continued" word in table title, set thead background color to row.
     -->
    <xsl:template match="*[contains(@class, ' topic/row ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsRow'"/>
        <xsl:variable name="isInThead" as="xs:boolean" select="exists(ancestor::*[contains(@class, ' topic/thead ')])"/>
        <xsl:variable name="outputContinuedWordInTableTitle" as="xs:boolean" select="ahf:outputContinuedWordInTableTitle(ancestor::*[contains(@class, ' topic/table ')][1])"/>
        <xsl:if test="$outputContinuedWordInTableTitle">
            <xsl:sequence select="'atsBgTransparent'"/>
        </xsl:if>
        <xsl:if test="$isInThead and $outputContinuedWordInTableTitle">
            <xsl:sequence select="'atsBgThead'"/>
        </xsl:if>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/row ')]">
        <xsl:param name="prmRowUpperAttr" required="yes" tunnel="yes" as="element()"/>
        <xsl:param name="prmColSpec" required="yes" tunnel="yes" as="element()*"/>
        <xsl:param name="prmOutputContinuedWordInTableTitle" required="yes" tunnel="yes" as="xs:boolean"/>
        <xsl:param name="prmThead" required="no" tunnel="yes" as="element()?" select="()"/>
        
        <xsl:variable name="row"  as="element()" select="."/>
        <xsl:variable name="rowAttr"  as="element()" select="ahf:addRowAttr($row,$prmRowUpperAttr)"/>
        <xsl:variable name="rowHeight" as="xs:double">
            <xsl:call-template name="getRowHeight">
                <xsl:with-param name="prmRow" select="$row"/>
                <xsl:with-param name="prmRowAttr" select="$rowAttr"/>
            </xsl:call-template>
        </xsl:variable>
        <fo:table-row>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:if test="$rowHeight gt 0.0">
                <xsl:attribute name="height" select="concat(string($rowHeight),'em')"/>
            </xsl:if>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates select="*[contains(@class, ' topic/entry ')]">
                <xsl:with-param name="prmRow"        tunnel="yes" select="$row"/>
                <xsl:with-param name="prmRowAttr"    tunnel="yes" select="$rowAttr"/>
                <xsl:with-param name="prmColSpec"    tunnel="yes" select="$prmColSpec"/>
                <xsl:with-param name="prmRowHeight"  tunnel="yes" select="$rowHeight"/>
            </xsl:apply-templates>
        </fo:table-row>
    </xsl:template>
    
    <!-- 
     function:  build row attributes
     param:     prmRow, prmRowUpperAttr
     return:    element()
     note:		
     -->
    <xsl:function name="ahf:addRowAttr" as="element()">
        <xsl:param name="prmRow"    as="element()"/>
        <xsl:param name="prmRowUpperAttr" as="element()"/>
        <dummy>
            <xsl:copy-of select="$prmRowUpperAttr/@*"/>
            <xsl:copy-of select="$prmRow/@rowsep"/>
            <xsl:copy-of select="$prmRow/@valign"/>
            <xsl:copy-of select="ahf:getStylesheetProperty($prmRow)"/>
        </dummy>
    </xsl:function>
    
    <!-- 
     function:  get row height considering entry/@rotate="1"
     param:     prmRow, prmRowAttr
     return:    xs:double (Row height as em unit. 0.0 means no needs to set row height)
     note:		
     -->
    <xsl:template name="getRowHeight" as="xs:double">
        <xsl:param name="prmRow" as="element()" required="yes"/>
        <xsl:param name="prmRowAttr" as="element()" required="yes"/>
        <xsl:variable name="rotatedEntries" as="element()*" select="$prmRow/*[contains(@class,' topic/entry ')][string(@rotate) eq '1']"/>
        <xsl:choose>
            <xsl:when test="exists($rotatedEntries)">
                <!-- Average character width in table cell -->
                <xsl:variable name="avgCharWidthInTableCell" as="xs:double">
                    <!-- Manually specified row charracter width -->
                    <xsl:variable name="maunuallySpecifiedCharWidth" as="xs:double?" select="xs:double($prmRowAttr/@*[name() eq 'ahs:avg-char-width-in-table-entry'])"/>
                    <xsl:choose>
                        <xsl:when test="exists($maunuallySpecifiedCharWidth)">
                            <xsl:sequence select="$maunuallySpecifiedCharWidth"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="getVarValueAsDouble">
                                <xsl:with-param name="prmVarName" select="'Avg_Char_Width_In_Table_Entry'"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>    
                </xsl:variable>
                <!-- Max character count in rotated entry -->
                <xsl:variable name="maxCharCountInRotatedTableEntry" as="xs:double">
                    <!-- Manually specified row height -->
                    <xsl:variable name="maunuallyAssignRowHeight" as="xs:double?" select="xs:double($prmRowAttr/@*[name() eq 'ahs:max-char-count-in-rotated-table-entry'])"/>
                    <!--xsl:message select="'ahf:getStylesheetProperty($prmRowAttr)=',ahf:getStylesheetProperty($prmRowAttr)"/-->
                    <xsl:choose>
                        <xsl:when test="exists($maunuallyAssignRowHeight)">
                            <xsl:sequence select="$maunuallyAssignRowHeight"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="getVarValueAsDouble">
                                <xsl:with-param name="prmVarName" select="'Max_Char_Count_In_Rotated_Table_Entry'"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- Row height in em unit -->
                <xsl:variable name="rowHeights" as="xs:double+">
                    <xsl:for-each select="$rotatedEntries">
                        <xsl:variable name="rotatedEntry" as="element()" select="."/>
                        <!-- Entry character count -->
                        <xsl:variable name="rotatedEntryCharCount" as="xs:double">
                            <xsl:variable name="entryCharTexts" as="xs:string*">
                                <xsl:apply-templates select="$rotatedEntry" mode="TEXT_ONLY"/>
                            </xsl:variable>
                            <xsl:sequence select="xs:double(string-length(normalize-space(string-join($entryCharTexts,''))))"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$rotatedEntryCharCount gt $maxCharCountInRotatedTableEntry">
                                <xsl:sequence select="$maxCharCountInRotatedTableEntry * $avgCharWidthInTableCell"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="$rotatedEntryCharCount * $avgCharWidthInTableCell"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:sequence select="max($rowHeights)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="0.0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
     function:  table header entry template
     param:     prmRowAttr, prmColSpec,prmRowHeight
     return:    fo:table-cell
     note:      Honor the entry attribute than colspec attribute. 2011-08-29 t.makita
                $prmRowHeight is needed for entry/@rotate="1" when specifying fo:block-container/@width
     -->
    <xsl:template match="*[contains(@class,' topic/thead ')]/*[contains(@class,' topic/row ')]/*[contains(@class,' topic/entry ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsTableHeaderCell'"/>
    </xsl:template>    
    
    <xsl:template match="*[contains(@class,' topic/thead ')]/*[contains(@class,' topic/row ')]/*[contains(@class,' topic/entry ')]">
        <xsl:param name="prmRowAttr" required="yes" tunnel="yes" as="element()"/>
        <xsl:param name="prmColSpec" required="yes" tunnel="yes" as="element()*"/>
        <xsl:param name="prmRowHeight" required="yes" tunnel="yes" as="xs:double"/>
    
        <xsl:variable name="colname" as="xs:string" select="string(@colname)"/>
        <fo:table-cell>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getEntryAttr(.,$prmRowAttr,$prmColSpec)"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:choose>
                <xsl:when test="string(@rotate) eq '1'">
                    <fo:block-container>
                        <xsl:call-template name="getAttributeSet">
                            <xsl:with-param name="prmAttrSetName" select="'atsRotatedEntry'"/>
                        </xsl:call-template>
                        <xsl:attribute name="width" select="concat(string($prmRowHeight),'em')"/>
                        <fo:block>
                            <xsl:apply-templates/>
                        </fo:block>
                    </fo:block-container>
                </xsl:when>
                <xsl:otherwise>
                    <fo:block>
                        <xsl:apply-templates/>
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
        </fo:table-cell>
    </xsl:template>

    <!-- 
     function:  table body entry template
     param:     prmRowAttr, prmColSpec,prmRowHeight
     return:    fo:table-cell
     note:      Honor the entry attribute than colspec attribute. 2011-08-29 t.makita
                $prmRowHeight is needed for entry/@rotate="1" when specifying fo:block-container/@width
                SPEC: generate fo:marker if table needs "Continued" word in header or footer.
                      2018-01-06 t.makita
     -->
    <xsl:template match="*[contains(@class,' topic/tbody ')]/*[contains(@class,' topic/row ')]/*[contains(@class,' topic/entry ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsTableBodyCell'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class,' topic/tbody ')]/*[contains(@class,' topic/row ')]/*[contains(@class,' topic/entry ')]">
        <xsl:param name="prmRowAttr" required="yes" tunnel="yes" as="element()"/>
        <xsl:param name="prmColSpec" required="yes" tunnel="yes" as="element()*"/>
        <xsl:param name="prmRowHeight" required="yes" tunnel="yes" as="xs:double"/>
        
        <xsl:variable name="entry" as="element()" select="."/>
        <xsl:variable name="colname" as="xs:string" select="string($entry/@colname)"/>
        <fo:table-cell>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getEntryAttr($entry,$prmRowAttr,$prmColSpec)"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty($entry)"/>
            <xsl:choose>
                <xsl:when test="string($entry/@rotate) eq '1'">
                    <fo:block-container>
                        <xsl:call-template name="getAttributeSet">
                            <xsl:with-param name="prmAttrSetName" select="'atsRotatedEntry'"/>
                        </xsl:call-template>
                        <xsl:attribute name="width" select="concat(string($prmRowHeight),'em')"/>
                        <xsl:call-template name="genMarkerForContinuedWord">
                            <xsl:with-param name="prmEntry" select="$entry"/>
                        </xsl:call-template>
                        <fo:block>
                            <xsl:apply-templates/>
                        </fo:block>
                    </fo:block-container>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="genMarkerForContinuedWord">
                        <xsl:with-param name="prmEntry" select="$entry"/>
                    </xsl:call-template>
                    <fo:block>
                        <xsl:apply-templates/>
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
        </fo:table-cell>
    </xsl:template>

    <!-- 
     function:  Generate fo:marker for controlling output "Continued" word in table header or footer
     param:     prmEntry, prmOutputContinuedWordInTableTitle, prmOutputContinuedWordInTableFooter, etc 
     return:	fo:marker*
     note:      First Row/First Cell
                - Not output "Continued" in table header.
                - Output table/desc after table caption.
                - Output "Continued" to table footer.
                Second Row/First Cell
                - Output "Continued" in table header.
                - Not output table/desc after table caption.
                Last Row/First Cell
                - Not output "Continued" to table footer.
     -->
    <xsl:template name="genMarkerForContinuedWord" as="element(fo:marker)*">
        <xsl:param name="prmEntry" as="element()" required="yes"/>
        <xsl:param name="prmRow"   as="element()" tunnel="yes" required="yes"/>
        <xsl:param name="prmTbody" as="element()" tunnel="yes" required="yes"/>
        <xsl:param name="prmTgroup" as="element()" tunnel="yes" required="yes"/>
        <xsl:param name="prmTable" as="element()" tunnel="yes" required="yes"/>
        <xsl:param name="prmTableTitle" as="element()?" tunnel="yes" required="yes"/>
        <xsl:param name="prmTableDesc" as="element()?" tunnel="yes" required="yes"/>
        <xsl:param name="prmIsFirstTgroup" required="yes" tunnel="yes" as="xs:boolean"/>
        <xsl:param name="prmOutputContinuedWordInTableTitle" required="yes" tunnel="yes" as="xs:boolean"/>
        <xsl:param name="prmOutputContinuedWordInTableFooter" required="yes" tunnel="yes" as="xs:boolean"/>

        <xsl:variable name="isFirstRow" as="xs:boolean" select="empty($prmRow/preceding-sibling::*[contains(@class,' topic/row ')])"/>
        <xsl:variable name="isSecondRow" as="xs:boolean" select="count($prmRow/preceding-sibling::*[contains(@class,' topic/row ')]) eq 1"/>
        <xsl:variable name="isLastRow" as="xs:boolean" select="empty($prmRow/following-sibling::*[contains(@class,' topic/row ')])"/>
        <xsl:variable name="isFirstCell" as="xs:boolean" select="empty($prmEntry/preceding-sibling::*[contains(@class,' topic/entry ')])"/>
        <xsl:if test="$isFirstRow and $isFirstCell and $prmOutputContinuedWordInTableTitle">
            <fo:marker marker-class-name="{$mcTableHeaderContinuedWord}"/>
            <xsl:if test="exists($prmTableDesc)">
                <fo:marker marker-class-name="{$mcTableHeaderTableDesc}">
                    <xsl:apply-templates select="$prmTableDesc"/>
                </fo:marker>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$isFirstRow and $isFirstCell and $prmOutputContinuedWordInTableFooter">
            <fo:marker marker-class-name="{$mcTableFooterContinuedWord}">
                <fo:block>
                    <xsl:call-template name="getAttributeSet">
                        <xsl:with-param name="prmAttrSetName" select="'atsTableFooterCellBlock'"/>
                    </xsl:call-template>
                    <fo:inline>
                        <xsl:call-template name="getVarValue">
                            <xsl:with-param name="prmVarName" select="'TableFooterContinuationWord'"/>
                        </xsl:call-template>
                    </fo:inline>
                </fo:block>
            </fo:marker>
        </xsl:if>
        <xsl:if test="$isSecondRow and $isFirstCell and $prmOutputContinuedWordInTableTitle">
            <fo:marker marker-class-name="{$mcTableHeaderContinuedWord}">
                <xsl:choose>
                    <xsl:when test="$prmIsFirstTgroup">
                        <fo:inline>
                            <xsl:call-template name="getAttributeSet">
                                <xsl:with-param name="prmAttrSetName" select="'atsNormal'"/>
                            </xsl:call-template>
                            <xsl:call-template name="getVarValue">
                                <xsl:with-param name="prmVarName" select="'TableHeaderContinuationWord'"/>
                            </xsl:call-template>
                        </fo:inline>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$prmTableTitle">
                            <xsl:with-param name="prmGenContinuedWord" select="true()"/>
                            <xsl:with-param name="prmOutputContinuedWordInTableTitle" select="false()"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:marker>
            <fo:marker marker-class-name="{$mcTableHeaderTableDesc}"/>
        </xsl:if>
        <xsl:if test="$isLastRow and $isFirstCell and $prmOutputContinuedWordInTableFooter">
            <fo:marker marker-class-name="{$mcTableFooterContinuedWord}"/>
        </xsl:if>
    </xsl:template>

    <!-- 
     function:  get XSL-FO property from CALS table entry attributes
     param:     prmEntry, prmRowAttr, prmColSpec
     return:    attribute()*
     note:      DITA-OT 1.5 sets correct @colname to every entry element.
                This stylesheet use this functionality.
                The evaluation order:
                1. Inherit value
                2. Colsepc value
                3. Entry value (most honored)
     -->
    <xsl:function name="ahf:getEntryAttr" as="attribute()*">
        <xsl:param name="prmEntry"        as="element()"/>
        <xsl:param name="prmRowAttr"      as="element()"/>
        <xsl:param name="prmColSpec"      as="element()*"/>
        
        <xsl:variable name="colName" as="xs:string" select="string($prmEntry/@colname)"/>
        <xsl:variable name="colSpec" as="element()?" select="$prmColSpec[string(@ahf:column-name) eq $colName][1]"/>
        
        <!-- colsep -->
        <xsl:choose>
            <xsl:when test="string($prmRowAttr/@colsep) eq '0'">
                <xsl:attribute name="border-end-style" select="'none'"/>
            </xsl:when>
            <xsl:when test="string($prmRowAttr/@colsep) eq '1'">
                <xsl:attribute name="border-end-style" select="'solid'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="exists($colSpec/@border-end-style)">
            <xsl:attribute name="border-end-style" select="'from-table-column()'"/>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="string($prmEntry/@colsep) eq '0'">
                <xsl:attribute name="border-end-style" select="'none'"/>
            </xsl:when>
            <xsl:when test="string($prmEntry/@colsep) eq '1'">
                <xsl:attribute name="border-end-style" select="'solid'"/>
            </xsl:when>
        </xsl:choose>
        
        <!-- rowsep -->
        <xsl:choose>
            <xsl:when test="string($prmRowAttr/@rowsep) eq '0'">
                <xsl:attribute name="border-after-style" select="'none'"/>
            </xsl:when>
            <xsl:when test="string($prmRowAttr/@rowsep) eq '1'">
                <xsl:attribute name="border-after-style" select="'solid'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="exists($colSpec/@border-after-style)">
            <xsl:attribute name="border-after-style" select="'from-table-column()'"/>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="string($prmEntry/@rowsep) eq '0'">
                <xsl:attribute name="border-after-style" select="'none'"/>
            </xsl:when>
            <xsl:when test="string($prmEntry/@rowsep) eq '1'">
                <xsl:attribute name="border-after-style" select="'solid'"/>
            </xsl:when>
        </xsl:choose>
        
        <!-- rowheader -->
        <xsl:choose>
            <xsl:when test="(string($prmRowAttr/@rowheader) eq 'firstcol') and ($colName='col1')">
                <xsl:sequence select="ahf:getAttributeSet('atsHeaderRow')"/>
            </xsl:when>
            <xsl:when test="string($colSpec/@ahs:rowheader) eq 'headers'">
                <xsl:sequence select="ahf:getAttributeSet('atsHeaderRow')"/>
            </xsl:when>
        </xsl:choose>
        
        <!-- align -->
        <xsl:if test="exists($colSpec/@text-align)">
            <xsl:attribute name="text-align" select="'from-table-column()'"/>
        </xsl:if>
        <xsl:if test="exists($prmEntry/@align)">
            <xsl:variable name="align" as="xs:string" select="string($prmEntry/@align)"/>
            <xsl:choose>
                <xsl:when test="$align eq 'char'">
                    <xsl:variable name="char" select="string($prmEntry/@char)"/>
                    <xsl:choose>
                        <xsl:when test="string($char)">
                            <xsl:attribute name="text-align" select="$char"/>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="text-align" select="$align"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        
        <!-- valign -->
        <xsl:if test="exists($prmRowAttr/@valign)">
            <xsl:variable name="valign" as="xs:string" select="string($prmRowAttr/@valign)"/>
            <xsl:choose>
                <xsl:when test="$valign eq 'top'">
                    <xsl:attribute name="display-align" select="'before'"/>
                </xsl:when>
                <xsl:when test="$valign eq 'bottom'">
                    <xsl:attribute name="display-align" select="'after'"/>
                </xsl:when>
                <xsl:when test="$valign eq 'middle'">
                    <xsl:attribute name="display-align" select="'center'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="exists($prmEntry/@valign)">
            <xsl:variable name="valign" as="xs:string" select="string($prmEntry/@valign)"/>
            <xsl:choose>
                <xsl:when test="$valign eq 'top'">
                    <xsl:attribute name="display-align" select="'before'"/>
                </xsl:when>
                <xsl:when test="$valign eq 'bottom'">
                    <xsl:attribute name="display-align" select="'after'"/>
                </xsl:when>
                <xsl:when test="$valign eq 'middle'">
                    <xsl:attribute name="display-align" select="'center'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        
        <!-- namest,nameend -->
        <xsl:if test="exists($prmEntry/@namest) and exists($prmEntry/@nameend)">
            <xsl:variable name="startpos" as="xs:integer">
                <xsl:variable name="tempStartPos" as="xs:string" select="string($prmColSpec[string(@ahf:column-name) eq string($prmEntry/@namest)]/@column-number)"/>
                <xsl:choose>
                    <xsl:when test="$tempStartPos castable as xs:integer">
                        <xsl:sequence select="$tempStartPos cast as xs:integer"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="warningContinue">
                            <xsl:with-param name="prmMes" select="ahf:replace($stMes654,('%namest','%xtrf'),(string($prmEntry/@namest),string($prmEntry/@xtrf)))"/>
                        </xsl:call-template>
                        <xsl:sequence select="0"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="endpos"   as="xs:integer">
                <xsl:variable name="tempEndPos" as="xs:string" select="string($prmColSpec[string(@ahf:column-name) eq string($prmEntry/@nameend)]/@column-number)"/>
                <xsl:choose>
                    <xsl:when test="$tempEndPos castable as xs:integer">
                        <xsl:sequence select="$tempEndPos cast as xs:integer"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="warningContinue">
                            <xsl:with-param name="prmMes" select="ahf:replace($stMes656,('%nameend','%xtrf'),(string($prmEntry/@nameend),string($prmEntry/@xtrf)))"/>
                        </xsl:call-template>
                        <xsl:sequence select="0"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="$startpos ne 0 and $endpos ne 0">
                <xsl:variable name="spancolumns" as="xs:integer" select="$endpos - $startpos + 1"/>
                <xsl:choose>
                    <xsl:when test="$spancolumns gt 0">
                        <xsl:attribute name="number-columns-spanned" select="string($spancolumns)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="warningContinue">
                            <xsl:with-param name="prmMes" select="ahf:replace($stMes660,('%namest','%nameend','%xtrf'),(string($prmEntry/@namest),string($prmEntry/@nameend),string($prmEntry/@xtrf)))"/>
                        </xsl:call-template>
                        <xsl:sequence select="()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
    
        <!-- morerows -->
        <xsl:if test="exists($prmEntry/@morerows)">
            <xsl:variable name="tempMoreRows" as="xs:string" select="string($prmEntry/@morerows)"/>
            <xsl:choose>
                <xsl:when test="$tempMoreRows castable as xs:integer">
                    <xsl:variable name="moreRows" as="xs:integer" select="$tempMoreRows cast as xs:integer"/>
                    <xsl:attribute name="number-rows-spanned" select="string(1 + $moreRows)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="warningContinue">
                        <xsl:with-param name="prmMes" select="ahf:replace($stMes658,('%morerows','%xtrf'),(string($prmEntry/@morerows),string($prmEntry/@xtrf)))"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        
    </xsl:function>
    
    <!-- 
     function:  inherit colspec property to table entry
     param:     prmColName, prmColSpec
     return:    attribute()*
     note:      DITA-OT 1.5 sets correct @colname to every entry element.
                This stylesheet use this functionality.
                $prmColspec contains fo:table-column obuject with properties.
     -->
    <xsl:function name="ahf:getColSpecAttr" as="attribute()*">
        <xsl:param name="prmColName"  as="xs:string"/>
        <xsl:param name="prmColSpec"  as="element()*"/>
    
        <xsl:variable name="colSpec" as="element()?" select="$prmColSpec[string(@ahf:column-name) eq $prmColName][1]"/>
        
        <xsl:if test="exists($colSpec)">
            <xsl:if test="exists($colSpec/@border-end-style)">
                <xsl:attribute name="border-end-style" select="'from-table-column()'"/>
            </xsl:if>
        
            <xsl:if test="exists($colSpec/@border-after-style)">
                <xsl:attribute name="border-after-style" select="'from-table-column()'"/>
            </xsl:if>
        
            <xsl:if test="exists($colSpec/@text-align)">
                <xsl:attribute name="text-align" select="'from-table-column()'"/>
            </xsl:if>
    
            <!-- Does not support charoff -->
            <!--xsl:if test="exists($colSpec/@start-indent)">
                <xsl:attribute name="start-indent" select="'from-table-column()'"/>
            </xsl:if-->
        </xsl:if>
    </xsl:function>
    
    
    <!-- **************************** 
            Simple Table Templates
         ****************************-->
    <!-- 
     function:  simpletable template
     param:	    
     return:    fo:table
     note:		
     -->
    <xsl:template match="*[contains(@class, ' topic/simpletable ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsSimpleTable'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/simpletable ')]">
        <xsl:variable name="keyCol" select="ahf:getKeyCol(.)" as="xs:integer"/>
        <xsl:variable name="simpleTableAttr" as="attribute()*">
            <xsl:call-template name="getAttributeSetWithLang"/>
        </xsl:variable>
        <fo:table-and-caption>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)[name() eq 'text-align']"/>
            <fo:table>
                <xsl:copy-of select="$simpleTableAttr"/>
                <xsl:copy-of select="ahf:getDisplayAtts(.,$simpleTableAttr)"/>
                <xsl:call-template name="ahf:getUnivAtts"/>
                <xsl:copy-of select="ahf:getFoStyleAndProperty(.)[name() ne 'text-align']"/>
                <xsl:if test="exists(@relcolwidth)">
                    <xsl:copy-of select="ahf:getAttributeSet('atsSimpleTableFixed')"/>
                    <xsl:call-template name="processRelColWidth">
                        <xsl:with-param name="prmRelColWidth" select="string(@relcolwidth)"/>
                        <xsl:with-param name="prmTable" select="."/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:apply-templates select="*[contains(@class,' topic/sthead ')]">
                    <xsl:with-param name="prmKeyCol" tunnel="yes" select="$keyCol"/>
                </xsl:apply-templates>
                <fo:table-body>
                    <xsl:call-template name="getAttributeSetWithLang">
                        <xsl:with-param name="prmAttrSetName" select="'atsSimpleTableBody'"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="*[contains(@class,' topic/strow ')]">
                        <xsl:with-param name="prmKeyCol" tunnel="yes" select="$keyCol"/>
                    </xsl:apply-templates>
                </fo:table-body>
            </fo:table>
        </fo:table-and-caption>
        <xsl:if test="not($pDisplayFnAtEndOfTopic)">
            <xsl:call-template name="makeFootNote">
                <xsl:with-param name="prmElement"  select="."/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- 
     function:  sthead template
     param:     prmKeyCol
     return:    fo:table-header
     note:      sthead is optional.
                This stylesheet apply bold for sthead if simpletable/@keycol is not defined.
     -->
    <xsl:template match="*[contains(@class, ' topic/sthead ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsSimpleTableHeader'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/sthead ')]">
        <xsl:param name="prmKeyCol"  required="yes" tunnel="yes" as="xs:integer"/>
        
        <fo:table-header>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <fo:table-row>
                <xsl:call-template name="getAttributeSetWithLang">
                    <xsl:with-param name="prmAttrSetName" select="'atsSimpleTableRow'"/>
                </xsl:call-template>
                <xsl:apply-templates>
                    <xsl:with-param name="prmKeyCol"   select="$prmKeyCol"/>
                </xsl:apply-templates>
            </fo:table-row>
        </fo:table-header>
    </xsl:template>
    
    <!-- 
     function:  stentry template
     param:     prmKeyCol
     return:    stentry contents (fo:table-cell)
     note:      none
     -->
    <xsl:template match="*[contains(@class, ' topic/sthead ')]/*[contains(@class, ' topic/stentry ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsSimpleTableHeaderCell'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/sthead ')]/*[contains(@class, ' topic/stentry ')]">
        <xsl:param name="prmKeyCol"   required="yes" tunnel="yes" as="xs:integer"/>
        <fo:table-cell>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:choose>
                <xsl:when test="$prmKeyCol = count(preceding-sibling::*[contains(@class, ' topic/stentry ')]) + 1">
                    <xsl:call-template name="getAttributeSetWithLang">
                        <xsl:with-param name="prmAttrSetName" select="'atsPropertyTableKeyCol'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$prmKeyCol != 0">
                    <xsl:call-template name="getAttributeSetWithLang">
                        <xsl:with-param name="prmAttrSetName" select="'atsPropertyTableNoKeyCol'"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <fo:block>
                <xsl:call-template name="ahf:getUnivAtts"/>
                <xsl:apply-templates/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/strow ')]/*[contains(@class, ' topic/stentry ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsSimpleTableBodyCell'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/strow ')]/*[contains(@class, ' topic/stentry ')]">
        <xsl:param name="prmKeyCol"   required="yes" tunnel="yes" as="xs:integer"/>
        <fo:table-cell>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:choose>
                <xsl:when test="$prmKeyCol = count(preceding-sibling::*[contains(@class, ' topic/stentry ')]) + 1">
                    <xsl:call-template name="getAttributeSetWithLang">
                        <xsl:with-param name="prmAttrSetName" select="'atsPropertyTableKeyCol'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="getAttributeSetWithLang">
                        <xsl:with-param name="prmAttrSetName" select="'atsPropertyTableNoKeyCol'"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <fo:block>
                <xsl:call-template name="ahf:getUnivAtts"/>
                <xsl:apply-templates/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>
    
    
    <!-- 
     function:  strow template
     param:     prmKeyCol
     return:    fo:table-row
     note:      none
     -->
    <xsl:template match="*[contains(@class, ' topic/strow ')]" mode="MODE_GET_STYLE" as="xs:string*">
        <xsl:sequence select="'atsSimpleTableRow'"/>
    </xsl:template>    

    <xsl:template match="*[contains(@class, ' topic/strow ')]">
        <xsl:param name="prmKeyCol"   required="yes" tunnel="yes" as="xs:integer"/>
        <fo:table-row>
            <xsl:call-template name="getAttributeSetWithLang"/>
            <xsl:call-template name="ahf:getUnivAtts"/>
            <xsl:copy-of select="ahf:getFoStyleAndProperty(.)"/>
            <xsl:apply-templates>
                <xsl:with-param name="prmKeyCol" tunnel="yes" select="$prmKeyCol"/>
            </xsl:apply-templates>
        </fo:table-row>
    </xsl:template>
    
    
    <!-- *************************************** 
            Table related common templates
         ***************************************-->
    <!-- 
     function:  get @keycol value and return it.
     param:     prmTable
     return:    integer
     note:		
     -->
    <xsl:function name="ahf:getKeyCol" as="xs:integer">
        <xsl:param name="prmTable" as="element()"/>
        
        <xsl:variable name="keyCol" select="if ($prmTable/@keycol) then string($prmTable/@keycol) else '0'" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$keyCol castable as xs:integer">
                <xsl:choose>
                    <xsl:when test="xs:integer($keyCol) ge 0">
                        <xsl:sequence select="xs:integer($keyCol)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="warningContinue">
                            <xsl:with-param name="prmMes" 
                            select="ahf:replace($stMes050,('%file','%elem','%keycol'),(string($prmTable/@xtrf),name($prmTable),string($prmTable/@keycol)))"/>
                        </xsl:call-template>
                        <xsl:sequence select="0"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="warningContinue">
                    <xsl:with-param name="prmMes" 
                    select="ahf:replace($stMes050,('%file','%elem','%keycol'),(string($prmTable/@xtrf),name($prmTable),string($prmTable/@keycol)))"/>
                </xsl:call-template>
                <xsl:sequence select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
     function:  @relcolwidth processing
     param:     prmRelColWidth, prmTable
     return:    fo:table-column
     note:		
     -->
    <xsl:template name="processRelColWidth">
        <xsl:param name="prmRelColWidth" required="yes" as="xs:string"/>
        <xsl:param name="prmTable"  required="yes" as="element()"/>
        
        <xsl:for-each select="tokenize(string($prmRelColWidth), '[\s]+')">
            <xsl:variable name="relColWidth"  select="string(.)"/>
            <xsl:variable name="relColNumber" select="position()"/>
            <fo:table-column>
                <xsl:attribute name="column-number">
                    <xsl:value-of select="$relColNumber"/>
                </xsl:attribute>
                <xsl:attribute name="column-width">
                    <!-- Get column width format string in XSL-FO -->
                    <xsl:call-template name="calc.column.width">
                        <xsl:with-param name="colwidth" select="$relColWidth"/>
                    </xsl:call-template>
                </xsl:attribute>
            </fo:table-column>
        </xsl:for-each>
    </xsl:template>
    
    
    <!-- 
     function:  Calculate column width template
     param:     colwidth
     return:	column width attribute value
     note:      This template is from W3C XSL specification.
     -->
    <xsl:template name="calc.column.width">
        <xsl:param name="colwidth">1*</xsl:param>
        <!-- Ok, the colwidth could have any one of the following forms: -->
        <!--        1*       = proportional width -->
        <!--     1unit       = 1.0 units wide -->
        <!--         1       = 1pt wide -->
        <!--  1*+1unit       = proportional width + some fixed width -->
        <!--      1*+1       = proportional width + some fixed width -->
        <!-- If it has a proportional width, translate it to XSL -->
        <xsl:if test="contains($colwidth, '*')">
          <!-- modified to handle "*" as input -->
          <xsl:variable name="colfactor">
            <xsl:value-of select="substring-before($colwidth, '*')"/>
          </xsl:variable>
          <xsl:text>proportional-column-width(</xsl:text>
          <xsl:choose>
            <xsl:when test="not($colfactor = '')">
              <xsl:value-of select="$colfactor"/>
            </xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
          </xsl:choose>
          <xsl:text>)</xsl:text>
        </xsl:if>
        <!-- Now get the non-proportional part of the specification -->
        <xsl:variable name="width-units">
          <xsl:choose>
            <xsl:when test="contains($colwidth, '*')">
              <xsl:value-of select="normalize-space(substring-after($colwidth, '*'))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space($colwidth)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- Now the width-units could have any one of the following forms: -->
        <!--                 = <empty string> -->
        <!--     1unit       = 1.0 units wide -->
        <!--         1       = 1pt wide -->
        <!-- with an optional leading sign -->
        <!-- Get the width part by blanking out the units part and discarding -->
        <!-- white space. -->
        <xsl:variable name="width" select="normalize-space(translate($width-units,                           '+-0123456789.abcdefghijklmnopqrstuvwxyz',                           '+-0123456789.'))"/>
        <!-- Get the units part by blanking out the width part and discarding -->
        <!-- white space. -->
        <xsl:variable name="units" select="normalize-space(translate($width-units,                           'abcdefghijklmnopqrstuvwxyz+-0123456789.',                           'abcdefghijklmnopqrstuvwxyz'))"/>
        <!-- Output the width -->
        <xsl:value-of select="$width"/>
        <!-- Output the units, translated appropriately -->
        <xsl:choose>
          <xsl:when test="$units = 'pi'">pc</xsl:when>
          <xsl:when test="$units = '' and $width != ''">pt</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$units"/>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
     function:  Generate table title prefix
     param:     prmTopicRef, prmTable
     return:    Table title prefix
     note:		
     -->
    <xsl:template name="ahf:getTableTitlePrefix" as="xs:string">
        <xsl:param name="prmTopicRef" tunnel="yes" required="yes" as="element()"/>
        <xsl:param name="prmTable" required="no" as="element()" select="."/>
        
        <xsl:variable name="titlePrefix" as="xs:string">
            <xsl:choose>
                <xsl:when test="$pAddNumberingTitlePrefix">
                    <xsl:variable name="tableGroupingLevelMax" as="xs:integer" select="ahf:getTableNumberingGroupLevel($prmTopicRef)"/>
                    <xsl:variable name="titlePrefixPart" select="ahf:genLevelTitlePrefixByCount($prmTopicRef,$tableGroupingLevelMax)"/>
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
        
        <xsl:variable name="topic" select="$prmTable/ancestor::*[contains(@class, ' topic/topic ')][position() eq last()]"/>
        
        <xsl:variable name="tablePreviousAmount" as="xs:integer">
            <xsl:sequence select="ahf:getTablePreviousAmount($topic,$prmTopicRef)"/>
        </xsl:variable>
        
        <xsl:variable name="tableCurrentAmount"  as="xs:integer">
            <xsl:sequence select="count($topic//*[contains(@class,' topic/table ')][child::*[contains(@class, ' topic/title ')]][. &lt;&lt; $prmTable]|$prmTable)"/>
        </xsl:variable>
        
        <xsl:variable name="tableNumber" select="$tablePreviousAmount + $tableCurrentAmount" as="xs:integer"/>
        
        <xsl:sequence select="concat($cTableTitle,$titlePrefix,string($tableNumber))"/>
    </xsl:template>

    <xsl:function name="ahf:getTableTitlePrefix" as="xs:string">
        <xsl:param name="prmTopicRef" as="element()"/>
        <xsl:param name="prmTable" as="element()"/>
        
        <xsl:call-template name="ahf:getTableTitlePrefix">
            <xsl:with-param name="prmTopicRef" tunnel="yes" select="$prmTopicRef"/>
            <xsl:with-param name="prmTable" select="$prmTable"/>
        </xsl:call-template>
    </xsl:function>

</xsl:stylesheet>