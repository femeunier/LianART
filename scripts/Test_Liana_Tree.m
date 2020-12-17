clc ; clear all; 

addpath(genpath('./qsm-fanni-matlab/'));
addpath(genpath('./qsm-blocks-matlab/'));
addpath(genpath('./functions/'));

% Import data from text file.
filenames = {'/home/femeunier/Documents/MATLAB/LianART/data/cyl_data_GUY01_000.txt_0.5_0.55_5_0.025_0.075_3_4_1_t19.txt',
     '/home/femeunier/Documents/MATLAB/LianART/data/cyl_data_GUY01_000.txt_0.5_0.55_5_0.025_0.075_3_4_1_t19.txt'};
QSMs = {};
tra = [0,0,0;50,50,0];

for file = 1:length(filenames)
    rawdata = readQSM(filenames{file}) ; 
    QSM = ConvertQSM(rawdata);
    QSMs{file} = QSM.translate(tra(file,:));
end

QSM_merged = mergeQSMs(QSMs);

% QSM_merged.plot_model( ...
%     'Closed', ...
%     'FaceCount',[10 20]);
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
LeafArea = [200,500];

% Initialize the leaf model with the basis geometry.
Leaves = LeafModelTriangle(vertices, tris, {[1 2 3 4]});

% Generate leaves.
[Leaves, NAccepted] = qsm_fanni( ...
    QSM_merged,...
    Leaves,...
    LeafArea,...
    'Seed',1,...
    'AreaFunction',@fun_areaBranchN,...
    'AreaFunctionParameters',{3},...
    'SizeFunctionParameters', {[0.25 0.30]},...
    'Verbose',true ...
);


% Plot QSM.
% hQSM =  QSM_merged.plot_model( 'Closed', ...
%     'FaceCount',[10 20]);
% % Set bark color.
% set(hQSM,'FaceColor',[150,100,50]./255,'EdgeColor',[0 0 0]);
% 
% hold on;

% Plot leaves.
hLeaf = Leaves.plot_leaves();
% Set leaf color.
set(hLeaf,'FaceColor',[120,150,80]./255);

hold off;
axis equal;
grid on;
zlim([0 35])

 
% % Export
% 
% % Use ngons when exporting leaves.
% fUseNgon = true;
% 
% % Export in OBJ-format with individual leaf vertices and faces.
% Leaves.export_geometry( ...
%     'OBJ', ...
%     fUseNgon, ...
%     './outputs/test_leaves_export.obj', ...
%     4 ...
% );
% 
% % Export QSM parameters to a text file.
% QSM.export( ...
%     'OBJ', ...
%     './outputs/test_qsm_export.obj', ...
%     'Closed', ...
%     'Precision',4 ...
% );

