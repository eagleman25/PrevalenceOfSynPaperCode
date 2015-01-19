


% script for doing labeling of points in rgb space
% resolution of sampling.  
matrixSize = [8 8 11]
% resulting matrix is 9 x 9 x12 as matrixSize is the number of points
% between min and max along RGB dimensions

% for naming saved output
subjectName = 'test'

% run experiment
[labeledRGB] = LabelRGBIndices(matrixSize,subjectName);