
function script (methods, dataFunction, data, dataParameters, methodParameters, scoreFunction, storeName, description, seed, nIterations)

nResults=scoreFunction.nOutputs;

if nargin<6 || isempty(storeName)
    a=fix(clock);
    b=num2str(a(1))
    for i=2:length(a)
        b=[b '_' num2str(a(i))];
    end
    storeName=b;
end
if nargin<7
    description='No description';
end
if nargin>=9 && ~isempty(seed)
    vers=version('-release');
    if 2011>=str2double(vers(1:end-1))
        warning('This feature is not supported by this Matlab version. Update it if you want to use seeds.');
    else
        rng(seed);
    end
end

nIt=Inf;
if nargin>=10 && ~isempty(nIterations)
    nIt=nIterations;
end

mkdir(storeName);
mkdir([storeName '/Extras']);

nMethods=length(methods);

methodParametersValues=struct2cell(methodParameters);
methodParsComb=allcomb(methodParametersValues);
nMethodParametersConf=size(methodParsComb, 1);

dataParametersValues=struct2cell(dataParameters);
dataParsComb=allcomb(dataParametersValues);
nDataParametersConf=size(dataParsComb, 1);

results=[];
times=[];

nRounds=1;
while true
    auxResults=zeros(nResults, nMethods, nDataParametersConf * nMethodParametersConf);
    auxTimes=zeros(nMethods, nDataParametersConf * nMethodParametersConf);
    disp(['Round number ', num2str(nRounds)]);
    indexParameters=1;
    for indexDataParameters=1:nDataParametersConf
%         dataParsNow=mat2cell(dataParsComb(indexDataParameters,:)', ones(1, length(dataParsComb(indexDataParameters,:))));
        dataParsNow=dataParsComb{indexDataParameters};
        dataParametersConf=cell2struct(dataParsNow', fieldnames(dataParameters), 1)
        dataConf=dataFunction(data, dataParametersConf, storeName);
        for indexMethodParameters=1:nMethodParametersConf
%             methodParsNow=mat2cell(methodParsComb(indexMethodParameters,:)', ones(1, length(methodParsComb(indexMethodParameters,:))));
            methodParsNow=methodParsComb{indexMethodParameters};
            methodParametersConf=cell2struct(methodParsNow', fieldnames(methodParameters), 1)
            outputs={};
            fprintf('Data parameters conf: %d\tMethod parameters conf: %d\n', indexDataParameters,  indexMethodParameters);
            for indexMethod=1:nMethods
                method=methods{indexMethod};
                method=setParameters(method, methodParametersConf);
                [method, at, otherOutputs] =  train(method, dataConf, outputs);   %, scoreFunction);
                [ar] = getScore(scoreFunction, method, dataConf, storeName);
                auxResults(:, indexMethod, indexParameters)=ar;
                auxTimes(indexMethod, indexParameters)=at;
                outputs=otherOutputs;%[outputs otherOutputs];
            end
            indexParameters=indexParameters+1;
        save( [storeName '/tmpRecords' ], 'auxResults', 'auxTimes', 'dataParameters', 'methodParameters', 'methods', 'description' );
        end
    end
    
    results=cat(4,results, auxResults);
    times=cat(3,times, auxTimes);
    save( [storeName '/records' ], 'results', 'times', 'dataParameters', 'methodParameters', 'methods', 'description' );
    
    if nRounds==nIt
        return;
    end
    nRounds=nRounds+1;
    
%     return
    %     keyboard
end
end
