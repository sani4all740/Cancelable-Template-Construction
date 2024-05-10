function EER = similarity_cal()

gen = [];
for i = 1:100
   combination = nchoosek(4:8, 2);
    for j = 1:length(combination)
        files = combination(j,:);
        LSH_template1 = strcat(pwd, '\Random Hash Code\RPermutedHashedCode\HashCodes2002\DB1\', num2str(i), '_',num2str(files(1)),'.mat');

        if exist(LSH_template1,'file')==0  
            continue;
        else
            load(LSH_template1);
            template1 = binary_codes;
        end
        
        LSH_template2 = strcat(pwd, '\Random Hash Code\RPermutedHashedCode\HashCodes2002\DB1\', num2str(i), '_',num2str(files(2)),'.mat');
        if exist(LSH_template2,'file')==0  
            continue;
        else
            load(LSH_template2);
            template2 = binary_codes;
        end
        C2=abs(template1 - template2);
        totalnumbm=size(template1,2);
        CC=find(C2==0);
        totalnumbs=size(CC(),2);
        if totalnumbm == 0
            similiraty = NaN;
        else
            similiraty=totalnumbs/totalnumbm;
        end
        gen = [gen; similiraty];
    end
end

% impostor test
imp = [];
combination = nchoosek(1:100, 2);
for i = 1:length(combination)
    files = combination(i,:);
    LSH_template1 = strcat(pwd, '\Random Hash Code\RPermutedHashedCode\HashCodes2002\DB1\', num2str(files(1)), '1_4.mat');
    if exist(LSH_template1,'file')==0
        continue;
    else
        load(LSH_template1);
        template1 = binary_codes;
    end
    
    LSH_template2 = strcat(pwd, '\Random Hash Code\RPermutedHashedCode\HashCodes2002\DB1\', num2str(files(2)), '2_4.mat');
    if exist(LSH_template2,'file')==0
        continue;
    else
        load(LSH_template2);
        template2 = binary_codes;
    end
    
    C2=abs(template1 - template2);
    totalnumbm=size(template1,2);
    CC=find(C2==0);
    totalnumbs=size(CC(),2);
    if totalnumbm == 0
        similiraty = NaN;
    else
        similiraty=totalnumbs/totalnumbm;
    end
    imp = [imp; similiraty];
end
[EER, mTSR, mFMR, mFNMR, mGAR] = performance_compute(gen, imp, 0.001);