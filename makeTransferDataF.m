
function [dataConf] = makeTransferDataF(DataParameters) 

nInstances=DataParameters.nInstances;
nAttrs=DataParameters.nAttrs;
nTasks=DataParameters.nTasks;
nAtoms=DataParameters.nAtoms;

% nInstances=1000; %1000
% nAttrs=50;
% nAtoms=10;
% nTasks=50;
propAtom=2/nAtoms;
propTrainingSet=0.1;
noise=0.1;

X=unitalizeColumns(randn(nAttrs,nInstances));
D=unitalizeColumns( randn(nAttrs,nAtoms) );

W=zeros(nAttrs, nTasks);
for i=1:nTasks
    for j=1:nAtoms              % OJETE with this
        if rand<propAtom
            W(:,i)=W(:,i)+D(:,j)+randn*D(:,j);
        end
    end
%     W(:,i)=W(:,i)/sum(abs(W(:,i))); % All weight vectors have L1 norm = 1
end
Y=W'*X;
Y=Y+randn(size(Y))*noise;

nTrainingInstances=floor(nInstances*propTrainingSet);
trainX=X(:,1:nTrainingInstances);
testX=X(:,nTrainingInstances:end);
trainY=Y(:,1:nTrainingInstances);
testY=Y(:,nTrainingInstances:end);

transferYCell=cell(1,nTasks-1);
transferXCell=cell(1,nTasks-1);
transferX=[];
transferY=[];
for i=1:nTasks-1
    transferYCell{i}=trainY(i,:)';
    transferXCell{i}=trainX;
%     transferX=[transferX, trainX];
%     transferY=[transferY, trainY(i,:)];
end
trainY=trainY(end,:)';

% ridgeX=[transferX, trainX];
% ridgeY=[transferY, trainY];

transferW=W(:,1:end-1);
targetW=W(:,end);

dataConf.transferXCell=transferXCell;
dataConf.transferYCell=transferYCell;
dataConf.trainX=trainX;
dataConf.trainY=trainY;
dataConf.testX=testX;
dataConf.testY=testY;
dataConf.transferW=transferW;
dataConf.targetW=targetW;


end