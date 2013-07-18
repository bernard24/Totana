function [ R TTmat dimTT ] = maximize(A, pars, TTmat, dimTT, opIndex)
%MAXIMIZE Summary of this function goes here
%   Detailed explanation goes here

R=max(A);
TTmat=R;
dimTT(opIndex)=1;
dimTT(end)=1;

end

