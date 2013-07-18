classdef CrossValidation
    %CROSSVALIDATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parameters
        currentParameters
        model
        name
        method
        nFolds
        scoreFunction
    end
    
    methods        
        function obj=CrossValidation(parameters, method, nFolds, scoreFunction)
            obj.parameters=parameters;
            if nargin>1
                obj.name=name;
            end
            obj.method=method;
            obj.method.name=method.name;
            obj.nFolds=nFolds;
            obj.scoreFunction=scoreFunction;
        end
        
        function [obj, timeLong, localOutputs] = train(obj, data, outputs)
            methodParameters=obj.currentParameters;

            methodParametersValues=struct2cell(methodParameters);
            methodParsComb=allcomb(methodParametersValues{:});
            nMethodParametersConf=size(methodParsComb, 1);
            
%             dataConf=dataFunction(data, dataParametersConf);

            bestResult=Inf;
            bestParameterConf=[];
            
            tic
            for indexMethodParameters=1:nMethodParametersConf
                methodParsNow=mat2cell(methodParsComb(indexMethodParameters,:)', ones(1, length(methodParsComb(indexMethodParameters,:))));
                               
                resultsConf=zeros(1, obj.nFolds);
                for i=1:obj.nFolds
                    method=obj.method;
%                     dataConf=dataFunction(data, dataParametersConf);
                    [method, at, otherOutputs] =  train(method, dataConf, []);
                    [ar] = getScore(scoreFunction, method, dataConf);
                    resultsConf(i)=ar(1);
                end
                resultsConf=mean(resultsConf);
                if resultsConf<bestResult
                    bestResult=resultsConf;
                    bestParameterConf=methodParsNow;
                end
            end
                    
            bestMethodParametersConf=cell2struct(bestParameterConf, fieldnames(methodParameters), 1);
            setParameters(obj.method, bestMethodParametersConf);
            
            [obj.method, at, localOutputs] = train(obj.method, dataConf, outputs);

            timeLong=toc;

        end
        
        function [obj, predY, timeLong] = test(obj, data)
            [obj.method, predY, timeLong]=test(obj.method, data);
        end
        
        function obj = setParameters(obj, pars)
            nameParameters=fieldnames(pars);
            for i=1:length(nameParameters)
                name=nameParameters{i};
                if isfield(obj.parameters, name) && ~isempty(parameters.(name))
                    obj.currentParameters.(name)=obj.parameters.(name);
                else
                    obj.currentParameters.(name)=pars.(name);
                end
            end
        end
    end
    
end

