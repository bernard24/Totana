function [nPlots tags] = makePlots(folder, descriptions)

records=load([folder '/records']);
mkdir([folder '/images']);
nPlots=length(descriptions);
tags=cell(1,nPlots);
for i=1:nPlots
    desc=descriptions(i);
    figure
    definePlots(records, desc.description);
    name=[folder '/images/' num2str(i)];
    saveas(gcf, [name '.fig']);
    saveas(gcf, [name '.eps'],'psc2');
    tags{i}='';
    if isfield(desc, 'tag')
        tags{i}=desc.tag;
    end
end
    