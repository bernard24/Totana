function [ R TT dimTT ] = select(A, dim, TTmat, dimTT, opIndex)
%MAXIMIZE Summary of this function goes here
%   Detailed explanation goes here

% keyboard
R=A(dim,:);
if length(dim)>1
    R=mean(R);
end

if opIndex~=length(dimTT)
        TT=TTmat(dim,:);
        dimTT(opIndex)=1;
        dimTT(end)=dimTT(end)*length(dim);
end


end

