        function dataConf = getValidationData(dataConf)
            fields=fieldnames(dataConf);
            testo=0;
            for i=1:length(fields)
                if strncmp(fields{i}, 'validation_', 11)
                    replacement=fields{i};
                    newReplacement=replacement(12:end);
                    dataConf.(newReplacement)=dataConf.(replacement);
                    testo=1;
                end
            end
            if testo==0
                warning('No validation sets were found.');
                disp('No validation sets were found.');
                keyboard
            end
        end