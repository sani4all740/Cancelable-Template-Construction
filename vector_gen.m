clear all;
close all;

% Makes the MCC SDK and its component visible to MATLAB
% Change path for MccSdk.dll when necessary
NET.addAssembly(fullfile('C:\Users\Sani\Desktop\HASH CODES GEN\Vector Generation\Sdk\MccSdk.dll'));

% select 1-3 impressions of each user for training data
p = 0;
for i = 1:100
    for j = [1,2,3]
        file1 = strcat(pwd,'\Vector Generation\kernel_pca_vec\FVC2004_minutiae\DB1\', num2str(i), '_', num2str(j),'.ist');
        p = p + 1;
        file2=strcat(pwd,'\Vector Generation\kernel_pca_vec\FVC2004_training\DB1\', num2str(p),'.ist');
        copyfile(file1,file2);
    end
end

%construct kernel project matrix using KPCA 
eer = [];
Sigma = 1;

K = ones(300,300);
for i = 1:300
    filename1 = strcat(pwd,'\Vector Generation\kernel_pca_vec\FVC2004_training\DB1\', num2str(i), '.ist');
    template1 = BioLab.Biometrics.Mcc.Sdk.MccSdk.CreateMccTemplateFromIsoTemplate(filename1);
    
    for j = 1:i
        filename2 = strcat(pwd,'\Vector Generation\kernel_pca_vec\FVC2004_training\DB1\', num2str(j), '.ist');
        template2 = BioLab.Biometrics.Mcc.Sdk.MccSdk.CreateMccTemplateFromIsoTemplate(filename2);
        
        tmp = BioLab.Biometrics.Mcc.Sdk.MccSdk.MatchMccTemplates(template1, template2);
        K(i,j) = exp(-0.5*(1-tmp)^2/Sigma^2);
    end
end
for i=1:300
    for j=i:300
        K(i,j) = K(j,i);
    end
end

% Generate fixed-length feature vectors 
all(all(K==K')) && min(eig(K))>0
option.t = 1;
options.ReducedDim = 0;
[eigvector,eigvalue] = kernel_pca(K,options);
W = eigvector;

for i = 1:100
    for j = 4:8
        filename1 = strcat(pwd,'\Vector Generation\kernel_pca_vec\FVC2004_minutiae\DB1\', num2str(i), '_', num2str(j),'.ist');
        template1 = BioLab.Biometrics.Mcc.Sdk.MccSdk.CreateMccTemplateFromIsoTemplate(filename1);
        
        ft = zeros(1,300);
        for ik = 1:300
            filename2 = strcat(pwd,'\Vector Generation\kernel_pca_vec\FVC2004_training\DB1\', num2str(ik), '.ist');
            template2 = BioLab.Biometrics.Mcc.Sdk.MccSdk.CreateMccTemplateFromIsoTemplate(filename2);
            tmp = BioLab.Biometrics.Mcc.Sdk.MccSdk.MatchMccTemplates(template1, template2);
            
            ft(ik) = exp(-0.5*(1-tmp)^2/Sigma^2);
        end
        Ftemplate = ft*W;
        file = strcat(pwd,'\Vector Generation\kernel_pca_vec\FeatureVecs2004\DB1\',num2str(i),'_',num2str(j), '.mat');
        save(file, 'Ftemplate');
    end
end