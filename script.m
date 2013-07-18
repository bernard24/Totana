
function script (methods, dataFunction, data, dataParameters, methodParameters, scoreFunction, storeName, description)

%% OJETE CON ESTO:
nResults=1;

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

mkdir(storeName);

nMethods=length(methods);

methodParametersValues=struct2cell(methodParameters);
methodParsComb=allcomb(methodParametersValues{:});
nMethodParametersConf=size(methodParsComb, 1);

dataParametersValues=struct2cell(dataParameters);
dataParsComb=allcomb(dataParametersValues{:});
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
        dataParsNow=mat2cell(dataParsComb(indexDataParameters,:)', ones(1, length(dataParsComb(indexDataParameters,:))));
        dataParametersConf=cell2struct(dataParsNow, fieldnames(dataParameters), 1);
        dataConf=dataFunction(data, dataParametersConf);
        for indexMethodParameters=1:nMethodParametersConf
            methodParsNow=mat2cell(methodParsComb(indexMethodParameters,:)', ones(1, length(methodParsComb(indexMethodParameters,:))));
            methodParametersConf=cell2struct(methodParsNow, fieldnames(methodParameters), 1);
            outputs={};
            fprintf('Data parameters conf: %d\tMethod parameters conf: %d\n', indexDataParameters,  indexMethodParameters);
            for indexMethod=1:nMethods
                f=methods{indexMethod};
                [ar, at, otherOutputs] =  f(dataConf, methodParametersConf, outputs);   %, scoreFunction);
                auxResults(:, indexMethod, indexParameters)=ar;
                auxTimes(indexMethod, indexParameters)=at;
                outputs=[outputs otherOutputs];
            end
            indexParameters=indexParameters+1;
        end
        save( [storeName '/tmpRecords' ], 'auxResults', 'auxTimes', 'dataParameters', 'methodParameters', 'methods', 'description' );
    end
    
    results=cat(4,results, auxResults);
    times=cat(3,times, auxTimes);
    nRounds=nRounds+1;
    
    save( [storeName '/records' ], 'results', 'times', 'dataParameters', 'methodParameters', 'methods', 'description' );
end

end

% function ab = mergeStructs (a, b)
% ca = struct2cell(a);
% cb = struct2cell(b);
% c = [ca;cb];
% ab=cell2struct(c);
% end
