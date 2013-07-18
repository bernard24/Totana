function [ results ] = makeTTests( A, names )
%MAKETTESTS Summary of this function goes here
%   Detailed explanation goes here

results={};
nMethods=size(A,1);
for i=1:nMethods
    method1=names{i};
    for j=i+1:nMethods
        method2=names{j};
        disp([method1 ' vs ' method2]);
        [p t]=ttest(A(i,:)-A(j,:))
        results={results [p;t]};
    end
end
end

