function fqcols = FrequentColors


%         use the most frequent color for each letter
% a:red         2
% b:blue        5
% c:yellow      4
% d:blue        5
% e:green       3
% f:green       3
% g:green       3
% h:orange      9
% i:white       1
% j:orange      9
% k:orange      9
% l:yellow      4
% m:red         2
% n:orange      9
% o:white       1
% p:purple      7
% q:purple      7
% r:red         2
% s:yellow      4
% t:blue        5
% u:orange      9
% v:purple      7
% w:blue        5
% x:black       0
% y:yellow      4
% z:black       0
        



colors = fpDefineColors;



fqcols = [
    colors.r'; %a
    colors.b'; %b
    colors.y'; %c
    colors.b'; %d
    colors.g'; %e
    colors.g'; %f
    colors.g'; %g
    colors.o'; %h
    colors.w'; %i
    colors.o';
    colors.o';
    colors.y';
    colors.r';
    colors.o';
    colors.w';
    colors.p';
    colors.p';
    colors.r';
    colors.y';
    colors.b';
    colors.o';
    colors.p';
    colors.b';
    colors.bk';
    colors.y';
    colors.bk';
    ];


return

% debug:look at it
figure('name', 'frequent colors')
imagesc(1:26); colormap(fqcols)
