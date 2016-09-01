function model = get_bayesian_priors(model, settings, params)
% If uniform priors set all ones. Otherwise, load priors from file.
switch settings.prior_type
    case 'uniform'
        model.priors = ones(1, size(model.mean_firing_rate_matrix, 2));
    case 'phoneme frequency'
        file_name = sprintf('%s phoneme frequency.txt', settings.language);
        fID = fopen(fullfile(settings.path2mainData, file_name));
        priors = textscan(fID, '%d %s');
        fclose(fID);
        priors = double(priors{1,1});
        priors = priors/sum(priors);
        priors = priors(settings.phonemes_serial_number);
        model.priors = priors';
end

end