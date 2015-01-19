function magnetset = fpMagnetColors

colors = fpDefineColors;
r = colors.r;
o = colors.o;
y = colors.y;
g = colors.g;
b = colors.b;
p = colors.p;

magnetset = [r o y g b p r o y g b p r o y g b p r o y g b p r o]';

return

% debug:look at it
figure(99)
imagesc(1:26); colormap(magnetset)
