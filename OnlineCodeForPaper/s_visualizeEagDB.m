% s_visualizeEagDB.m

% script which loads and then visualizes the eagleman database of
% grapheme-color synesthetes



% sometimes participants do not assign a color match to  a letter.  in the
% data base these appear as nans
% let's assign a random rgb value to all the nans in order to break up any
% structure that comes from having nans all be black as a matlab default.

% get index to nans

indx =find(isnan(p_rgb));


% make a random rgb matrix of length index ,3 
randcolors = rand(length(indx),1);

randp_rgb=p_rgb;
% fill in the nans with random colors
randp_rgb(indx) =randcolors;


% now we can look at the whole data set

% now we can look at the whole data set
figure('name', 'all matches in eagleman database', 'Color', [1 1 1],'Position',get(0,'ScreenSize'));
subplot(1,2,1);
imagesc(p_rgb);
ylabel('SUBJECTS');
xlabel('LETTERS');
set(gca,'XTick',[1:26],'XTickLabel',letters, 'TickDir','out', 'YDir','normal');
box off;
title('nans are black');

% this subplot is figure 1 in the paper
subplot(1,2,2);
imagesc(randp_rgb);
ylabel('SUBJECTS');
xlabel('LETTERS');
set(gca,'XTick',[1:26],'XTickLabel',letters, 'TickDir','out', 'YDir','normal');
box off;
title('nans are a random color');

 
