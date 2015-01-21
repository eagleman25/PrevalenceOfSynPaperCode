function [colorInds colorNames] = fpRGB2ColorsJW(rgb, labels)
% f_RGB2Colors
%
% Quick and dirty script to get color labels from RGB indices.
% added NaN to keep it from auto setting nans to black
% jw

% color labels 
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
    'NaN'
    };

% load the labeled rgb space
% this is a 9 x 9 x 12 matrix where every entry is a label ranging from 0
% to 10.  each of which corresponds to the first 10 color names in names
if ~exist('labels', 'var') || isempty(labels)
    a = load('lRGBnathan.mat');
    labels = a.labeledRGB;
end

% r, g, and b in our data matrix range from 0 to 1. 
% the matrix which provides the labels is 9x 9 x 12.
% So we want to scale the rgb values so that they range from 1 to
% 9, 9, and 12, respectively.  So we multiply by 8, 8 and 11 and add 1.
% Then we round. 
% this leaves NaNs as Nans
% coords is all color  matches interpolated to nearest point in the labeled
% space
coords = round(bsxfun(@times, rgb, [8 8 11])+1);

% this also preserves NaNs
% now you have a coordinate along each axis of the labeled rgb space
% Check for outside the range (less than 1 or greater
% than 9, 9, or 12). 
r = coords(:,1,:); r(r>9) = 9; r(r<1) = 1;
g = coords(:,2,:); g(g>9) = 9; g(g<1) = 1;
b = coords(:,3,:); b(b>12) = 12; b(b<1) = 1;



% did this so that unmatched letters will not be automatically assigned
% black.
% colorInds = zeros(size(coords, 1), 26);
colorInds = NaN(size(coords,1), 26);

% for each letter
for ii = 1:26
%     convert each rgb coordinate for each letter to an index in the space
    inds = sub2ind(size(labels), r(:,ii),g(:,ii), b(:,ii));
%     this should discard entries which are nans
    keep = isfinite(inds);
%     this gets the labels for each letter but without nans yet they 
    colorInds(keep,ii) = labels(inds(keep));
end

% want to make an extra matrix where NaNs are assigned label 12 so that can
% be included in the labeled matrix
nancolorInds = colorInds;
nancolorInds(find(isnan(nancolorInds)))=11;

% return colorNames too, if requested
if nargout > 1
    colorNames = names(nancolorInds + 1);
end

% have to include NaN as a color name now
colorInds=nancolorInds;





