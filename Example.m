
function Example()

%Makes the SDK visible to MATLAB
NET.addAssembly('c:\MccSdk.dll'));

%Sets from an XML file the MCC enroll parameters.
BioLab.Biometrics.Mcc.Sdk.MccSdk.SetMccEnrollParameters('c:\MccPaperEnrollParameters.xml'));

%Loads a MCC Template from a text format file.
template1 = BioLab.Biometrics.Mcc.Sdk.MccSdk.LoadMccTemplateFromTextFile('c:\t1.txt'));

%Creates a MCC Template starting from the minutiae stored in a file
%using the ISO standard format.
template2 = BioLab.Biometrics.Mcc.Sdk.MccSdk.CreateMccTemplateFromIsoTemplate('c:\t2.ist'));

%Sets from an XML file the MCC match parameters.
BioLab.Biometrics.Mcc.Sdk.MccSdk.SetMccMatchParameters('c:\MccPaperMatchParameters.xml'));

%Matches the two MCC Templates.
score = BioLab.Biometrics.Mcc.Sdk.MccSdk.MatchMccTemplates(template1, template2);

%Writes the matching score to the console.
disp('Match score: ');
disp(score);

end
