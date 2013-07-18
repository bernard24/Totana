classdef ValidationMethod
    %CROSSVALIDATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parameters
        currentParameters
        model
        name
        method
        scoreFunction
        minimize
        bestParameters
    end
    
    methods        
        function obj=ValidationMethod(parameters, method, scoreFunction, minimize)
            obj.parameters=parameters;
            obj.currentParameters=parameters;
            if nargin>1
                obj.name=method.name;
            end
            obj.minimize=1;
            if nargin>3
                obj.minimize=minimize;
            end
            obj.method=method;
            obj.method.name=method.name;
            obj.scoreFunction=scoreFunction;
        end
        
        function [obj, timeLong, localOutputs] = train(obj, data, outputs)
            
            obj.name
            
            methodParameters=obj.currentParameters;
            validationData=getValidationData(data);
            methodParametersValues=struct2cell(methodParameters);
            for i=1:length(methodParametersValues)
                if ~iscell(methodParametersValues{i})
                    methodParametersValues{i}={methodParametersValues{i}};
                end
            end
            methodParsComb=allcomb(methodParametersValues);
            nMethodParametersConf=size(methodParsComb, 1);

            bestResult=obj.minimize*Inf;
            bestParameterConf=[];
            bestMethod={};
            tic
            for indexMethodParameters=1:nMethodParametersConf
%                 methodParsNow=mat2cell(methodParsComb(indexMethodParameters,:)', ones(1, length(methodParsComb(indexMethodParameters,:))));
                [indexMethodParameters nMethodParametersConf]
                methodParsNow=methodParsComb{indexMethodParameters};
                for i=1:length(methodParsNow)
                    if iscell(methodParsNow{i})
                        methodParsNow{i}=cell2mat(methodParsNow{i});
                    end
                end
                methodParametersConf=cell2struct(methodParsNow', fieldnames(methodParameters), 1);
%                 resultsConf=zeros(1, obj.nFolds);
%                 for i=1:obj.nFolds
                method=obj.method;
                method=setParameters(method, methodParametersConf);
                [method, at, localOutputs] =  train(method, validationData, outputs);
                [ar] = getScore(obj.scoreFunction, method, validationData);
                resultsConf=ar(1);
%                 end
%                 resultsConf=mean(resultsConf);
                [obj.minimize*resultsConf obj.minimize*bestResult]
                if obj.minimize*resultsConf<obj.minimize*bestResult
                    bestMethod=method;
                    bestResult=resultsConf;
                    bestParameterConf=methodParsNow;
                end
            end
                    
%             bestMethodParametersConf=cell2struct(bestParameterConf, fieldnames(methodParameters), 1);
            obj.method=bestMethod;
            obj.model=obj.method.model;
%             setParameters(obj.method, bestMethodParametersConf);
%             [obj.method, at, localOutputs] = train(obj.method, dataConf, outputs);
            obj.bestParameters=bestParameterConf;
            timeLong=toc;
%             keyboard
        end
        
        function [obj, predY, timeLong] = test(obj, data)
            [obj.method, predY, timeLong]=test(obj.method, data);
            obj.model=obj.method.model;
        end
        
        function obj = setParameters(obj, pars)
            nameParameters=fieldnames(pars);
            obj.currentParameters=obj.parameters;
            for i=1:length(nameParameters)
                name=nameParameters{i};
                if isfield(obj.parameters, name) && ~isempty(obj.parameters.(name))
                    obj.currentParameters.(name)=obj.parameters.(name);
                else
                    obj.currentParameters.(name)=pars.(name);
                end
            end
        end
    end
    
end
