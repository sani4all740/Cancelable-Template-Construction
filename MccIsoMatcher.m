% Copyright (C) 2015 DISI - University of Bologna (Italy)
% All rights reserved.
%
% MCC SDK sample source code.
% http://biolab.csr.unibo.it/mccsdk.html
%
% This source code can be used to create MCC SDK executables.
% It cannot be distributed and any other use is strictly prohibited.
%
% Warranties and Disclaimers:
% THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND
% INCLUDING, BUT NOT LIMITED TO, WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.
% IN NO EVENT WILL UNIVERSITY OF BOLOGNA BE LIABLE FOR ANY DIRECT,
% INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES,
% INCLUDING DAMAGES FOR LOSS OF PROFITS, LOSS OR INACCURACY OF DATA,
% INCURRED BY ANY PERSON FROM SUCH PERSON'S USAGE OF THIS SOFTWARE
% EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
%

% ---------------------------------------------------------------
%          MCC SDK MccIsoMatcher executable
%          v 2.0 - July 2015
% ---------------------------------------------------------------

function MccIsoMatcher( templatefile1, templatefile2, outputfile )

NET.addAssembly(fullfile(pwd,'..', '..', 'Sdk', 'MccSdk.dll'));

if (nargin ~=3)
    fprintf('\nSyntax error.\nUse: Use <IsoTemplateFile1> <IsoTemplateFile2> <OutputFile>\n');
    return;
end


MatchPerformed = true;
Similarity = -1;

try
    MccTemplate1 = BioLab.Biometrics.Mcc.Sdk.MccSdk.CreateMccTemplateFromIsoTemplate(templatefile1);
    MccTemplate2 = BioLab.Biometrics.Mcc.Sdk.MccSdk.CreateMccTemplateFromIsoTemplate(templatefile2);
    
    Similarity = BioLab.Biometrics.Mcc.Sdk.MccSdk.MatchMccTemplates(MccTemplate1, MccTemplate2);
catch e
    MatchPerformed = false;
    fprintf(e.message);
end

if (MatchPerformed == 0)
    MatchingPerformed='FAIL';
else
    MatchingPerformed='OK';
end

    ou = fopen(outputfile, 'at');
    fprintf(ou, '%15s %15s %4s %1.17f\n', templatefile1, templatefile2, MatchingPerformed, Similarity);
    fclose(ou);
end