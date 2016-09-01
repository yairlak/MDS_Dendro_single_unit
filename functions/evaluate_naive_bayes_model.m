function results = evaluate_naive_bayes_model(model, design_matrix, labels_test, settings, params)
%%
num_samples = size(design_matrix, 1);
[~, num_conditions] = size(model.mean_firing_rate_matrix);
results.correct = zeros(num_samples, 1);

%% Bayesian inference of the class(phoneme) from each sample
for sample = 1:num_samples 
   % Assume Poisson distribution for firing rates
   k = design_matrix(sample, :)'; % Take curr sample
   lambdas = model.mean_firing_rate_matrix; 
   p_features_given_class = ( exp(-lambdas) .* (lambdas .^ (k * ones(1, num_conditions))))./factorial(k * ones(1, num_conditions));
   
   % Do the Bayesian flip - p(c_i|f1,f2..) = prod[p(f_j|c_i)]*p(c_i)
   % Take the log to prevent overflow.
   log_p_class_given_features = sum(log(p_features_given_class)) + log(model.priors);
   
   % Find most likely class (phoneme)
   [~, IX] = max(log_p_class_given_features);
   if IX == labels_test(sample)
       results.correct(sample) = 1;
   end
end

results.accuracy = sum(results.correct)/num_samples;
results.chance_level = 1/num_conditions;
end