function [eigvector, eigvalue] = kernel_pca(K, options)
%KPCA	Kernel Principal Component Analysis
%
%	Usage:
%       [eigvector, eigvalue] = KPCA(K, options)
%
%             Output:
%               eigvector - Each column is an embedding function, for a new
%                           data point (row vector) x,  y = K(x,:)*eigvector
%                           will be the embedding result of x.
%                           K(x,:) = [K(x1,x),K(x2,x),...K(xm,x)]
%               eigvalue  - The sorted eigvalue of PCA eigen-problem. 
%
%	Examples:
%           options.KernelType = 'Gaussian';
%           options.t = 1;
%           options.ReducedDim = 4;
% 			fea = rand(7,10);
% 			[eigvector,eigvalue] = KPCA(fea,options);
%           feaTest = rand(3,10);
%           Ktest = constructKernel(feaTest,fea,options)
%           Y = Ktest*eigvector;
% 
%                                                   
MAX_MATRIX_SIZE = 1600; % You can change this number according your machine computational power
EIGVECTOR_RATIO = 0.1; % You can change this number according your machine computational power


if isfield(options,'ReducedDim')
    ReducedDim = options.ReducedDim;
end
 
nSmp = size(K,1);
if (ReducedDim > nSmp) || (ReducedDim <=0)
    ReducedDim = nSmp;
end

sumK = sum(K,2);
H = repmat(sumK./nSmp,1,nSmp);
K = K - H - H' + sum(sumK)/(nSmp^2);
K = max(K,K');
clear H;

if nSmp > MAX_MATRIX_SIZE && ReducedDim < nSmp*EIGVECTOR_RATIO
    % using eigs to speed up!
    option = struct('disp',0);
    [eigvector, eigvalue] = eigs(K,ReducedDim,'la',option);
    eigvalue = diag(eigvalue);
else
    [eigvector, eigvalue] = eig(K);
    eigvalue = diag(eigvalue);
    
    [dump, index] = sort(-eigvalue);
    eigvalue = eigvalue(index);
    eigvector = eigvector(:,index);
end

if ReducedDim < length(eigvalue)
    eigvalue = eigvalue(1:ReducedDim);
    eigvector = eigvector(:, 1:ReducedDim);
end

maxEigValue = max(abs(eigvalue));
eigIdx = find(abs(eigvalue)/maxEigValue < 1e-6);
eigvalue (eigIdx) = [];
eigvector (:,eigIdx) = [];

for i=1:length(eigvalue) % normalizing eigenvector
    eigvector(:,i)=eigvector(:,i)/sqrt(eigvalue(i));
end;



