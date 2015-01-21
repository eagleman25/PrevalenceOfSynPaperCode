% Script to count the number of matches from Eagleman data set and magnet
% set. Compare this to the number of matches for several possible null
% distributions




%% start making our struct to hold our distributions
% need to unpermute p_rgb for this analysis   
rgb.eagle = permute(p_rgb,[1, 3, 2]);


% % 
n = size(rgb.eagle, 1); % number of subjects

%% make some shuffled data sets for comparison
% put them here
rgb.eagleShuffledByRow = rgb.eagle;
rgb.eagleShuffledByCol = rgb.eagle;


% shuffle by column
% loop over number of subjects and shuffle each one's letter-color mappings
for ii = 1:26
    rgb.eagleShuffledByCol(:,:,ii) = rgb.eagle(Shuffle(1:n), :, ii);
end


% shuffle by row
% loop over number of letters and shuffle each matches

for ii = 1:n
  
    shuffleThese = 1:26;
    rgb.eagleShuffledByRow(ii,:,shuffleThese) = rgb.eagle(ii, :, Shuffle(shuffleThese));
end


% % % % make a set of random rgb values which amounts to a random sample
% biased by how much of the rgb space is occupied by each color label
rgb.random = rand(size(rgb.eagle));


%% Get the pre-defined magnet set colors.

% we'll get as many rows as we have subjects, which makes comparison easier
rgb.magnets = fpSimulateData(n,'magnets');

% get modal color for each letter and generate all subjects with that set
rgb.fq = fpSimulateData(n,'most frequent');


% put the dimensionality in the same order as EAGLEMAN rgb (n, 3, 26)
rgb.magnets = permute(rgb.magnets, [1 3 2]);
rgb.fq = permute(rgb.fq, [1 3 2]);

%% RGB => Labels (0:10, based on NW's matrix)
% covert 6588x26x3 rgb to 6588x26x1 label matrix
labels.eagleman            = f_RGB2Colors(rgb.eagle);              % labels for Eagleman data
labels.eagleShuffledByRow  = f_RGB2Colors(rgb.eagleShuffledByRow); % labels for Eagleman data shuffled
labels.eagleShuffledByCol  = f_RGB2Colors(rgb.eagleShuffledByCol); % labels for Eagleman data shuffled
labels.magnet              = f_RGB2Colors(rgb.magnets);            % labels for the magnet set
labels.random              = f_RGB2Colors(rgb.random);             % labels for randomly generated rgbs
labels.fq                  = f_RGB2Colors(rgb.fq);                 % labels for modal choices across population
% % %  we could also make one that is uniform in the label space
labels.uniform = randi(11,size(labels.eagleman))-1;




%% Matches
% so for both the true data and the control distributions find how many
% matches there are to the magnet tempate in each subject

% count up how many of EAGLEMAN RGBs agree with the magnet set
matches = labels.eagleman == labels.magnet;
nummatches.eagle = sum(matches, 2);

% same for shuffled EAGLEMAN RGB (by rows)
matches  = labels.eagleShuffledByRow == labels.magnet;
nummatches.eagleShuffleByRow  = sum(matches, 2);

% same for shuffled EAGLEMAN RGB (by cols)
matches  = labels.eagleShuffledByCol == labels.magnet;
nummatches.eagleShuffleByCol  = sum(matches, 2);

% same for randomly generated rgb data
matches = labels.random == labels.magnet;
nummatches.random = sum(matches, 2);

% same for uniform distribution of color labels (equivalent to binomial
% with k = 11)
matches = labels.uniform == labels.magnet;
nummatches.uniform = sum(matches, 2);

% same for modal matching behavior
matches = labels.eagleman == labels.fq;
nummatches.fq = sum(matches,2);


%% plot histograms

% matches to real magnet set, eagleman v shuffled

s(1,:) = hist(nummatches.eagle, 0:26);
s(2,:) = hist(nummatches.eagleShuffleByRow, 0:26);
s(3,:) = hist(nummatches.eagleShuffleByCol, 0:26);
s(4,:) = hist(nummatches.random, 0:26);
s(5,:) = hist(nummatches.uniform, 0:26);

Cond{1} = 'Eagleman RGB';
Cond{2} = 'Eagleman RGB, shuffled within subject';
Cond{3} = 'Eagleman RGB, shuffled within letter';
Cond{4} = 'Random distribution of RGB';
Cond{5} = 'uniform distribution of labels';

% let's put these on a single plot with log y axis
figure('name','compare magnet syns to rich distribution and shuffled eagleman',...
    'Color',[1 1 1]);

colors = [0 1 0; 0 .5 0; 0 0 1];

plot(0:26, s(1,:), 'ro-', 0:26, s(2,:), 'go-',0:26, s(3,:), 'ko-',...
    0:26, s(4,:), 'bo-',0:26,s(5,:),'co-',...
    'LineWidth', 2)
%plot(0:26, m-s, 'ro-', 'LineWidth', 2)

set(gca, 'FontSize', 16, 'XLim', [0 26], 'YScale', 'log');

title('Num matches to magnet set')
box off;
legend(Cond,'Location','NorthEast')
legend boxoff;
ylabel('log number of subjects');
xlabel('number of matches to magnet set');

% this is the basis for figure 2b but edited in inkscape

% make a nice svg plot
%  plot2svg('magnetsVSnulls.svg');


















