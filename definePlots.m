function definePlots(records, desc)

legendTags={};
for i=1:length(records.methods)
    method=records.methods{i};
    legendTags=[legendTags, method.name];
end

results=records.results;
dataParameters=records.dataParameters;
methodParameters=records.methodParameters;


% dataParameters.K_method=methodParameters.K;
% methodParameters=rmfield(methodParameters, 'K');

[numDataParameters nameDataParameters]=getInfoParameters(dataParameters);
[numMethodParameters nameMethodParameters]=getInfoParameters(methodParameters);

% allNames={'Measures', 'Methods', nameDataParameters{:}, nameMethodParameters{:}, 'Results'};
if prod(numDataParameters)*prod(numMethodParameters)~=size(results,3)
    [numDataParameters numMethodParameters]
    size(results)
    error('There is something wrong with the dimensions of the data structure containing the results.');
end
if length(legendTags)~=size(results,2)
    [length(legendTags) size(results,2)]
    error('The number of tags does not match the dimensions of the data structure containing the results.');
end

sizeT=size(results);
nRepetitions=1;
if length(sizeT)>3
    nRepetitions=sizeT(end);
end
R=tensor(results, [size(results,1), size(results,2), numMethodParameters, numDataParameters, nRepetitions]);
dimR=size(R);
TT=R;
dimTT=size(TT);

% keyboard
for i=length(desc):-2:1
    func=desc{i-1};
    pars=[];
    if iscell(func)
        pars=func{2};
        func=func{1};
    end
    
%     keyboard
    
    op=desc{i};
    opIndex=findIndex(op, nameMethodParameters, nameDataParameters);
    Rmat=tenmat(R,opIndex);
    TTmat=tenmat(TT,opIndex);
    TTmat=TTmat.data;
    'josebi'
    size(TTmat)
    if size(Rmat.data,1)>1
        [Rvec TTmat dimTT] = func(Rmat.data, pars, TTmat, dimTT, opIndex);
    else
        Rvec=Rmat.data;
    end

    dimR(opIndex)=1;
    
%     size(R)
%     size(Rmat)
%     size(Rvec)
    dimR
%     keyboard
    R=tensor(Rvec, dimR);
%     TTmat=TTmat';
%     size(TTmat(1:end))
%     dimTT
%     TT=tensor(TTmat(1:end), dimTT);        %  OJETE
end
A=squeeze(double(R));
% keyboard
A
mean(A')
TT=squeeze(TT);

% nCases=dimTT(2+find(dimTT(3:end)>1,1));

dimTT=size(TT);
nCases=dimTT(2);
nMethods=dimTT(1);

% for i=1:nCases
%     table=zeros(nMethods);
%     for j=1:nMethods
%         for k=j+1:nMethods
%             a=squeeze(TT.data(j,i,:));
%             b=squeeze(TT.data(k,i,:));
%             [test table(j,k)]=ttest(a-b);
%         end
%     end
%     i
%     table
% %     keyboard
% end

if length(nameMethodParameters)+length(nameDataParameters)>0
    [varyingPar values]=getVaryingPar(dimR, methodParameters, dataParameters, nameMethodParameters, nameDataParameters);
    [newParNameData, newValuesData] = formatVaryingPar(varyingPar, cell2mat(values));

    % makeTTests(A, legendTags);
    myPlot(A', newValuesData, legendTags, newParNameData, 'Error');
end
end

function [varyingPar values] = getVaryingPar(dimR, methodParameters, dataParameters, nameMethodParameters, nameDataParameters)
candidates=find(dimR>1);
index=candidates(end);
if index-2<=length(nameMethodParameters)
    varyingPar=nameMethodParameters{index-2};
    values=methodParameters.(varyingPar);
    return
end
    varyingPar=nameDataParameters{index-2-length(nameMethodParameters)};
    values=dataParameters.(varyingPar);
end

function opIndex = findIndex(op, nameMethodParameters, nameDataParameters)
    op
    if strcmp(op, 'Measures')==1
        opIndex=1;
        return;
    end
    if strcmp(op, 'Methods')==1
        opIndex=2;
        return;
    end
    if strcmp(op, 'Results')==1
        opIndex=3+length(nameDataParameters)+length(nameMethodParameters);
        return;
    end
    for i=1:length(nameMethodParameters)
        if strcmp(op, nameMethodParameters{i})==1
            opIndex=2+i;
            return
        end
    end
    for i=1:length(nameDataParameters)
        if strcmp(op, nameDataParameters{i})==1
            opIndex=2+length(nameMethodParameters)+i;
            return
        end
    end
    error('The name of the parameter has not been found.');
end

function [ numParameters names ] = getInfoParameters(parameters)
allNames=fieldnames(parameters);
values=struct2cell(parameters);
names={};
numParameters=[];
for i=length(values):-1:1
    n=length(values{i});
    if n>1
        names=[names allNames{i}];
        numParameters=[numParameters n];
    end
end
end

function [newName, newValues] = formatVaryingPar(name, values)

newName=transformName(name);
newValues=values;
diffValues=zeros(1, length(values)-1);
diffLogValues=zeros(1, length(values)-1);
for i=2:length(values)
    diffValues(i-1)=values(i)-values(i-1);
    diffLogValues(i-1)=log(values(i))-log(values(i-1));
end
if var(diffValues)>var(diffLogValues)
    newValues=log10(values);
    newName=['log ' newName];
end

end
