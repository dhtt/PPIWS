<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html lang="en">
<head>
    <title>PPICompare</title>
    <link rel="shortcut icon" href="resources/PPIN_logo.png">
    <link rel="stylesheet" href="css/interface.css">
    <link rel="stylesheet" href="css/header-and-panel.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.0/FileSaver.min.js"> </script>
    <script type="module" src="js/help-page-functionality_PPICompare.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<jsp:include page="html/header_PPICompare.html"/>
<div>
    <div id="AllPanels" class="container-body">
        <div style="flex: 0 0 280px; margin-left: 1em; position: fixed">
            <div id="MenuPanel" class="menu panel shadow" style="position: relative; padding: 0; border-radius: 1em; margin-top: 1em">
                <div>
                    <p name="HelpMenu" id="Instruction" class="help-panel DefaultHelpMenu" style="border-radius: 1em 1em 0 0;">Instruction</p>
                    <p name="HelpMenu" id="CondPPINData" class="help-panel-sub">PPIXpress condition-specific network</p>
                    <p name="HelpMenu" id="PPINData" class="help-panel-sub">Protein-protein interaction network</p>
                    <p name="HelpMenu" id="DDINData" class="help-panel-sub">Domain-domain interaction network</p>
                    <p name="HelpMenu" id="MajorTranscriptData" class="help-panel-sub">Major transcript file</p>
                    <p name="HelpMenu" id="ExampleRunSetting" class="help-panel-sub">Example set-up</p>
                    
                </div>
                <div>
                    <p name="HelpMenu" id="PPICompareOutput" class="help-panel">PPICompare Output</p>
                    <p name="HelpMenu" id="PipelineLogFile" class="help-panel-sub">Pipeline log file</p>
                    <p name="HelpMenu" id="MainOutputFile" class="help-panel-sub">Main output file</p>
                    <p name="HelpMenu" id="NetworkVisualization" class="help-panel-sub">Network visualization</p>
                </div>
                <div>
                    <p name="HelpMenu" id="PPICompareStandaloneTool" class="help-panel">PPICompare Standalone Tool</p>
                    <p name="HelpMenu" id="Download" class="help-panel-sub">Download</p>
                    <p name="HelpMenu" id="Documentation" class="help-panel-sub">Documentation</p>
                </div>
                <div>
                    <p name="HelpMenu" id="CitationAndContact" class="help-panel">Citation & Contact</p>
                    <p name="HelpMenu" id="Citation" class="help-panel-sub">Citation</p>
                    <p name="HelpMenu" id="Contact" class="help-panel-sub" style="border-radius: 0 0 1em 1em;">Contact</p>
                </div>
            </div>
            <div name="ScrollToTop" class=" reset" style="text-align: center; position: relative; padding: 0; border-radius: 1em; margin-top: 1em">Scroll to top</div>
        </div>
        <div id="RightPanel" class="middle-under-info-page" style="flex: 1; display: flex; flex-flow: column">
            <div id="toInstruction">
                <p class="menu header help-section-title">Instruction</p>
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <span id="toCondPPINData" class="level-1-heading">Condition-specific networks interaction data</span><br>
                    
                        The mandatory input consists of <strong>two</strong> groups of networks constructed with PPIXpress in zipped format (.zip/.gz/.gzip).
                        The PPIXpress output data needs to comprise the according 
                        <a href="./info_page_PPICompare.jsp#toCondPPINData" class="href_to_section">protein-protein interaction networks</a>, 
                        <a href="./info_page_PPICompare.jsp#toCondDDINData" class="href_to_section">domain-domain interaction networks</a>, and the
                        <a href="./info_page_PPICompare.jsp#toMajorTranscriptData" class="href_to_section">major transcript files</a> 
                        with the file suffixes as predefined by 
                        <a href="./index_PPIXpress.jsp" class="href_to_section">PPIXpress webserver</a> or 
                        <a href="https://sourceforge.net/projects/ppixpress/" class="href_to_section">PPIXpress standalone tool</a>.<br><br>

                        <strong>Example</strong>:
                        <a href="./resources/PPICompare/HSC.zip" download="HSC.zip" class="href_to_section">HSC.zip</a> and 
                        <a href="./resources/PPICompare/MPP.zip" download="MPP.zip" class="href_to_section">MPP.zip</a> are two groups of networks constructed with PPIXpress in zipped format. 
                        <ul>
                            <li><strong>HSC.zip</strong> contains 5 samples (<i>Cord_blood-M-C002UU, Cord_blood-U-C07002, Cord_blood-U-C12001_ddin, Cord_blood-U-S001FX, Cord_blood-U-S001QB and Cord_blood-U-S0025C</i>).
                                The names of those samples are used as the suffix of the PPIN, DDIN and major transcripts list files.</li>
                            <li>Similarly, <strong>MPP.zip</strong> contains 3 samples (<i>Cord_blood-M-C002UU, Cord_blood-U-C07015 and Cord_blood-U-S001FX</i>). 
                                Their PPINs, DDINs and major transcripts list are named accordingly.</li>
                            <li><strong>*_ppin.txt</strong>, <strong>*_ddin.txt</strong> and <strong>*_major-transcripts.txt</strong> are the condition-specific 
                                protein interaction network, domain-domain interaction network and list of major transcript per protein built using the listed samples.</li>
                        </ul><br>


                        <i>Note:</i><br>  
                        If the inputs are forwarded from PPIXpress Webserver, by default, the asterisk (*) is a number (1, 2, 3,...) indicating the expression data which the reference network uses to prune.<br>
                        This number corresponds to the <strong>Sample</strong> and <strong>Matched output field</strong> in <strong>Sample summary file</strong>.<br>
                        Read more about PPIXpress output <a href="./info_page.jsp#toMainOutputFile" class="href_to_section">here</a>.<br><br>
          
                    </div>
                    <div class="help-section-body">
                        <span id="toPPINData" class="level-1-heading">Protein-protein interaction network</span><br>
                        Condition-specific protein interaction network file must be named <strong>*_ppin.txt(.gz)</strong> and contain the tab-separated information as below:<br>
                        <span style="text-align: center">
                            <table class="table-2">
                                <thead>
                                    <tr>
                                        <td>Protein 1</td>
                                        <td>Protein 2</td>
                                        <td>weight</td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th>Q9NUQ3</th>
                                        <th>Q9UNE7</th>
                                        <th>1.0</th>
                                    </tr>
                                    <tr>
                                        <th>Q9NXF1</th>
                                        <th>Q9UL18</th>
                                        <th>1.0</th>
                                    </tr>
                                    <tr>
                                        <th>...</th>
                                        <th>...</th>
                                        <th>...</th>
                                    </tr>
                                </tbody>
                            </table>
                        </span>
                    </div>
                    <div class="help-section-body">
                        <span id="toDDINData" class="level-1-heading">Domain-domain interaction network</span><br>
                        Condition-specific domain interaction network file must be named <strong>*_ddin.txt(.gz)</strong> and contain the tab-separated information as below:<br>
                        <span style="text-align: center">
                            <table class="table-2">
                                <thead>
                                    <tr>
                                        <td>Protein/Domain1</td>
                                        <td>Domain2</td>
                                        <td>IAType</td>
                                        <td>Weight</td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th>Q9UKT9</th>
                                        <th>0|FB|Q9UKT9</th>
                                        <th>pd</th>
                                        <th>10</th>
                                    </tr>
                                    <tr>
                                        <th>Q9UKT9</th>
                                        <th>1|PF00096|Q9UKT9</th>
                                        <th>pd</th>
                                        <th>10</th>
                                    </tr>
                                    <tr>
                                        <th>...</th>
                                        <th>...</th>
                                        <th>...</th>
                                        <th>...</th>
                                    </tr>
                                </tbody>
                            </table>
                        </span>
                    </div>
                    <div class="help-section-body">
                        <span id="toMajorTranscriptData" class="level-1-heading">Major transcript file</span><br>
                        The list of major transcript per protein in the condition-specific protein interaction network must be named 
                        <strong>*_major-transcripts.txt(.gz)</strong> and contain the tab-separated information as below:<br>
                        <span style="text-align: center">
                            <table class="table-2">
                                <thead>
                                    <tr>
                                        <td>Protein</td>
                                        <td>EnsemblID</td>
                                        <td>Expression</td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th>Q9UKT9</th>
                                        <th>ENST00000346872</th>
                                        <th>8.425746</th>
                                        </th>
                                    </tr>
                                    <tr>
                                        <th>Q9UKT8</th>
                                        <th>ENST00000608872</th>
                                        <th>13.324804</th>
                                    </tr>
                                    <tr>
                                        <th>P54852</th>
                                        <th>ENST00000597279</th>
                                        <th>6.8656335</th>
                                    </tr>
                                    <tr>
                                        <th>...</th>
                                        <th>...</th>
                                        <th>...</th>
                                    </tr>
                                </tbody>
                            </table>
                        </span>
                    </div>
                    <div class="help-section-body">
                        <span id="toExampleRunSetting" class="level-1-heading">Examples for run set-up</span><br>
                        <div style="display: flex; flex-direction: row; align-items: center">
                            <div style="flex: 1">
                                <table name="TableExampleRunSetting" class="table-2">
                                    <tbody>
                                    <tr><th style="font-weight: bold">Group1</th></tr>
                                    <tr><th>&emsp;- <a href="./resources/PPICompare/MPP.zip" download="MPP.zip" class="href_to_section">MPP.zip</a></th></tr>
                                    <tr><th style="font-weight: bold">Group 2</th></tr>
                                    <tr><th>&emsp;- <a href="./resources/PPICompare/HSC.zip" download="HSC.zip" class="href_to_section">HSC.zip</a></th></tr>
                                    <tr><th class="level-3-heading">Return protein attribute table</th></tr>
                                    <tr><th class="level-3-heading">FDR: 0.05</th></tr>
                                    </tbody>
                                </table>
                            </div>
                            <div style="flex: 2.8">
                                <span class="level-2-heading">EXAMPLE</span> (Try PPICompare with these data on our main page!)<br>
                                <ul>
                                    <li><strong>HSC.zip</strong> and <strong>MPP.zip</strong> contain the PPINs, DDINs and major transcripts lists specific for samples of hematopoietic stem cells (HSC) and 
                                        multipotent progenitors (MPP), respectively. Those PPIN, DDIN and major transcripts list are outputs from PPIXpress analysis.</li>
                                    <li><strong>HSC.zip</strong> contains 6 samples (Cord_blood-M-C002UU, Cord_blood-U-C07002, Cord_blood-U-C12001_ddin, Cord_blood-U-S001FX, Cord_blood-U-S001QB and Cord_blood-U-S0025C).
                                        The names of those samples are used as the suffix of the PPIN, DDIN and major transcripts list files.</li>
                                    <li>Similarly, <strong>MPP.zip</strong> contains 3 samples (Cord_blood-M-C002UU, Cord_blood-U-C07015 and Cord_blood-U-S001FX). 
                                        Their PPINs, DDINs and major transcripts list are named accordingly.</li>
                                    <li>PPICompare then determines all significantly rewired interactions between the groups defined by the input data with a false discovery rate of 0.05
                                        and returns the differential network between HSC and MPP samples. The protein attributes are retrieved from Ensembl database.</li>
                                </ul> 
                                
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <div id="toPPICompareOutput">
                <p class="menu header help-section-title">PPICompare Output</p>
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <div id="AfterRunOptions_Example"></div>

                        <span id="toPipelineLogFile" class="level-1-heading">Pipeline log file</span><br>
                        Once the PPICompare run is finished, select <strong>Download Log File</strong> to download the log containing
                        run configurations.<br><br>
            
                        <span id="toMainOutputFile" class="level-1-heading">Main output file</span><br>
                        Select <strong>Download Result Files</strong> to download main output files, including:<br>
                        <ul>
                            <li><strong>differential network.txt</strong>: List of all significantly rewired interactions between the groups.</li>
                            <li><strong>min_reasons.txt.txt</strong>: A minimal set of transcriptomic alterations that explain all the significant rewiring and is most likely given the data is determined.</li>
                            <li><strong>protein_attributes.txt</strong>: Protein attributes retrieved from Ensembl database, including: 
                                <ul>
                                    <li><i>UniProt ACC</i>: UniProt accession of the protein.</li>
                                    <li><i>Gene name</i>: Gene name associated with the protein.</li>
                                    <li><i>Part of min reasons</i>: Is a transcriptomic alteration of this protein part of the min. reasons set (yes/no).</li>
                                    <li><i>Alteration type</i>: The type of the most relevant transcriptomic alteration (DE/AS, if any).</li>
                                    <li><i>Transcriptomic alteration</i>: Exact transcriptomic alteration as loss/gain (DE) between groups or exact transcript switch (AS).</li>
                                    <li><i>Score</i>: Internally used importance-score defined by the number of occurrences of the alteration above across all comparisons and all rewiring events.</li>
                                </ul>
                            </li>
                        </ul><br>
            
                        <span id="toNetworkVisualization" class="level-1-heading">Network visualization</span><br>
                        Select <strong>Visualize Condition-Specific Networks</strong> to open <strong>Network Visualization</strong> tab and click 
                        <button type="button" value="null" class="button graph-menu-button upload">Show</button>
                        to display the differential PPI network that distinguish two samples or conditions.<br>
                    
                        <!-- TODO: New video -->
                        <div style="display: flex; flex-direction: column; align-items: center; padding: 1em">
                            <iframe width="560" height="315" src="https://www.youtube.com/embed/dtd_xM0fgQI?si=VAcQl8u6Jm-qS-qc" title="Network Visualization in PPICompare" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
                        </div>
                    </div><br>
            </div>

            <div id="toPPICompareStandaloneTool">
                <p class="menu header help-section-title">PPICompare Standalone Tool</p>
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <span id="toDownload" class="level-1-heading">Download</span><br>
                        <span>The PPICompare standalone version is available on <a href="https://sourceforge.net/projects/ppicompare/" class="href_to_section">SourceForge</a>.</span>
                        <br>
                    </div>
                    <div class="help-section-body">
                        <span id="toDocumentation" class="level-1-heading">Documentation</span><br>
                        <span>The documentation to PPICompare standalone version is available on <a href="https://sourceforge.net/projects/ppicompare/" class="href_to_section">SourceForge</a>.</span>
                    </div>
                </div>
            </div>
            <div id="toCitationAndContact">
                <p class="menu header help-section-title">Citation & Contact</p>
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <span id="toCitation" class="level-1-heading">Citation</span><br>
                        <span>
                            <strong>Stand-alone software version</strong>: 
                            Will, T., & Helms, V. (2017). Rewiring of the inferred protein interactome during blood development studied with the tool PPICompare. BMC Systems Biology, 11, 1-19.
                            <a href="https://bmcsystbiol.biomedcentral.com/articles/10.1186/s12918-017-0400-x" target="_blank" class="href_to_section">[Link to paper]</a><br>
                            <!-- TODO: Add citation -->
                            <strong>Webserver version</strong>:
                            Do, H.T.T., & Helms, V. (2024)
                            <a href="" target="_blank" class="href_to_section">[Link to paper]</a><br>
                        </span> 
                    </div>
                    <div class="help-section-body">
                        <span id="toContact" class="level-1-heading">Contact</span><br>
                        <span>
                            <strong>Webserver support</strong>: dhttrang[at]bioinformatik.uni-saarland.de<br>
                            <strong>Corresponding author</strong>: volkhard.helms[at]bioinformatik.uni-saarland.de
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
