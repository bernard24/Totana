function makeReport( folder, descriptions )
%MAKEREPORT Summary of this function goes here
%   Detailed explanation goes here

records=load([folder '/records']);
times=records.times;
results=records.results;

fileID = fopen([folder '/Report.tex'],'w');
headerFileID = fopen('header.txt');
fwrite(fileID, fread(headerFileID));
fclose(headerFileID);

% fprintf(fileID, '\\section*{Testing}\n');
fprintf(fileID, '\\section*{MTL Synthetic Experiments}\n');
% fprintf(fileID, '%s\n', records.description);

fprintf(fileID, '\n\n\\subsubsection*{Data configuration}\n');
fprintf(fileID, '\\begin{center}\n\\begin{tabular}{|c|c|}\n\\hline\nParameter & Value\\tabularnewline\n\\hline\n');
printParametersConf(fileID, records.dataParameters);
fprintf(fileID, '\n\n\\subsubsection*{Methods configuration}\n');
fprintf(fileID, '\\begin{center}\n\\begin{tabular}{|c|c|}\n\\hline\nParameter & Value\\tabularnewline\n\\hline\n');
printParametersConf(fileID, records.methodParameters);

nRep=1;
if length(size(results))==4
    nRep=size(results, 4);
end
fprintf(fileID, '\n\n\\paragraph*{Number of trials:}\n%d\n', nRep);
fprintf(fileID, '\n\n\\subsection*{Results}\n');

folder
[nPlots tags]=makePlots(folder, descriptions);
close all;

for i=1:nPlots
    fprintf(fileID, '\n\n\\begin{figure}[!ht]\n\\begin{centering}\n');
    fprintf(fileID, '\\includegraphics[scale=0.50]{%s}\n', ['./images/' num2str(i) ]);
    fprintf(fileID, '\\par\\end{centering}\n');
    fprintf(fileID, '\\caption{\\label{fig:%s}', num2str(i));
    if ~isempty(tags)
        fprintf(fileID, '%s', tags{i});
    end
    fprintf(fileID, '}\n');
    fprintf(fileID, '\\end{figure}\n');
end

fprintf(fileID, '\n\n\\end{document}');
fclose(fileID);

cd(folder);
dos('pdflatex Report.tex > josebi');
cd ..;
end

function printParametersConf(fileID, parameters)
parametersNames=fieldnames(parameters);
for i=1:length(parametersNames)
    value=parameters.(parametersNames{i});
    if length(value)==1
        aux=value{1,:};
        while length(aux)==1 && iscell(aux)
            aux=aux{1};
        end
        if iscell(aux)
            aux=cell2mat(aux);
        end
        fprintf(fileID, '$%s$ & $%s$ \\tabularnewline\n\\hline\n', transformName(parametersNames{i}), mat2str(aux));
    end
end

fprintf(fileID, '\\end{tabular}\n\\par\\end{center}');
end

