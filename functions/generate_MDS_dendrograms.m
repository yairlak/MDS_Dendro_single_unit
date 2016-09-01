function generate_MDS_dendrograms(data, settings, params)
ph_counter = 1;
for p = 1:length(settings.phonemes)
    ph = settings.phonemes{p};    
    mat_phonemes(ph_counter, :) = [data.PSTHs.(ph)];
    ph_counter = ph_counter + 1;
end

%% PCA
[coeff, score, latent] = pca(mat_phonemes);
PC1 = coeff(:, 1);
PC2 = coeff(:, 2);
% PC3 = coeff(:, 3);

mat_projection = mat_phonemes * [PC1, PC2];
fig_pca = figure();
scatter(mat_projection(:, 1), mat_projection(:, 2), 1e-2)
text(mat_projection(:, 1), mat_projection(:, 2), settings.phonemes, 'fontsize', 16)
set(fig_pca, 'Color', [1 1 1])
axis off
title('PCA')

%% Distance mat, MDS
D = pdist(mat_phonemes, settings.metric);

% Dendrogram
fig_tree = figure();
tree = linkage(D, 'single');
[H, T, outperm] = dendrogram(tree);
set(gca, 'xticklabel', settings.phonemes(outperm))
set(gcf, 'Color', [1 1 1])
set(gca, 'ytick', [])
ylabel('Relative Distance', 'fontsize', 13)
saveas(fig_tree, fullfile('Figures', sprintf('tree_count')), 'png')

Y1 = mdscale(D,2);
fig_mds = figure();
scatter(Y1(:, 1), Y1(:, 2), 1e-2)
text(Y1(:, 1), Y1(:, 2), settings.phonemes, 'fontsize', 16)
set(fig_mds, 'Color', [1 1 1])
axis off
axis equal
Y1 = mdscale(D,3);

%% MDS 3D
fig_mds = figure();
scatter3(Y1(:, 1), Y1(:, 2), Y1(:, 3), 1e-2)
text(Y1(:, 1), Y1(:, 2), Y1(:, 3), settings.phonemes, 'fontsize', 16)
set(fig_mds, 'Color', [1 1 1])

title('MDS')
saveas(fig_mds, fullfile('Figures', sprintf('mds_count')), 'png')


end