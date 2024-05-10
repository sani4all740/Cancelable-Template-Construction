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
%          MCC SDK MccEnroller executable
%          v 2.0 - July 2015
% ---------------------------------------------------------------

function MccEnroller( minutiaeTemplateFile, mccTemplateFile, mccEnrollParamFile, outputFile )

NET.addAssembly(fullfile(pwd,'..', '..', 'Sdk', 'MccSdk.dll'));

if (nargin ~=4)
    fprintf('\nSyntax error.\nUse: MccEnroller <MinutiaeTemplateFile> <MccTemplateFile> <MccEnrollParametersFile> <OutputFile>\n');
    return;
end

enrollPerform = true;

try
    BioLab.Biometrics.Mcc.Sdk.MccSdk.SetMccEnrollParameters(mccEnrollParamFile);
    
    switch (System.IO.Path.GetExtension(minutiaeTemplateFile))
        case '.ist'
            template = BioLab.Biometrics.Mcc.Sdk.MccSdk.CreateMccTemplateFromIsoTemplate(minutiaeTemplateFile);
        case '.txt'
            template = BioLab.Biometrics.Mcc.Sdk.MccSdk.CreateMccTemplateFromTextTemplate(minutiaeTemplateFile);
        otherwise
            e = MException('MinutiaeTemplateFile:notSupported', 'Minutiae template file format not supported');
            throw(e);
    end
    
    switch (System.IO.Path.GetExtension(mccTemplateFile))
        case '.mcc'
            BioLab.Biometrics.Mcc.Sdk.MccSdk.SaveMccTemplateToBinaryFile(template, mccTemplateFile);
        case '.txt'
            BioLab.Biometrics.Mcc.Sdk.MccSdk.SaveMccTemplateToTextFile(template, mccTemplateFile);
        otherwise
            e = MException('MccTemplateFile:notSupported', 'Cylinder template file format not supported');
            throw(e);
    end

catch e
    enrollPerform = false;
    fprintf(e.message);
end

if (enrollPerform == true)
    enrollPerformed='OK';    
else
    enrollPerformed='FALSE';
end

ou = fopen(outputFile, 'at');
fprintf(ou, '%15s %15s %4s\n', minutiaeTemplateFile, mccTemplateFile, enrollPerformed);
fclose(ou);
end
