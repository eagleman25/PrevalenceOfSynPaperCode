
% let's assume that the modal choices in the population and the colors of
% the magnet set represent competing influences.  we might therefore expect
% to find that the stronger the influence of a modal population choice, the
% less likely the magnet syns are to match the magnet set.  which is what
% we do find

% since we are looking at the competition between the magnet set and the
% modal matching we don't want to use the letters that both have the same
% color choice (eg A is red in both)
shared = [1 3 8 13 14 23];
% use these
notshared = setdiff(1:26,shared);


% this is a 6588x26 matrix with a 1 everywhere there is a match to the
% magnet set.
eagle2magnetMatches = labels.eagleman == labels.magnet;

% get matrix which just has the magnet syns matches to the magnet set (so 1
% when they do and 0 when they don't)
magnetSynsmatches=eagle2magnetMatches(find(syntype==2),:);

% this is a 6588x26 matrix with a 1 everywhere there is a match to the
% modal color choice for that letter.
eagle2fqMatches = labels.eagleman == labels.fq;

% for non-maggnet syns get just their matches to the modal color matches
genpopmatches = eagle2fqMatches(find(syntype~=2),:);

% get the probability that a magnet syn matches the magnet set for each
% letter
mbaserate = sum(magnetSynsmatches)/length(magnetSynsmatches);

% get the probability that the non magnet syns match the modal color choice
% fore each letter
fbaserate = sum(genpopmatches)/length(genpopmatches);


% compute a correlation between those probabilities for each letter.  the
% idea is that the stronger the modal matching behavior is for a letter,
% the weaker the magnet association will be since they compete
% these are the values reported in the paper
[rhoNS pvalNS] = corr(mbaserate(notshared)',fbaserate(notshared)')



% make a figure
figure('Color',[1 1 1]);
subplot(1,2,2)
text(fbaserate(notshared),mbaserate(notshared),letters(notshared));
box off;
xlabel('proportion matches modal from non-magnet syns');
ylabel('proportion matches to magnet from magnet syns');
set(gca,'YLim',[0 .8],'XLim',[0 .8]);
axis square;
title('letters that differ between magnet and common');
% 



% we might also expect to find that the probability of the modal match in
% the general population is correlated with the probability of a modal
% match in the magnet population

%for magnet syns get their matches to modal choices 
magnetSynsmatchestofq = eagle2fqMatches(find(syntype==2),:);

% proportion of magnetsins with matches to modal color choice for each letter
fbaserateinm = sum(magnetSynsmatchestofq)/length(magnetSynsmatchestofq);

% compute the correlation between magnet syns and rest 
% these are values reported in paper
[rho pval] = corr(fbaserate(notshared)',fbaserateinm(notshared)')

% make a figure
subplot(1,2,1)
text(fbaserate(notshared),fbaserateinm(notshared),letters(notshared));
box off;
xlabel('proportion matches modal from non-magnet syns');
ylabel('proportion matches modal from magnet syns');
set(gca,'YLim',[0 .6],'XLim',[0 .6]);
axis square;
title('letters that differ between magnet and common');
% 
% plot2svg('competingcontingencies.svg');
