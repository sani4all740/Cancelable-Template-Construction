clear all;
close all;

Numperm =500; % # of elements in each component
SKey = 2; % security parameter
Kwindow = 150; % window size k
Sinvec = 2; % single vector element  
Hashvec = 10; % # number of hash vectors in a single component corresponding to entire n permutations
Hashcode = {};

Dimension = 50; % # of dimension

for ii=1:Numperm
    Hash_vecs{ii} = getHashvec(150,SKey);
end
for i = 1:100
    for j = 4:8
%         readfile = strcat(pwd, '\data\', num2str(i), '_',num2str(j),'.mat');

        readfile = strcat('C:\Users\Sani\Desktop\HASH CODES GEN2\Random Hash Code\FeatureVecs2002\DB1\',num2str(i),'_',num2str(j), '.mat');
        if exist(readfile,'file')==0
            continue;
            maxcomponent_value = [];
            Hash_vecs = shift(Hashcode);
            shift = [cycle, shift_rows];
        for counter = 1:300
            tmp = vector * randum(:,:,counter);
            
            [m ind] = max(tmp);
            maxcomponent_value = [maxcomponent_value, ind];
        end
        else
            A = load(readfile); 
            A = A.Ftemplate;
           %A.Ftemplate(templatenew);
           %A.Ftemplate = cycle(sift_rows, inv_shift_rows);
            [binary_codes,Hash_vecs] = Hash_code_hashing(A,Hash_vecs,SKey, Kwindow, Numperm);
            savefile = strcat(pwd, '\Random Hash Code\RPermutedHashedCode\HashCodes2002\DB1\', num2str(i), '_',num2str(j),'.mat');
            save(savefile,'binary_codes'); 
           % save('Hashcode.mat','Hashcode');
        end 
    end
end
EER = similarity_cal();
