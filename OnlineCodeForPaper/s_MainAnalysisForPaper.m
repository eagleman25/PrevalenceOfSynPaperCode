
% this script does the analyses used in our paper 'Prevalence of Learning
% in a Large Online Sample of Synesthetes'


% add paths to analysis functions and data
addpath('fxnsandscripts');  addpath('data');




% begin by loading the eagleman database
load EaglemanColoredAlphabets.mat;

% which loads the following variables
%   labels         26x1                   the letters A to Z
%   u_rab        6588x3x26            6588 subjects x 3 color space
%   coordinates x 26 letters

%   u_rgb        6588x4x26            same
%   u_rlab       6588x4x26           same
%   userid       6588x1               userid for 6588 subjects to map back
%   to database



% we will be using u_rgb which contains the 6588 subjects x useridRGB x 26
% letters as entries but has an extra entry for the user id we want to
% remove
onlyrgb = u_rgb(:,2:4,:);
% now our matrix is        6588x26x3

% clear some variables for space
clear u_*;


% let's permute our rgb matrix so that it is subjects by letters by colors
p_rgb = permute(onlyrgb, [1, 3, 2]);

% unfortunately the coversion to rgb made a few values which are just a tiny bit smaller
% than 0 and some which are a tiny bit larger than 1
% just reset those
p_rgb(p_rgb>1)=1;
p_rgb(p_rgb<0)=0;


% some useful bookkeeping stuff
% want to use the labels name for our labeled database, and as these are
% letters
letters = labels;  clear labels;

% color names in order. corresponding numbers are 0 to 11 
% the color names in this order correspond to the numbering scheme used
% when we hand labeled the RGB space.
names = {...
    'black' ...
    'white' ...
    'red' ...
    'green' ...
    'yellow' ...
    'blue' ...
    'brown' ...
    'purple' ...
    'pink' ...
    'orange' ...
    'grey'...
    'none',...
    };

% corresponding colors for each color name
histcolors = [ 0 0 0;
    1 1 1;
    1 0 0;
    0 1 0;
    1 1 0;
    0 0 1;
    .8 .4 .12;
    .8 0 .8;
    1 .1 .55;
    1 .6 0;
    .5 .5 .5;
    0 0 0;
    ];




% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%  we would like to find out how many synesthetes in the database were
% likely to have had the magnet set.
% creates the structs rgb, labels, and nummatches
% uses these to find the number of matches persubject in the empirical data and
% several comparisons (shuffled data etc) to both the magnets and the modal
% matching behavior
% makes the figure which is the basis for figure 2B
s_fpAndEaglemanMatches

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% to obtain actual probabilities, let's shuffle the data set many times
% and count the probability of observing n or more matches for each of our
% distributions
% outputs a table showing the probability of observing n or matches to the
% magnet set given the distribution
s_pNorMoreMatchestoMagnets


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%  can see from the probabilities that synesthetes with 10 or more matches
%  to the magnet set are unlikely to occur by chance.  so go through
%  database figure out which synesthetes have 10 or more matches and make a
%  plot.  also for comparison, find synesthetes who have numerous matches
%  to the modal choice for each letter
% makes plots showing rgb matches for magnet syns and whole database which
% are the basis for figures 1 and 2c
s_assignSynsToGroups

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Age analysis
%gets the date of birth of each subject. 
% makes several figures showing distribution of birth dates one of which is
% the basis for figure 2D.
% also computes some of the values used in the paper (number of subjects
% with birth dates, number with 10 or matches to magnets, etc.)
s_DOBbySynType


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% clustering analysis
% this function runs pretty slowly because it runs k-medoids many times.
% k-medoids.m is part of the stats toolbox that accompanies matlab2014b so
% you need to have both that version of matlab and the stats toolbox.
% this produces the basis for figure 3 in the paper. note that k-medoids
% will produce a different clustering each time, so it may take a few tries
% to get a figure which is very close to figure 3 
% s_synclusteringAnal

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% analysis of competition between modal matching behavior and magnet set in
% the magnet synesthetes.  
% this generates the basis for figure 4 in the paper as well as the
% reported correlation values
s_competingInfluences
