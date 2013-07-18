function combineResults( folders, dest )
%COMBINERESULTS Summary of this function goes here
%   Detailed explanation goes here

R=[];
T=[];
for i=1:length(folders)
    cd(folders{i});
    load records
    R=cat(4, R, results);
%     T=cat(3, T, times);
    cd ..
end
results=R;
times=T;
mkdir (dest);
cd(dest);
save('records', 'dataParameters', 'description', 'methodParameters', 'methods', 'results', 'times');

end

