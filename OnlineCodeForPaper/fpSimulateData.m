function colors = fpSimulateData(n, method, varargin)
% colors = fpSimulateData(n, method)
%
% create an n x 26 x 3 matrix of letter-color pairings
%   n: number of subjects
%   method: 'rand' or 'shuffle'
%       'magnets':       magnet set, repeated n times
%       'rand':          random samples from uniform distribution on [0 1]
%       'shuffle':       random samples from fisher price colors
%       'shuffle noisy': same as shuffle, but with additive noise 
%       'magnets noisy': same as 'magnets', but with some additive noise
%       'most frequent': most frequently occuring choice for each letter, n
%       times
%   varargin: if method is 'noisy', specify sd of noise
%
% Examples:
%   colors = fpSimulateData(100, 'orginal');
%   colors = fpSimulateData(100, 'rand');
%   colors = fpSimulateData(100, 'shuffle');
%   colors = fpSimulateData(100, 'shuffle noisy');
%   colors = fpSimulateData(100, 'magnets noisy');


switch lower(method)
    case {'magnet set' 'magnets' 'original'}
        % make multiple identical copies of the magnet set
        colors = zeros(n, 26, 3); % initialize the matrix
        rgbset = fpMagnetColors;  % get the fisher price colors

        for ii = 1:n
            colors(ii,:,:) = rgbset;  
        end


    case {'rand' 'random'}
        % draw RGB triplets from uniform distribution
        colors = rand(n , 26, 3);
    
    case {'shuffle' 'shuffled'}
        % make up data by random draw from magnet set colors
        colors = zeros(n, 26, 3); % initialize the matrix
        rgbset = fpMagnetColors;  % get the fisher price colors
        
        for ii = 1:n
            seq = randi(26, 1, 26); % randomize the alphabet
            colors(ii, 1:26,1:3) = rgbset(seq,:);
        end
        
    case {'shuffle noisy'}
        % same as shuffle, but with some noise added. 
        if ~isempty(varargin), noiselevel = varargin{1};
        else                   noiselevel = 0.1; end
        
        colors = fpSimulateData(n, 'shuffle');
        noise  = noiselevel * randn(size(colors));
        colors = colors + noise;
        colors(colors > 1) = 1;
        colors(colors < 0) = 0;
        
    case {'magnets noisy'}
        % same as the magnet set, but with some noise added. 
        if ~isempty(varargin), noiselevel = varargin{1};
        else                   noiselevel = 0.1; end
        
        colors = fpSimulateData(n, 'magnets');
        noise  = noiselevel * randn(size(colors));
        colors = colors + noise;
        colors(colors > 1) = 1;
        colors(colors < 0) = 0;
     
    case {'most frequent'}

       colors = zeros(n, 26, 3); % initialize the matrix
        rgbset = FrequentColors;  % get the most frequently chosen colors

        for ii = 1:n
            colors(ii,:,:) = rgbset;  
        end




        
        
        
end
        