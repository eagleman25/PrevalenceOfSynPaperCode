

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % %   do age analysis

load('AgeMatrix.mat');
% loads variable called AgeMatrix
% columns are subjectid batteryid YOB agein2014


% sort through this matrix using userid
% the reason we need to search is that data contains all types of subjects
% so there are 550000 of them.  just want the 6588 grapheme-color
% synesthetes that passed the tests


for i=1:length(userid)
    %     see if gc synesthete gave a usable age
    indx = find(AgeMatrix(:,2)==userid(i));
    %     if not then record a nan for age and dob
    if isempty(indx)
        subage(i) = nan;
        subdob(i) = nan;
    else
        %         record 2014 age and dob
        subage(i) = AgeMatrix(indx,4);
        subdob(i) = AgeMatrix(indx,3);
    end
end








% make some figures
% histograms of subjects by year, fq subs by year, and mag subs by year
figure('name','subject date of birth data','Color', [1 1 1],'Position',get(0,'ScreenSize'))
% allsubjects
subplot(1,3,1);
hist(subdob,1930:5:2010);
box off;
ylabel('num subjects');
xlabel('year born');
title('all subjects');
set(gca,'YLim',[0 1800]);

% fq subjects
subplot(1,3,2);
hist(subdob(syntype==1),1930:5:2010)
box off;
ylabel('num subjects');
xlabel('year born');
title('fq subjects');
set(gca,'YLim',[0 1800]);

% magnet subjects
subplot(1,3,3);
hist(subdob(syntype==2),1930:5:2010)
box off;
ylabel('num subjects');
xlabel('year born');
title('magnet subjects');
set(gca,'YLim',[0 1800]);





% analyse the proportion of the database having magnets overtime

magdob = subdob(syntype==2);
notmagdob = subdob(syntype~=2);
fqdob = subdob(syntype==1);

% how many are there?
nummag = sum(~isnan(magdob));
lnumnotmag = sum(~isnan(notmagdob));



% make a histogram of unbinned magent synesthete data
figure('Name','date of birth of magnet syns','Color',[1 1 1],...
    'Position',get(0,'ScreenSize'));
% counts by year
% years to use
%  some people give birth dates after 2000 but not sure if those are errors
%  as it would make subjects 4 - 10 years old
yrstouse = 1940:2000;
maghistbyyear = histc(magdob(magdob<yrstouse(end)),yrstouse);
allhistbyyear = histc(subdob(subdob<yrstouse(end)),yrstouse);
fqhistbyyear = histc(fqdob(fqdob<yrstouse(end)),yrstouse);
% raw counts
subplot(1,2,1);
bar(1935:1995,maghistbyyear,1);
box off;
set(gca,'XLim',[1935 1995]);
xlabel('year of birth');
ylabel('number of synesthetes');
% proportion by year
subplot(1,2,2);

% convert to proporion
pctbyyear = maghistbyyear./allhistbyyear;
% remove nans (0/0)
pctbyyear(isnan(pctbyyear))=0;
bar(yrstouse,pctbyyear,1);
box off;
set(gca,'XLim',[yrstouse(1) yrstouse(end)]);
xlabel('year of birth');
ylabel('number of synesthetes');


figure('Name','%of magnet syns by year of birth','Color',[1 1 1],...
    'Position',get(0,'ScreenSize'));

% get modal matching pct by year
fqpctbyyear = fqhistbyyear./allhistbyyear;
fqpctbyyear(isnan(fqpctbyyear)) = 0;

% now stacked histogram
bar(yrstouse,fqpctbyyear,1);
hold on;
bar(yrstouse,pctbyyear,1,'r');
box off;
set(gca,'XLim',[yrstouse(1) yrstouse(end)]);
xlabel('year of birth');
ylabel('number of synesthetes');

% save as eps
saveas(gcf,'prevovertimebars.eps','eps');

% average of frequency across all years
% plot2svg('prevovertimebars.svg',gcf,'svg');


% histogram data in 5 year intervals
bins = 1925:5:2005;

maghist = histc(magdob,bins);
notmaghist = histc(notmagdob,bins);
allhist = histc(subdob,bins);
fqhist = histc(fqdob,bins);


% reviewer wants to know how prevalence for period of toy manufacture
% find all subjects born between 1971-1990

toyyearssubs = find((subdob>=1971 & subdob<=1990));
% 3618

magduringtoyyears = find(syntype(toyyearssubs)==2);
% 329

% prevalence during years of manufacture
fprintf('prevalence of magnet syns 1971-1990 is %g\n',...
    length(magduringtoyyears)/length(toyyearssubs));


% suppose we want confidence intervals on the histograms.  its weird to say
% that because we only have the one measure, but very different amounts of
% data to work with over the years (very few subjects in their 80s or under
% the age of 10) many in the 30-50 range

% [bins' allhist' fqhist' maghist']

% 
%         1925           0           0           0
%         1930           6           0           0
%         1935           8           0           0
%         1940          27           3           0
%         1945          42           6           0
%         1950          71          10           0
%         1955         104          19           0
%         1960         126           8           0
%         1965         186          27          13
%         1970         293          24          41
%         1975         535          76          80
%         1980         981         142         126
%         1985        1460         284          77
%         1990        1632         389          36
%         1995         607         147           8
%         2000         128          23           4
%         2005          14           2           1

% so the algorithm is to randomly sample with replacement from our
% distribution many times and then generate statistics across the bins
% so our subject ages are in subdob
    nbstraps = 1000;

    fqstraps = [];
    mgstraps = [];

    % histogram data in 5 year intervals
    bins = 1925:5:2005;

    % probably doesn't need to be a for loop?
    % for each bootstrap
    for i=1:nbstraps
        % get index to our random sample
        rsample =  randi(length(subdob),[length(subdob),1]);
    %    get type of synesthete for sample index
        rsampsyntype = syntype(rsample);
    %     get dobs for sample index
        rsampsubdob = subdob(rsample)';
        %     turn these into binned data for different types of synesthetes
        rsampallhist = histc(rsampsubdob,bins);
        rsampfqhist = histc(rsampsubdob(rsampsyntype==1),bins);
        rsampmaghist = histc(rsampsubdob(rsampsyntype==2),bins);
    %     now into proportions which we will store
        fqstraps(i,:) = rsampfqhist./rsampallhist;
        mgstraps(i,:) = rsampmaghist./rsampallhist;


    end



% figure with shaded 95% confidence intervals
    
%  get intervals

fqci = prctile(fqstraps,[2.5 97.5]);
mgci = prctile(mgstraps,[2.5 97.5]);

% errorbars use differences from mean not actual values
fqmed = nanmedian(fqstraps);%median bootstrapped high frequency syns
fqer(1,:) = abs(fqmed - fqci(1,:));
fqer(2,:) = abs(fqmed + fqci(2,:));
mgmed = nanmedian(mgstraps);%median bootstrapped magnet syns
mger(1,:) = abs(mgmed - mgci(1,:));
mger(2,:) = abs(mgmed + mgci(2,:))
figure('Name','95% ci of bootstraps of fq and mag','Color',[1 1 1],'Position',get(0,'ScreenSize'));

% not sure what is going on with subjects who give birthdates of 2000 or
% later since they are not adults yet.  so clip chart to where we have
% reasonable data
whichbins = [3:15];
% errorbar3 was written by Kendrick Kay and is part of his matlab toolkit
% https://github.com/kendrickkay/knkutils
% slightly modified to control transparency of confidence intervals
errorbar3(bins(whichbins),fqmed(whichbins),fqci(:,whichbins),1,'k');
hold on;
plot(bins(whichbins),fqmed(whichbins),'k');
errorbar3(bins(whichbins),mgmed(whichbins),mgci(:,whichbins),1,'r');
plot(bins(whichbins),mgmed(whichbins),'r');
plot(bins(whichbins),mgmed(whichbins),'r*');
axis on;
box off;

