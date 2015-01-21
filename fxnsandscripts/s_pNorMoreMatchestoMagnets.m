% Script to count the number of matches from Eagleman data set and various
% comparison distributions (shuffled, Rich Data set, etc) to the magnets
% and the modal matching behavior (most frequent color choice for each
% letter)
% main useful output is a struct p which has probability of n or more
% matches for each comparison


% we have

% labels =
%
%               eagleman: [6588x26 double]
%     eagleShuffledByRow: [6588x26 double]
%     eagleShuffledByCol: [6588x26 double]
%                 magnet: [6588x26 double]
%                 random: [6588x26 double]
%                uniform: [6588x26 double]


% do monte carlo to find out probability of observing n or more matches
% based on several choices of null distribution
% varaiables to hold the probability of seeing n matches for our empirical
% data and our null distributions
sim.colshuffled = zeros(1,27);
sim.rowshuffled = zeros(1,27);
sim.uniform = zeros(1,27);
sim.randomRGB = zeros(1,27);


% numsims = 5000;

% so for s shuffles
% this is a slow way to do this
% so for testing use a smaller number

numsims = 100;
for i=1:numsims
    
    fprintf('simulation no %d\n',i);
    % column shuffled data
    % make a simulated dataset
%     we already have this but want to do this many times
    labels.eagleShuffledByCol = Shuffle(labels.eagleman);
    %     get n matches for each subject
    matches = labels.eagleShuffledByCol == labels.magnet;
    nummatchesinsim = sum(matches,2);
    %     coount number of matches
    temp = hist(nummatchesinsim,0:26);
    %     add to simulation
    sim.colshuffled = sim.colshuffled+temp;
    
    
    
    %     row shuffled data
    % make a simulated dataset
    labels.eagleShuffledByRow = Shuffle(labels.eagleman')';
    %     get n matches for each subject
    matches = labels.eagleShuffledByRow == labels.magnet;
    nummatchesinsim = sum(matches,2);
    %     coount number of matches
    temp = hist(nummatchesinsim,0:26);
    %     add to simulation
    sim.rowshuffled = sim.rowshuffled+temp;
    
    
   
    
    % %     uniform distribution across color labels
    % generalte random labels
    labels.uniform = randi(11,size(labels.eagleman))-1;
     %     get n matches for each subject
    matches = labels.uniform == labels.magnet;
    nummatchesinsim = sum(matches,2);
    %     coount number of matches
    temp = hist(nummatchesinsim,0:26);
    %     add to simulation
    sim.uniform = sim.uniform+temp;
    
    
    % %    random RGB values
    % % make a set of random rgb values
    rgb.random = rand(size(rgb.eagle));
    %     convert to labels
    labels.random = f_RGB2Colors(rgb.random);
    %     get n matches for each subject
    matches = labels.random == labels.magnet;
    nummatchesinsim = sum(matches,2);
    %     coount number of matches
    temp = hist(nummatchesinsim,0:26);
    %     add to simulation
    sim.randomRGB = sim.randomRGB+temp;
    
    
end


% turn into probability distributions this is the probability of n or more
% matches to the magnet set (0 to 26 matches possible)
p.colshuffled = sim.colshuffled/sum(sim.colshuffled);
p.rowshuffled = sim.rowshuffled/sum(sim.rowshuffled);
p.uniform = sim.uniform/sum(sim.uniform);
p.randomRGB = sim.randomRGB/sum(sim.randomRGB);
% 


magnethist = hist(sum(nummatches.eagle,2),0:26);




format short g;
% this table gives us the probability of observing 10 or more matches give
% the column shuffling cited in the paper.
fprintf('probability of observing n or more matches to the magnet set\n');
fprintf('n\tcol\tuniform\trandom\tmagnetcount\n');
% make a table
disp([(0:26)' fliplr(cumsum(p.rowshuffled(end:-1:1)))' ....
    fliplr(cumsum(p.colshuffled(end:-1:1)))',...
    fliplr(cumsum(p.uniform(end:-1:1)))',...
    fliplr(cumsum(p.randomRGB(end:-1:1)))',...
    fliplr(cumsum(magnethist(end:-1:1)))'])



