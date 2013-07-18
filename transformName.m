function name = transformName(name)
    parts=strfind(name, '_');
    if length(parts>0)
        name=[ toGreek(name(1:parts-1)) '_{' toGreek(name(parts+1:end)) '}' ];
    else
        name=toGreek(name);
    end
 end

 function name = toGreek(name)
     if strcmp(name, 'alpha') || strcmp(name, 'beta') || strcmp(name, 'gamma') || strcmp(name, 'epsilon') || strcmp(name, 'varepsilon') || strcmp(name, 'theeta') || strcmp(name, 'sigma')
        name=['\' name];
    end
 end
    
    