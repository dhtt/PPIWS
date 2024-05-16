<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html lang="en">
<head>
    <title>PPIXpress</title>
    <link rel="shortcut icon" href="resources/PPIN_logo.png">
    <link rel="stylesheet" href="css/interface.css">
    <link rel="stylesheet" href="css/header-and-panel.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.0/FileSaver.min.js"> </script>
    <script type="module" src="js/help-page-functionality.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<jsp:include page="html/header.html"/>
<div>
    <div id="AllPanels" class="container-body">
        <div style="flex: 0 0 280px; margin-left: 1em; position: fixed">
            <div id="MenuPanel" class="menu panel shadow" style="position: relative; padding: 0; border-radius: 1em; margin-top: 1em">
                <div>
                    <p name="HelpMenu" id="Instruction" class="help-panel DefaultHelpMenu" style="border-radius: 1em 1em 0 0;">Instruction</p>
                    <p name="HelpMenu" id="ProteinInteractionData" class="help-panel-sub">Protein interaction data</p>
                    <p name="HelpMenu" id="ExpressionData" class="help-panel-sub">Expression data</p>
                    <p name="HelpMenu" id="PPIXpressRunOptions" class="help-panel-sub">PPIXpress run options</p>
                    <p name="HelpMenu" id="ExampleRunSetting" class="help-panel-sub">Example set-up</p>
                </div>
                <div>
                    <p name="HelpMenu" id="PPIXpressOutput" class="help-panel">PPIXpress Output</p>
                    <p name="HelpMenu" id="SampleSummaryFile" class="help-panel-sub">Sample summary file</p>
                    <p name="HelpMenu" id="PipelineLogFile" class="help-panel-sub">Pipeline log file</p>
                    <p name="HelpMenu" id="MainOutputFile" class="help-panel-sub">Main output file</p>
                    <p name="HelpMenu" id="BuildDifferentialNetwork" class="help-panel-sub">Build differential network</p>
                    <p name="HelpMenu" id="SubnetworkVisualization" class="help-panel-sub">Subnetwork visualization</p>
                </div>
                <div>
                    <p name="HelpMenu" id="PPIXpressStandaloneTool" class="help-panel">PPIXpress Standalone Tool</p>
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
            <!--------------------------->
            <!-- SECTION toInstruction -->
            <!--------------------------->
            <div id="toInstruction">
                <p class="menu header help-section-title">Instruction</p>
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <!----------------------------------------->
                        <!-- SUBSECTION toProteinInteractionData -->
                        <!----------------------------------------->
                        <span id="toProteinInteractionData" class="level-1-heading">Protein interaction data</span>
                        <span>Generally, transcripts or genes in all files (with the exception of the TCGA formats) are assumed to be given as Ensembl identifiers. 
                            Proteins are assumed to be UniProt accessions or HGNC/Ensembl genes in the input network. 
                            Furthermore, compressed files should have the ending .gz.</span>
                        <br>
                        <ul>
                            <li>
                                <span class="level-2-heading">From file<br></span>
                                <span>
                                    PPIXpress accepts protein interaction data of Simple Interaction Format (SIF). SIF is a convenient format to describe a graph as a list of interactions.
                                    <br>PPIXpress expects interacting proteins pairs (UniProt accessions, Ensembl genes or HGNC gene symbols) line-by-line and optionally a weight.
                                    <br>A header is not necessary, if there is one it should be of the following form:
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
                                </span>
                                <span>
                                    <strong>Example</strong>: A protein-protein interaction network of physical interactions in human merged from data of IntAct (release 186), BioGRID (3.2.120) 
                                    and HPRD (r9) <a href="./resources/PPIXpress/example_data/example_ppi_data.sif" download="example_ppi_data.sif" class="href_to_section">example_ppi_data.sif</a>.
                                </span>
                            </li>
                            
                            <li>
                                <span class="level-2-heading">From web<br></span>
                                <span>
                                    Alternatively a network can be automatically retrieved from the current Mentha or IntAct databases.<br>
                                    <strong>Example</strong>: Type 9606 for a network in human.
                                </span>
                            </li>
                        </ul><br>
                    </div>
                    <div class="help-section-body">
                        <!--------------------------------->
                        <!-- SUBSECTION toExpressionData -->
                        <!--------------------------------->
                        <span id="toExpressionData" class="level-1-heading">Expression data</span>
                        <ul>
                            <li>
                                <span class="level-2-heading">Cufflinks (isoform/gene) FPKM tracking files</span>
                                Cufflinks (V2.x) creates FPKM tracking files with annotations according to a specified genome-annotation GTF file.<br>
                                If Ensembl/GENCODE annotation is used, those files can be immediately used by PPIXpress.<br>
                                <strong>Example</strong>: A FPKM tracking file built from publicly available Illumina Human BodyMap 2.0 data 
                                <a href="./resources/PPIXpress/example_data/brain.fpkm_tracking.gz" class="href_to_section" download="brain.fpkm_tracking.gz">brain.fpkm_tracking.gz</a> 
                                with the format:<br>
                                <table id="Table-Cufflinks" class="table-2">
                                    <thead>
                                        <tr>
                                            <td>tracking_id</td><td>class_code</td><td>nearest_ref_id</td><td>gene_id</td>
                                            <td>gene_short_name</td><td>tss_id</td><td>locus</td><td>length</td>
                                            <td>coverage</td><td>FPKM</td><td>FPKM_conf_lo</td><td>FPKM_conf_hi</td><td>FPKM_status</td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <th>ENST00000368372</th><th>-</th><th>-</th><th>ENSG00000229631</th>
                                            <th>AL603926.1</th><th>TSS84330</th><th>GL000223.1:149786-180454</th><th>1789</th>
                                            <th>6.76132</th><th>0.67731</th><th>0.55584</th><th>0.798781</th><th>OK</th>
                                        </tr>
                                        <tr>
                                            <th>...</th><th>...</th><th>...</th><th>...</th>
                                            <th>...</th><th>...</th><th>...</th><th>...</th>
                                            <th>...</th><th>...</th><th>...</th><th>...</th><th>...</th>
                                        </tr>
                                    </tbody>
                                </table>
                                <br>
                            </li>
                            <li>
                                <span class="level-2-heading">GENCODE GTF (transcript/gene) files<br></span>
                                <span>
                                    GENCODE GTF (transcript/gene) files from ENCODE project are accepted.<br>
                                    <strong>Example</strong>:
                                    <ul>
                                        <li><a href="http://genome.ucsc.edu/cgi-bin/hgFileUi?db=hg19&g=wgEncodeCaltechRnaSeq" class="href_to_section">RNA-seq from ENCODE/Caltech</a> (filter to genes/transcript GENCODE V3c)</li>
                                        <li><a href="http://genome.ucsc.edu/cgi-bin/hgFileUi?db=mm9&g=wgEncodeCshlLongRnaSeq" class="href_to_section">Long RNA-seq from ENCODE/Cold Spring Harbor Lab</a> (filter to Transcript Ensembl V65).</li>
                                        <li><a href="./resources/PPIXpress/example_data/mouse_brain.gtf.gz" class="href_to_section" download="mouse_brain.gtf.gz">mouse_brain.gtf.gz</a> from ENCODE with the format:<br></li>
                                    </ul> 
                                    <table id="Table-GTF" class="table-2">
                                        <thead>
                                            <tr>
                                                <th>chr9</th><th>ENSEMBL65</th><th>transcript</th><th>65952282</th><th>65953531</th><th>0.030601</th><th>-</th><th>.</th>
                                                <th>gene_id "ENSMUSG00000032382"; transcript_id "ENSMUST00000146893"; RPKM1 "0.023032"; RPKM2 "0.078775"; iIDR "0.072";</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <th>chr2</th><th>ENSEMBL65</th><th>transcript</th><th>32218530</th><th>32223048</th><th>1.581027</th><th>+</th><th>.</th>
                                                <th>gene_id "ENSMUSG00000039205"; transcript_id "ENSMUST00000132028"; RPKM1 "1.463149"; RPKM2 "3.796865"; iIDR "0.009";</th>
                                            </tr>
                                            <tr>
                                                <th>...</th><th>...</th><th>...</th><th>...</th><th>...</th><th>...</th><th>...</th><th>...</th><th>...</th>
                                            </tr>
                                        </tbody>
                                    </table>
                                </span><br>
                            </li>
                            <li>
                                <span class="level-2-heading">Kallisto (transcript/gene) files<br></span>
                                <span>
                                    PPIXpress uses the reported TPM value to quantify abundance.<br>
                                </span><br>
                            </li>
                            <li>
                                <span class="level-2-heading">RSEM (transcript/gene) files<br></span>
                                <span>
                                    <strong>Example</strong>: data from BLUEPRINT project (<a href="http://dcc.blueprint-epigenome.eu/#/home" class="href_to_section">BLUEPRINT DCC PORTAL</a>). 
                                    Here, PPIXpress also uses the reported TPM value (rather than FPKM) to quantify the abundance.<br>
                                </span><br>
                            </li>
                            <li>
                                <span class="level-2-heading">TCGA (RNA-seq V2) (isoform/gene) RSEM files<br></span>
                                <span>
                                    Normalized RNA-seq V2 files from TCGA are also a suitable expression input for the tool.<br>
                                    The files are assumed to hold TCGA expression data if the associated headers and identifier descriptions are found.<br>
                                    Specifically, gene expression data from TCGA should have the header:
                                    <table class="table-2">
                                        <thead>
                                            <tr>
                                                <td>gene_id</td>
                                                <td>normalized_count</td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <th>A1BG|1</th>
                                                <th>108.8347</th>
                                            </tr>
                                            <tr>
                                                <th>...</th>
                                                <th>...</th>
                                            </tr>
                                        </tbody>
                                    </table>
                                    and transcript expression data from TCGA should have the header:
                                    <table class="table-2">
                                        <thead>
                                            <tr>
                                                <td>isoform_id</td>
                                                <td>normalized_count</td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <th>uc010uoa.1</th>
                                                <th>0.0000</th>
                                            </tr>
                                            <tr>
                                                <th>...</th>
                                                <th>...</th>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <i>Note:</i><br> 
                                    - Gene annotations are converted from HGNC identifiers to Ensembl genes using the genenames.org-webservice<br> 
                                    - Transcripts are converted from UCSC transcripts to Ensembl transcripts using UCSC’s hg19 MySQL (including all updates to transcript versions).<br>
                                    - To ensure the best mapping possible, Ensembl data for assembly GRCh37 is automatically enforced.<br>
                                    - If Ensembl identifiers are found instead, a plain expression file (see below) with a header is assumed by PPIXpress.<br><br>

                                    <strong>Example</strong>: <a href="./resources/PPIXpress/example_data/BRCA_tumor.normalized_RSEM.gz" class="href_to_section">BRCA_tumor.normalized RSEM.gz</a> is a BRCA tumor sample taken from TCGA.<br>
                                </span><br>
                            </li>
                            <li>
                                <span class="level-2-heading">Plain transcript/gene expression text files<br></span>
                                <span>
                                    Expression data can also be supplied line-wise in a text file of the following format with arbitrary whitespaces:
                                    <table class="table-2">
                                        <tbody>
                                            <tr>
                                                <th>ENST00000584459</th>
                                                <th>123.456</th>
                                            </tr>
                                            <tr>
                                                <th>ENST00000451927</th>
                                                <th>42</th>
                                            </tr>
                                            <tr>
                                                <th>ENST00000582791</th>
                                                <th>0.0000021</th>
                                            </tr>
                                            <tr>
                                                <th>...</th>
                                                <th>...</th>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <i>Note:</i><br> 
                                    - Genes/transcript are assumed to be given as Ensembl identifiers and a header is not necessary.<br>
                                    - In the best case, every gene/transcript should only be reported once in the file.<br>
                                    - If the user’s original data contains multiple probes for the same gene/transcript, for example, he/she can decide in prior how those should be used (average, max,... ).<br>
                                    - However, if an identifier occurs multiple times throughout the file, only the last expression value is assigned to the gene/transcript and no processing takes place.<br>
                                </span>
                            </li>
                        </ul><br>
                    </div>
                    <div class="help-section-body">
                        <!-------------------------------------->
                        <!-- SUBSECTION toPPIXpressRunOptions -->
                        <!-------------------------------------->
                        <span id="toPPIXpressRunOptions" class="level-1-heading">PPIXpress run options</span>
                        <ul>
                            <li>
                                <span class="level-2-heading">Protein Interaction Data Options<br></span>
                                <ul>
                                    <li>
                                        <span class="level-3-heading">Add STRING weights: </span>
                                        <span>Adds weights to the original network using <a href="http://string-db.org/" class="href_to_section">STRING v10</a> (STRING weights are probabilities of functional association). Interactions that are not in STRING are removed from the network.</span>
                                        <br>
                                    </li>
                                    <li>
                                        <span class="level-3-heading">Update UniProt accessions: </span>
                                        <span>Update outdated UniProt accessions to their current primary accessions.</span>
                                        <br>
                                    </li>
                                    <li>
                                        <span class="level-3-heading">Only local DDI data: </span>
                                        <span>Only use local domain interaction data, thus current 3did data is not retrieved and only the precompiled set from DOMINE/IDDI/iPfam is used.</span>
                                        <br>
                                    </li>
                                    <li>
                                        <span class="level-3-heading">Include ELM data: </span>
                                        <span>Retrieve and integrate ELM motifs and interactions.</span>
                                        <br>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <span class="level-2-heading">Processed Expression Data Options<br></span>
                                <ul>
                                    <li>
                                        <span class="level-3-heading">Gene-level only: </span>
                                        <span>Enforces gene-level processing even if transcript expression data is given.</span>
                                        <br>
                                    </li>
                                    <li>
                                        <span class="level-3-heading">Normalize transcripts: </span>
                                        <span>Normalizes abundance of transcripts by the length of the transcript (only for major transcript file, applied after threshold, useful for count data).</span>
                                        <br>
                                    </li>
                                    <li>
                                        <span class="level-3-heading">Expression level: </span>
                                        <ul>
                                            <li>
                                                <span class="level-3-heading">Use threshold: </span>
                                                <span>Changes the expression-level threshold to [threshold]. (default)</span>
                                                <br>
                                            </li>
                                            <li>
                                                <span class="level-3-heading">Use percentage: </span>
                                                <span>Changes the expression-level threshold to the [percentile]-th percentile of the expression data.</span>
                                                <br>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <span class="level-2-heading">Run Options<br></span>
                                <ul>
                                    <li>
                                        <span class="level-3-heading">Remove decay transcripts: </span>
                                        <span>Proteins whose coding transcript is subject to degradation are not removed from the constructed network (default: remove if tagged as ’nonsense-mediated decay’ or ’non-stop decay’).</span>
                                        <br>
                                    </li>
                                    <li>
                                        <span class="level-3-heading">Output reference network: </span>
                                        <span>Report the according unpruned reference protein interaction network (and optionally the domain interaction network and the longest isoforms assumed) from the mapping stage of the method.</span>
                                        <br>
                                    </li>
                                    <li>
                                        <span class="level-3-heading">Output DDINs: </span>
                                        <span>Enables the output of underlying condition-specific domain-domain interaction network(s).</span>
                                        <br>
                                    </li>
                                    <li>
                                        <span class="level-3-heading">Output major transcripts: </span>
                                        <span>Enables the output of the major transcript per protein (including its abundance).</span>
                                        <br>
                                    </li>
                                    <li>
                                        <span class="level-3-heading">Report gene abundance: </span>
                                        <span>Outputs major transcript per protein but reports the abundance as the sum of all its expressed coding transcripts. Major transcripts will also be included in outputs</span>
                                        <br>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <span class="level-2-heading">Include PPICompare-required options: </span> Include options required for PPICompare (<span class="highlight"><strong>Output DDINs</strong> and <strong>Output major transcripts</strong></span>).
                            </li>
                        </ul><br>
                    </div>
                    <div class="help-section-body">
                        <!------------------------------------>
                        <!-- SUBSECTION toExampleRunSetting -->
                        <!------------------------------------>
                        <span id="toExampleRunSetting" class="level-1-heading">Examples for run set-up</span>
                        <div style="display: flex; flex-direction: row; align-items: center">
                            <div style="flex: 1">
                                <table name="TableExampleRunSetting" class="table-2">
                                    <tbody>
                                    <tr><th style="font-weight: bold">Protein network data</th></tr>
                                    <tr><th>&emsp;- <a href="./resources/PPIXpress/example_data/example_ppi_data.sif" download="example_ppi_data.sif" class="href_to_section">example_ppi_data.sif</a> </th></tr>
                                    <tr><th style="font-weight: bold">Expression data</th></tr>
                                    <tr><th>&emsp;- <a href="./resources/PPIXpress/example_data/expression_1.txt" download="expression_1.txt" class="href_to_section">expression_1.txt</a> </th></tr>
                                    <tr><th>&emsp;- <a href="./resources/PPIXpress/example_data/expression_2.txt" download="expression_2.txt" class="href_to_section">expression_2.txt</a> </th></tr>
                                    <tr><th class="level-3-heading">Remove decay transcripts</th></tr>
                                    <tr><th class="level-3-heading">Output DDINs</th></tr>
                                    <tr><th class="level-3-heading">Output major transcripts</th></tr>
                                    <tr><th class="level-3-heading">Report gene abundance</th></tr>
                                    <tr><th class="level-3-heading">Compress output</th></tr>
                                    <tr><th class="level-3-heading">Expression level: Use threshold: 1.0</th></tr>
                                    </tbody>
                                </table>
                            </div>
                            <div style="flex: 2.8">
                                <span class="level-2-heading">EXAMPLE 1</span> (Try PPIXpress with this configuration on our main page!)<br>
                                <ul>
                                    <li>PPIXpress will use the given human protein interaction network example_ppi_data.sif to build internal data structures. 
                                        This step is done with annotation from Ensembl (if available on the server) and current 3did data.</li>
                                    <li>Then PPIXpress will build two condition-specific networks according to the expression data given by expression_1.txt 
                                        and expression_2.txt. Transcripts are considered to be expressed if they have expression values above 1.0.</li>
                                    <li>The output consists of the resulting protein interaction networks, condition-specific domain-domain interaction networks 
                                        and the most abundant transcript for each protein.</li>
                                </ul> 
                                
                            </div>
                        </div>
                        <div style="display: flex; flex-direction: row; align-items: center">
                            <div style="flex: 1">
                                <table name="TableExampleRunSetting" class="table-2">
                                    <tbody>
                                    <tr><th style="font-weight: bold">Protein network data</th></tr>
                                    <tr><th>&emsp;- <a href="./resources/PPIXpress/example_data/example_ppi_data.sif" download="example_ppi_data.sif" class="href_to_section">example_ppi_data.sif</a></th></tr>
                                    <tr><th style="font-weight: bold">Expression data</th></tr>
                                    <tr><th>&emsp;- <a href="./resources/PPIXpress/example_data/brain.fpkm_tracking.gz" class="href_to_section" download="brain.fpkm_tracking.gz">brain.fpkm_tracking.gz</a> </th></tr>
                                    <tr><th>&emsp;- <a href="./resources/PPIXpress/example_data/BRCA_tumor.normalized_RSEM.gz" class="href_to_section">BRCA_tumor.normalized RSEM.gz</a> </th></tr>
                                    <tr><th class="level-3-heading">Add STRING weights</th></tr>
                                    <tr><th class="level-3-heading">Update UniProt accessions</th></tr>
                                    <tr><th class="level-3-heading">Expression level: Use threshold: 0.3</th></tr>
                                    </tbody>
                                </table>
                            </div>
                            <div style="flex: 2.8">
                                <span class="level-2-heading">EXAMPLE 2</span><br>
                                <ul>
                                    <li>PPIXpress will first update the UniProt accessions in the given human protein interaction network human ppin.sif and then annotate it with weights from STRING.</li>
                                    <li>Then PPIXpress will build internal data structures using data from Ensembl release 80 retrieved from the US server (if available on the server) and current 3did data.</li>
                                    <li>This knowledge is then used to independently build two condition-specific networks according to the expression data given by 
                                        brain.fpkm_tracking.gz and BRCA_tumor.normalized RSEM.gz whereas transcripts are thought to be expressed if they have expression values above 0.3.</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!------------------------------->
            <!-- SECTION toPPIXpressOutput -->
            <!------------------------------->
            <div id="toPPIXpressOutput">
                <p class="menu header help-section-title">PPIXpress Output</p>
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <!------------------------------------>
                        <!-- SUBSECTION toSampleSummaryFile -->
                        <!------------------------------------>
                        <span id="toSampleSummaryFile" class="level-1-heading">Sample summary file</span>
                    
                        Sample summary file can be viewed and downloaded from the window on the right side of <strong>Running Progress</strong> tab 
                        once the PPIXpress run is finished. It gives an overview of the condition-specific protein networks built using each expression data.<br> 

                        <table style="width:auto; margin: 1em auto">
                            <thead>
                                <tr><td>Sample</td><td>Matched output</td><td>#Proteins</td><td>#Interactions</td><td>Threshold</td></tr>
                            </thead>
                            <tbody style="text-align: center;">
                                <tr><th>expression_1.txt</th><th>1_ppin.txt</th><th>5770</th><th>69923</th><th>1.0</th></tr>
                                <tr><th>expression_2.txt</th><th>2_ppin.txt</th><th>3983</th><th>39304</th><th>1.0</th></tr>
                            </tbody>
                        </table>
    
                        <ul>
                            <li><strong>Sample</strong>: Name of the input expression data file</li>
                            <li><strong>Matched output</strong>: Name of the output file containing the protein network specifically build using each expression data (<span class="highlight">Condition-specific protein network)</span></li>
                            <li><strong>#Proteins</strong>: Number of proteins in the condition-specific protein network</li>
                            <li><strong>#Interactions</strong>: Number of interactions in the condition-specific protein network</li>
                            <li><strong>Threshold</strong>: Expression threshold used to filter the transcripts/genes expression</li>
                        </ul> 
                        <br>

                        <div id="AfterRunOptions_Example"></div><br>

                        <!---------------------------------->
                        <!-- SUBSECTION toPipelineLogFile -->
                        <!---------------------------------->
                        <span id="toPipelineLogFile" class="level-1-heading">Pipeline log file</span>
                        
                        Once the PPIXpress run is finished, select <strong>Download Log File</strong> on the left side of <strong>Running Progress</strong> tab to download the log containing
                        run configurations.<br><br>
            
                        <!--------------------------------->
                        <!-- SUBSECTION toMainOutputFile -->
                        <!--------------------------------->
                        <span id="toMainOutputFile" class="level-1-heading">Main output file</span>
                        
                        Select <strong>Download Result Files</strong> to download main output files, including:<br>
                        <ul>
                            <li><strong>*_ppin.txt</strong>: Condition-specific protein interaction network.</li>
                            <li><strong>*_ddin.txt</strong>: Condition-specific domain-domain interaction network built using <strong>expression_1.txt</strong></li>
                            <li><strong>*_major-transcripts.txt</strong>: Major transcript per protein in the condition-specific protein interaction network built using <strong>expression_1.txt</strong>
                                <span class="highlight"> - requires <strong>Output major transcripts</strong></span></li>
                            
                            <i>Note:</i><br>  
                            The asterisk (*) is a number (1, 2, 3,...) indicating the expression data which the reference network uses to prune.<br>
                            This number corresponds to the <strong>Sample</strong> and <strong>Matched output field</strong> in 
                            <strong>Sample summary file</strong><br>
                            For example: <strong>1_ppin.txt</strong>, <strong>1_ddin.txt</strong> and <strong>1_major-transcripts.txt</strong> are the condition-specific 
                            protein interaction network, domain-domain interaction network and list of major transcript per protein built using <strong>expression_1.txt</strong>.<br><br>

                            <li><strong>reference_ppin.txt</strong>: Unpruned reference protein interaction network 
                                <span class="highlight"> - requires <strong>Output reference network</strong></span></li>
                            <li><strong>reference_ddin.txt</strong>: Unpruned reference domain-domain interaction network 
                                <span class="highlight"> - requires <strong>Output reference network</strong> and <strong>Output DDINs</strong></span></li>
                            <li><strong>reference_major-transcripts.txt</strong>: Major transcript per protein in the unpruned reference protein interaction network 
                                <span class="highlight"> - requires <strong>Output reference network</strong> and <strong>Output major transcripts</strong></span></li>
                        </ul><br>
            
                        <!------------------------------------------->
                        <!-- SUBSECTION toBuildDifferentialNetwork -->
                        <!------------------------------------------->
                        <span id="toBuildDifferentialNetwork" class="level-1-heading">Build differential network (PPICompare)</span>

                        This option is only available if users run the analysis with self-uploaded data and select
                        <a href="./info_page.jsp#toPPIXpressRunOptions" class="href_to_section">PPICompare-required options</a>
                        (<span class="highlight"><strong>Output DDINs</strong> and <strong>Output major transcripts</strong></span>).<br><br>

                        PPICompare compare at least two PPIXpress-constructed PPINs belonging to two different sample types/conditions/contexts to build the differential network. 
                        Therefore, users should upload at least two expression data files that represent two conditions to compare.<br><br>

                        Users can assign the PPINs to each sample group and forward those to PPICompare to build the differential network between two groups.
                        The PPINs marked with "Not selected" will not be included to PPICompare analysis.<br><br>
                        
                        <div id="toBuildDifferentialNetwork_Example" style="text-align: -webkit-center;"></div>
                        <span><center>This dialog is shown when users select <strong>Build differential network</strong> on the left side of <strong>Running Progress</strong> tab. <br></center></span><br>
                        In this example, the PPINs pruned using the transcription data for Th1 precursors (2 samples) or Th2 precursors (3 samples) will be forwarded to PPICompare. 
                        The differential network between Th1 and Th2 precursors will be constructed in PPICompare.<br>

                        <div style="display: flex; flex-direction: column; align-items: center; padding: 1em">
                            <iframe width="560" height="315" src="https://www.youtube.com/embed/VumJvP242H0?si=ZCroIjcYJtvlETvU" title="Build Differential Network" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture;" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
                        </div>
                        <br>

                        <!------------------------------------------>
                        <!-- SUBSECTION toSubnetworkVisualization -->
                        <!------------------------------------------>
                        <span id="toSubnetworkVisualization" class="level-1-heading">Subnetwork visualization</span>
                        
                        Select <strong>Visualize Condition-Specific Networks</strong> to open <strong>Network Visualization</strong> tab 
                        where user can select a protein and inspect the condition-specific network which the protein involves in.<br>

                        <div id="ShowNetworkOptions_Example"></div>
                        Once the PPI network is rendered and displayed, the queried protein will be shown in the center. User can toggle between network layouts,
                        customize the PPI network and expand the protein node to see its domains and DDI network. (Domains and DDI network display <span class="highlight">requires <strong>Output DDINs</strong></span>).

                        <div style="display: flex; flex-direction: column; align-items: center; padding: 1em">
                            <iframe width="560" height="315" src="https://www.youtube.com/embed/VumJvP242H0?si=ZCroIjcYJtvlETvU" title="Network Visualization in PPIXpress" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture;" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
                        </div>
                    </div><br>
                </div>
            </div>

            <!--------------------------------------->
            <!-- SECTION toPPIXpressStandaloneTool -->
            <!--------------------------------------->
            <div id="toPPIXpressStandaloneTool">
                <p class="menu header help-section-title">PPIXpress Standalone Tool</p>
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <!--------------------------->
                        <!-- SUBSECTION toDownload -->
                        <!--------------------------->
                        <span id="toDownload" class="level-1-heading">Download</span>
                        <span>The PPIXpress standalone version is available on <a href="https://sourceforge.net/projects/ppixpress/" class="href_to_section">SourceForge</a>.</span>
                        <br>
                    </div>
                    <div class="help-section-body">
                        <!-------------------------------->
                        <!-- SUBSECTION toDocumentation -->
                        <!-------------------------------->
                        <span id="toDocumentation" class="level-1-heading">Documentation</span>
                        <span>The documentation to PPIXpress standalone version is available on <a href="https://sourceforge.net/projects/ppixpress/" class="href_to_section">SourceForge</a>.</span>
                    </div>
                </div>
            </div>


            <!---------------------------------->
            <!-- SECTION toCitationAndContact -->
            <!---------------------------------->
            <div id="toCitationAndContact">
                <p class="menu header help-section-title">Citation & Contact</p>
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <!--------------------------->
                        <!-- SUBSECTION toCitation -->
                        <!--------------------------->
                        <span id="toCitation" class="level-1-heading">Citation</span>
                        <span>
                            <strong>Stand-alone software version</strong>: 
                            Will, T., & Helms, V. (2016). PPIXpress: construction of condition-specific protein interaction networks based on transcript expression. Bioinformatics, 32(4), 571-578.
                            <a href="https://academic.oup.com/bioinformatics/article/32/4/571/1744136" target="_blank" class="href_to_section">[Link to paper]</a><br>                        
                            <!-- TODO: Add citation -->
                            <strong>Webserver version</strong>:
                            Do, H.T.T., & Helms, V. (2024)
                            <a href="" target="_blank" class="href_to_section">[Link to paper]</a><br>
                        </span> 
                    </div>
                    <div class="help-section-body">
                        <!-------------------------->
                        <!-- SUBSECTION toContact -->
                        <!-------------------------->
                        <span id="toContact" class="level-1-heading">Contact</span>
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
