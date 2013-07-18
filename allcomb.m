function A = allcomb(all)

if length(all)==1
    A=combine(all{1}, {{}});
else
    A=combine(all{1}, allcomb(all(2:end)));
end
end

function cellA = combine(cellB, cellC)
    elementsB=length(cellB);
    elementsC=length(cellC);
    cellA={};
    for i=1:elementsB
        eB=cellB(i);
        for j=1:elementsC
            eC=cellC(j);
            cellA=[cellA; {[eB, eC{:}]}];
%             keyboard
        end
    end
end
