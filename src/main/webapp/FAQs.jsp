<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html lang="en">
<head>
    <title>PPI Webserver FAQs</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
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
                    <p name="HelpMenu" id="PPIXpressFAQs" class="help-panel DefaultHelpMenu" style="border-radius: 1em 1em 0 0">PPIXpress</p>
                    <!-- <p name="HelpMenu" id="ProteinInteractionData" class="help-panel-sub">Protein interaction data</p> -->
                </div>
                <div>
                    <p name="HelpMenu" id="PPICompareFAQs" class="help-panel" style="border-radius: 0 0 1em 1em">PPICompare</p>
                    <!-- <p name="HelpMenu" id="SampleSummaryFile" class="help-panel-sub">Sample summary file</p> -->
                </div>
            </div>
            <div name="ScrollToTop" class="reset" style="text-align: center; position: relative; padding: 0; border-radius: 1em; margin-top: 1em">Scroll to top</div>
        </div>
        <div id="RightPanel" class="middle-under-info-page" style="flex: 1; display: flex; flex-flow: column">
            <!--------------------------->
            <!-- SECTION toPPIXpressFAQs -->
            <!--------------------------->

            <div id="toPPIXpressFAQs">
                <p class="menu header help-section-title" style="color: var(--mint);">PPIXpress</p>

                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <ul>
                            <li class="question">Q: What is PPIXpress, and why would I use it?</li>
                            <li class="answer">A: PPIXpress is a software tool designed for the integration of protein-protein interaction (PPI) networks with expression data, with the objective of creating condition-specific interaction networks. It is particularly suited to the analysis of protein interactions under different biological conditions and the identification of network rewiring.</li>

                            <li class="question">Q: What file types and format should be followed as input for PPIXpress?</li>
                            <li class="answer">A: The following files can be used as input:<br>
                            1. Protein Interaction Data: A SIF file listing interaction between proteins. Additionally, data can be retrieved automatically from Mentha or IntAct. Format PPI data: Protein1 Protein2 weight.<br>
                            2. Expression Data: Files containing expression values, such as FPKM tracking, GENCODE GTF, TCGA RNA-seq, or plain text files with Ensembl identifiers. Format: Expression data formats include FPKM, TPM, GTF, or plain text with Ensembl IDs.</li>

                            <li class="question">Q: Can I use any compressed files?</li>
                            <li class="answer">A: Compressed files ending in .gz are supported.</li>

                            <li class="question">Q: What should I do if my input files aren't working?</li>
                            <li class="answer">A: Check the file formats, if they match PPIXpress requirements and check if the gene or protein identifiers are valid and consistent.</li>

                            <li class="question">Q: Do my gene or transcript identifiers have to follow a specific standard?</li>
                            <li class="answer">A: Yes, identifiers should match one of the following:<br>
                                Proteins: UniProt accessions, Ensembl genes, or HGNC gene symbols.<br>
                                Genes/Transcripts: Ensembl identifiers are preferred.</li>

                            <li class="question">Q: Can I filter low-expression genes?</li>
                            <li class="answer">A: Yes, you can set an expression threshold. By default, it's 1.0, but you can adjust it or use a percentile-based threshold.</li>

                            <li class="question">Q: What does the "Remove decay transcripts" option do?</li>
                            <li class="answer">A: It excludes transcripts tagged as being subject to degradation (e.g., nonsense-mediated decay) from the analysis.</li>

                            <li class="question">Q: What does "Add STRING weights" do?</li>
                            <li class="answer">A: It integrates STRING v10 functional association probabilities into the PPI network, improving the biological relevance of the interactions.</li>

                            <li class="question">Q: What is the "Include ELM data" option for?</li>
                            <li class="answer">A: This retrieves and incorporates ELM motifs and interactions, providing detailed domain-level insights. However, it may increase runtime.</li>

                            <li class="question">Q: Can I compare networks from different conditions?</li>
                            <li class="answer">A: Yes, there are two ways to compare PPIXpress networks:<br>
                                1. Download PPIXpress results and upload those to PPICompare server.<br>
                                2. Use the "Build differential network (PPICompare)" option in the dialog after PPIXpress is finished. Note that this option is only available if "Output DDINs" and "Output major transcripts" in "Step 3. Adjust Run Options" are selected before PPIXpress is initiated.</li>

                            <li class="question">Q: What should I do if my run fails?</li>
                            <li class="answer">A: 
                            • Check the log file for errors.<br>
                            • Ensure your input files are in the correct format.<br>
                            • Verify that identifiers match supported standards (Ensembl, UniProt, HGNC).</li>

                            <li class="question">Q: Why are some interactions missing in the output?</li>
                            <li class="answer">A: Interactions may be filtered due to low expression values below the threshold, mismatched identifiers in the input data or lack of STRING weighting.</li>

                            <li class="question">Q: My identifiers aren't being recognized. What should I do?</li>
                            <li class="answer">A: Ensure that your protein or gene identifiers follow the supported formats (UniProt, Ensembl, or HGNC). If needed, use the "Update UniProt accessions" option.</li>

                            <li class="question">Q: Where can I find help if I encounter issues?</li>
                            <li class="answer">A: Please refer to the official documentation or contact the PPIXpress support team.</li>

                            <li class="question">Q: Can I save my results?</li>
                            <li class="answer">A: Yes, you can download output files, including networks and log files, for further analysis.</li>

                        </ul>
                    </div>
                </div>
            </div>

            <!------------------------------->
            <!-- SECTION toPPICompareFAQs -->
            <!------------------------------->
            <div id="toPPICompareFAQs">
                <p class="menu header help-section-title" style="color: var(--mint);">PPICompare</p>
                
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <ul>
                            <li class="question">Q: What is PPICompare, and why would I use it?</li>
                            <li class="answer">A: PPICompare is a tool designed to compare protein-protein interaction networks (PPINs) from different conditions, identifying changes and rewiring events between the networks. It is suited to study the differences in protein interactions under varying biological conditions, such as disease vs. healthy states or different cell types.</li>

                            <li class="question">Q: Can I use my own interaction networks as input data?</li>
                            <li class="answer">A: Yes, as long as the networks follow the required format and are compatible with PPICompare.</li>

                            <li class="question">Q: Can I use expression data directly in PPICompare?</li>
                            <li class="answer">A: No, PPICompare works with pre-constructed PPINs. Expression data should first be processed using tools like PPIXpress to generate condition-specific networks.</li>

                            <li class="question">Q: How does PPICompare handle missing or incomplete data?</li>
                            <li class="answer">A: PPICompare only compares proteins and interactions present in the input networks. Missing data will be excluded from the analysis.</li>

                            <li class="question">Q: Why can't I see differences between my networks?</li>
                            <li class="answer">A: It could be because the networks are similar, the expression thresholds were too strict or there is limited interaction data.</li>

                            <li class="question">Q: How do I handle networks with outdated identifiers?</li>
                            <li class="answer">A: Ensure that identifiers (e.g., UniProt, Ensembl) in your networks are up-to-date. Tools like PPIXpress can help update outdated IDs during network generation.</li>

                            <li class="question">Q: What should I do if my input files fail to load?</li>
                            <li class="answer">A: Check the file format, ensure compatibility, and validate data consistency. Refer to the documentation for troubleshooting tips.</li>

                            <li class="question">Q: Where can I get help if something goes wrong?</li>
                            <li class="answer">A: Refer to the documentation or contact the PPICompare support team for assistance.</li>

                            <li class="question">Q: Can I save or share my results?</li>
                            <li class="answer">A: Yes, PPICompare allows you to download result files, including the differential network and associated statistics.</li>

                        </ul>
                    </div>
                </div>

            </div>
           
        </div>
    </div>
</div>
<!-- <jsp:include page="html/footer.html"/> -->
</body>
</html>
