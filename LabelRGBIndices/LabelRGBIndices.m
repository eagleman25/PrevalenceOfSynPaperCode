function [labeledRGB] = LabelRGBIndices(matrixSize, subjectname)
% function LabelRGBIndices(matrixSize, colornames, subject)
% 1. takes as input a matrix of rgb indices, a set of candidate colorlabels
% and a subject name
% 2. presents subject colors indicated by rgb in random order and gets
% labels
% 3. outputs the labeled color
% matrix.

% matrixSixe is a 3 element vector indicating the resolution of r g b
% the resulting matrix will be 1 larger on each dimension than matrixSize
% since the entries correspond to the number of steps between 0 and 1 on
% the red, green, and blue dimensions.
% for our data we used matrixSize = [8 8 11]
%  subject is a string with the subject name used to label the output file

% NW 6/2012


% Creates the data file for the subject in the format subjectname.date.mat
c=clock;
dataname = ['data/' subjectname '.' date '.' num2str(c(4)) ':' num2str(c(5)) '.mat'] ;%add date
% sdata = fopen(dataname,'w');

% Skip Psychtoolbox tests
Screen('Preference','SkipSyncTests',1);

%opens the screen
[w, rect] =Screen('OpenWindow',0,[100 100 100]);


center = [rect(3)/2 rect(4)/2];

ListenChar(2); %command window stops listenting for key presses
% HideCursor;


% make a rect to show our color squares
x= 100;
y= 100;
% rect is upper left then lower right
% let's show in top half of the screen this is where we will put the RGB
% color to be matched on each trial
colorpatch = [center(1)-x,100,center(1)+x,300];


% need a series of rects for our match buttons
% black rect
blackRect = [200 350 300 400];
black = [0 0 0];
% white rect
whiteRect = [200 450 300 500];
white = [255 255 255];
% red rect
redRect = [200 550 300 600];
red = [255 0 0];
% green rect
greenRect = [200 650 300 700];
green = [0 255 0];
% yellow rect
yellowRect = [400 350 500 400];
yellow = [255 255 0];
% blue rect
blueRect = [400 450 500 500];
blue = [0 0 255];
% brown rect
brownRect = [400 550 500 600];
brown = [139 69 19];
% purple rect
purpleRect = [400 650 500 700];
purple = [148 0 211];
% pink rect
pinkRect = [600 350 700 400];
pink = [255 20 147];
% orange rect
orangeRect = [600 450 700 500];
orange = [255 165 0];
% gray rect
grayRect = [600 550 700 600];
gray = [150 150 150];

% have to do two button clicks to help cut down on errors
% first click closest color then also click match
% button to push if match is agreed to
matchRect = [1000 400 1200 500];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%        create vectors for r g and b

% red
r = [0:256/matrixSize(1):256];
% green
g = [0:256/matrixSize(2):256];
% blue
b = [0:256/matrixSize(3):256];

% matrix to select trials and fill with color labels
labeledRGB = zeros(length(r),length(g),length(b));

% then want to make a random vector to select rgb values and fill matrix
trialOrder = randperm(length(r)*length(g)*length(b));

% can use ind2sub(size(labeledRGB),trialnum) to get rgb coordinate for each
% trial


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%               NOW SHOW IMAGES IN EXPERIMENT

% for n = 1:10
for n = 1:length(trialOrder)
    %draw a random square with a randomly chosen color
    %      get color
    [redi greeni bluei] = ind2sub(size(labeledRGB),trialOrder(n));
    %   Screen('FillRect', windowPtr [,color] [,rect] );
    Screen('FillRect',w,[r(redi) g(greeni) b(bluei)], colorpatch);
    %         write the choices on the screen
    
    %     so we will have 11 color choices
    %     0 = black
    %     1 = white
    %     2 = red
    %     3 = green
    %     4 = yellow
    %     5 = blue
    %     6 = brown
    %     7 = purple
    %     8 = pink
    %     9 = orange
    %    10 = grey
  
    
    
    %     draw our buttons
    Screen('FillRect',w,black, blackRect);
    Screen('FillRect',w,white, whiteRect);
    Screen('FillRect',w,red, redRect);
    Screen('FillRect',w,green, greenRect);
    Screen('FillRect',w,yellow, yellowRect);
    Screen('FillRect',w,blue, blueRect);
    Screen('FillRect',w,brown, brownRect);
    Screen('FillRect',w,purple, purpleRect);
    Screen('FillRect',w,pink, pinkRect);
    Screen('FillRect',w,orange, orangeRect);
    Screen('FillRect',w,gray, grayRect);
    Screen('FillOval',w,[200 200 200], matchRect);
    Screen('Flip',w,[],1);
    %     wait_time(.05);
    
    
    %         set match value to Nan so you have to make a choice
    match = nan;
    %     %main loop to collect responses
    while 1  %run this loop until we escape it using the break command
        %        get the location of any mouse clicks
        [clicks x y button] = getClicks(w,0);
        
        %         look for a button press
        if clicks ==1
            %     then a series of switches for each button
            %     black
            if( x>blackRect(1) & x<blackRect(3) & y>blackRect(2) & y<blackRect(4))
                %         change match button to black
                Screen('FillOval',w,black, matchRect);
                Screen('Flip',w,[],1);
                match = 0;
            end
            %     white
            if( x>whiteRect(1) & x<whiteRect(3) & y>whiteRect(2) & y<whiteRect(4))
                %         change match button to white
                Screen('FillOval',w,white, matchRect);
                Screen('Flip',w,[],1);
                match = 1;
            end
            %     red
            if( x>redRect(1) & x<redRect(3) & y>redRect(2) & y<redRect(4))
                %         change match button to red
                Screen('FillOval',w,red, matchRect);
                Screen('Flip',w,[],1);
                match = 2;
            end
            %     green
            if( x>greenRect(1) & x<greenRect(3) & y>greenRect(2) & y<greenRect(4))
                %         change match button to green
                Screen('FillOval',w,green, matchRect);
                Screen('Flip',w,[],1);
                match = 3;
            end
            %     yellow
            if( x>yellowRect(1) & x<yellowRect(3) & y>yellowRect(2) & y<yellowRect(4))
                %         change match button to yellow
                Screen('FillOval',w,yellow, matchRect);
                Screen('Flip',w,[],1);
                match = 4;
            end
            %     blue
            if( x>blueRect(1) & x<blueRect(3) & y>blueRect(2) & y<blueRect(4))
                %         change match button to blue
                Screen('FillOval',w,blue, matchRect);
                Screen('Flip',w,[],1);
                match = 5;
            end
            %     brown
            if( x>brownRect(1) & x<brownRect(3) & y>brownRect(2) & y<brownRect(4))
                %         change match button to brown
                Screen('FillOval',w,brown, matchRect);
                Screen('Flip',w,[],1);
                match = 6;
            end
            %     purple
            if( x>purpleRect(1) & x<purpleRect(3) & y>purpleRect(2) & y<purpleRect(4))
                %         change match button to purple
                Screen('FillOval',w,purple, matchRect);
                Screen('Flip',w,[],1);
                match = 7;
            end
            %     pink
            if( x>pinkRect(1) & x<pinkRect(3) & y>pinkRect(2) & y<pinkRect(4))
                %         change match button to pink
                Screen('FillOval',w,pink, matchRect);
                Screen('Flip',w,[],1);
                match = 8;
            end
            %     orange
            if( x>orangeRect(1) & x<orangeRect(3) & y>orangeRect(2) & y<orangeRect(4))
                %         change match button to orange
                Screen('FillOval',w,orange, matchRect);
                Screen('Flip',w,[],1);
                match = 9;
            end
            %     gray
            if( x>grayRect(1) & x<grayRect(3) & y>grayRect(2) & y<grayRect(4))
                %         change match button to gray
                Screen('FillOval',w,gray, matchRect);
                Screen('Flip',w,[],1);
                match = 10;
            end
            %     match
            if( x>matchRect(1) & x<matchRect(3) & y>matchRect(2) & y<matchRect(4) & ~isnan(match))
                % write match value to matrix
                labeledRGB(redi,greeni,bluei)=match;
                % and break out of loop
                Screen('Flip',w,[],0);
                break
                break;
            end
        end
    end
    
end



% save the data
save(dataname, 'labeledRGB');
Screen('CloseAll');
ListenChar(1); %matlab command window now listening for keystrokes
ShowCursor;

end

