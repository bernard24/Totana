function [ R TTmat dimTT ] = average(A, pars, TTmat, dimTT, opIndex)
%MAXIMIZE Summary of this function goes here
%   Detailed explanation goes here

R=mean(A);

if opIndex~=length(dimTT)
        aux=dimTT(opIndex);
        dimTT(opIndex)=1;
        dimTT(end)=dimTT(end)*aux;
end

end

