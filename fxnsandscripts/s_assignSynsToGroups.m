% assign each synesthete to a group and
% generate separate plots for each.
% the groups are synesthetes with 1o or matches to the magnets (this is the
% group we care about)
% synesthetes with more than 7 matches to the most frequently chosen color
% for each letter.  this is just for figure 2D
% those in neither group

syntype = zeros(size(labels.eagleman,1),1);

% number of matches needed to be in high modal matching group
% will want to compare the proportion of magnet synesthetes to what we
% might call modal matching synesthetes (10 or more matches to the modal
% set) over time

fqthreshold=7;
% so we need to find out how many of those there are
%% RGB => Labels (0:10, based on NW's matrix)

%% Matches
% count up how many of EAGLEMAN RGBs agree with the frequently chosen
% colors
fqmatches = labels.eagleman == labels.fq;
% now set syntype based on these matches
syntype(find(sum(fqmatches,2)>=fqthreshold))=1;


% num of matches needed to be in magnet synesthetes
% note that there are some synesthetes which are in both the modal group
% and the magnet group, but since we are interested in magnet synesthetes
% in this paper we assign those to the magnet group
magnetthreshold = 10;

% count number of matches between 6588 magnet templates and 6588 subjects
% matrix of 1 and 0s where 1 is a match
magmatches = labels.eagleman == labels.magnet;

% subjects where sum of row (+ of matches to magnet set by that subject are
% greater than 10) are magnet synesthetes
syntype(find(sum(magmatches,2)>=magnetthreshold))=2;







%% plot subject data for magnet synesthetes
% this is figure 2c in the paper
figure('name', [ num2str(length(find(syntype==2))) ...
    ' subjects with more than ' num2str(magnetthreshold) ...
    ' matches to letter set'], 'Color', [1 1 1],'Position',get(0,'ScreenSize'));

subplot(1,3,3);

% make a graphical legend 10% as tall as the result
theLegend = rgb.magnets(1:length(find(syntype==2))/10,:,:);
theResult = rgb.eagle(find(syntype==2),:,:);

theStack = [theResult; theLegend];
imagesc(permute(theStack, [1 3 2]))

set(gca, 'XTick', 1:26, 'XTickLabel', letters, 'YTick', [1 n], 'FontSize', 18)
title([ num2str(length(find(syntype==2))) ...
    ' with' num2str(magnetthreshold) ...
    '+ matches to magnets'])


% this is the basis for figure 1 in the paper.  the whole database with a legend
% corresponding to the most frequent choices

% make a matrix that has the subjects with exactly the most frequent
% matches
% we'll get as many rows as we have subjects, which makes comparison easier
rgb.fq = fpSimulateData(n,'most frequent');
% put the dimensionality in the same order as EAGLEMAN rgb (n, 3, 26)
% annoying as we unpermute it to get the image (haha).
rgb.fq = permute(rgb.fq, [1 3 2]);




% plot all the subject's matches
subplot(1,3,1);


% make a graphical legend 10% as tall as the result
theLegend = rgb.fq(round(1:length(syntype)/10),:,:);
theResult = rgb.eagle;

theStack = [theResult; theLegend];
imagesc(permute(theStack, [1 3 2]))

set(gca, 'XTick', 1:26, 'XTickLabel', letters, 'YTick', [1 n], 'FontSize', 18)
box off;

title('All Subjects');
