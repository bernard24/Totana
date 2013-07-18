function myPlot( data, xValues, legendTags, xLabel, yLabel )
%MYPLOT Summary of this function goes here
%   Detailed explanation goes here

data=data';
% set(0,'DefaultAxesLineStyleOrder','-.|-|--|:');
colors=[ 0, 0, 0;
         1, 0, 0;
         0, 1, 0;
         0, 0, 1;
         1/2, 1/2, 0;
         0, 1/2, 1/2;
         1/2, 0, 1/2;
         1/2, 1/2, 1/2;
         rand, rand, rand;
         rand, rand, rand;
         rand, rand, rand;
         rand, rand, rand;
         rand, rand, rand];
% set(0,...
%       'DefaultAxesLineStyleOrder','-|-.|--|:')
styles={'-', '-.', '--', ':'};


for i=1:size(data,1)
    styleNow=styles{mod(i-1,4)+1};
    if i>4
        styleNow=[styleNow 'd'];
    end
    plot(xValues, data(i,:), styleNow, 'Color', colors(i,:), 'LineWidth', 2);
    hold all;
end
hold off

if nargin>2
    if length(legendTags)~=size(data,1)
        disp([num2str(length(legendTags)) ' legend tags and ' num2str(size(data,1)) ' methods.']);
        error('The number of tags are not the same as the data lines');
    end
    legend(legendTags);
end
if nargin>3
    xlabel(xLabel)
    ylabel(yLabel)
end

end

