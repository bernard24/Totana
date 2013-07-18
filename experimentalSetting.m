

methods={@RidgeRegressionF; @MTFLF; @GenMuTaSpaF};
dataFunction=@formatLenkTransferDataF;
data=load('../lenk_data');
scoreFunction=@transferRmseF;

dataParameters.nTrainingInstances=20;
dataParameters.targetTaskIndex=1:20; %1:180;

methodParameters.nAtoms=20;
methodParameters.alpha=10.^[-8:3:4];

storeName=[];
description='Testing...';

script (methods, dataFunction, data, dataParameters, methodParameters, scoreFunction, storeName, description);
