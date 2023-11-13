%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    File: IR_GDCP.m                                         %
%    Author: Jerry Peng                                      %
%    Date: Aug/2017                                          %
%                                                            %
%    Generalization of the Dark Channel Prior for Single     %
%    Image Restoration                                       %
%------------------------------------------------------------%
%    MODIFICATIONS                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear 
close all

Stretch = @(x) (x-min(x(:))).*(1/(max(x(:))-min(x(:))));
win = 15;
t0 = 0.2;
r0 = t0 * 1.5;
sc = 1;

Image_dir = 'input';
listing = cat(1, dir(fullfile(Image_dir, '*.*g')));

% The final output will be saved in this directory:
deep_dir = fullfile(Image_dir, 'deep');
tran_dir = fullfile(Image_dir, 'tran');

% Preparations for saving results.
if ~exist(deep_dir, 'dir'), mkdir(deep_dir); end
if ~exist(tran_dir, 'dir'), mkdir(tran_dir); end

for i_img = 1:length(listing)
    I = im2double(imread(fullfile(Image_dir, listing(i_img).name)));

    s = CC(I);

    [DepthMap, GradMap] = GetDepth(I, win);

    imwrite(DepthMap, fullfile(deep_dir, listing(i_img).name)); 

    A = atmLight(I, DepthMap);

    T = calcTrans(I, A, win);
    maxT = max(T(:));
    minT = min(T(:));
    T_pro  = ((T-minT)/(maxT-minT))*(maxT-t0) + t0;
    
    imwrite(T_pro, fullfile(tran_dir, listing(i_img).name)); 
end
