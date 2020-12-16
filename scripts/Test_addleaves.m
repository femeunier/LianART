clc ; clear all; 

addpath(genpath('./qsm-fanni-matlab/'));
addpath(genpath('./qsm-blocks-matlab/'));
addpath(genpath('./functions/'));

% Import data from text file.
filename = '/home/femeunier/Dropbox/LianART/data/cyl_data_GUY01_000.txt_0.5_0.55_5_0.025_0.075_3_4_1_t19.txt';
rawdata = readQSM(filename) ; 
QSM = ConvertQSM(rawdata);

% QSM.plot_model( ...
%     'Closed', ...
%     'FaceCount',[10 20], ...
%     'ColorSource','Order', ...
%     'PlotOptions',{'EdgeColor',[0 0 0]} ...
% );
% grid on;


% Vertices of the leaf basis geometry.
vertices = [
    -0.3  0.0  0.0;
    -0.3  1.0  0.0;
     0.3  1.0  0.0;
     0.3  0.0  0.0];


% Triangles of the leaf basis geometry.
tris = [
     1,  2,  3;...
     1,  3,  4];


% Genereate 50 m2 of leaf candidates,
% stop if 10 m2 of leaf area is accepted.
LeafArea = [100,500];

% Initialize the leaf model with the basis geometry.
Leaves = LeafModelTriangle(vertices, tris, {[1 2 3 4]});

% Generate leaves.
[Leaves, NAccepted] = qsm_fanni( ...
    QSM,...
    Leaves,...
    LeafArea,...
    'Seed',1,...
    'AreaFunction',@fun_areaBranch3,...
    'SizeFunctionParameters', {[0.25 0.30]},...
    'Verbose',true ...
);


% Plot QSM.
hQSM = QSM.plot_model();
% Set bark color.
set(hQSM,'FaceColor',[150,100,50]./255,'EdgeColor',[0 0 0]);

hold on;

% Plot leaves.
hLeaf = Leaves.plot_leaves();
% Set leaf color.
set(hLeaf,'FaceColor',[120,150,80]./255);

hold off;
axis equal;
grid on;
zlim([15 35])

