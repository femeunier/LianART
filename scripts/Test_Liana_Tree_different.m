clc ; clear all; 

addpath(genpath('./qsm-fanni-matlab/'));
addpath(genpath('./qsm-blocks-matlab/'));
addpath(genpath('./functions/'));

% Import data from text file.
filenames = {'/home/femeunier/Documents/MATLAB/LianART/data/cyl_data_GUY01_000.txt_0.5_0.55_5_0.025_0.075_3_4_1_t19.txt',
     '/home/femeunier/Documents/MATLAB/LianART/data/cyl_data_GUY01_000.txt_0.5_0.55_5_0.025_0.075_3_4_1_t19.txt'};
QSMs = {};
tra = [0,0,0;
    1,1,0];

for file = 1:length(filenames)
    rawdata = readQSM(filenames{file}) ; 
    QSM = ConvertQSM(rawdata);
    QSMs{file} = QSM.translate(tra(file,:));
end

[QSM_merged,PlandID] = mergeQSMs(QSMs);
is_liana = (PlandID(:,2)==2);

% QSM_merged.plot_model( ...
%     'Closed', ...
%     'FaceCount',[10 20]);
% grid on;

% We first add the leaves on the tree

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
LeafArea_tree = [50,200];

% Initialize the leaf model with the basis geometry.
EmptyLeaves = LeafModelTriangle(vertices, tris, {[1 2 3 4]});

EmptyLeaves_plant = {};
Leaves_plant = {};
for file = 1:length(filenames)
    EmptyLeaves_plant{file} = LeafModelTriangle(vertices, tris, {[1 2 3 4]});
    Leaves_plant{file} = EmptyLeaves_plant{file} ; 
end

% Generate leaves.
Leaves = qsm_fanni( ...
    QSM_merged,...
    EmptyLeaves,...
    LeafArea_tree,...
    'Seed',1,...
    'AreaFunction',@fun_areaLiana,...
    'AreaFunctionParameters',{~is_liana,QSM_merged,15},...
    'SizeFunctionParameters', {[0.45 0.50]},...
    'Verbose',true);

LeafArea_Liana = [5,50];

% Generate leaves.
[Leaves, NAccepted] = qsm_fanni( ...
    QSM_merged,...
    Leaves,...
    LeafArea_Liana,...
    'Seed',1,...
    'AreaFunction',@fun_areaLiana,...
    'AreaFunctionParameters',{is_liana,QSM_merged,15},...
    'SizeFunctionParameters', {[0.15 0.20]},...
    'Verbose',true);

for ileaf = 1:Leaves.leaf_count
    Plant_parent = PlandID(Leaves.leaf_parent(ileaf),2) ; 
    
    origin = Leaves.leaf_start_point(ileaf,:);
    dir = Leaves.leaf_direction(ileaf,:);
    normal = Leaves.leaf_normal(ileaf,:);
    scale = Leaves.leaf_scale(ileaf,:);
    LeafTris = Leaves.triangles(origin, dir, normal, scale);
    
    Leaves_plant{Plant_parent}.add_leaf(origin,...
        dir,...
        normal,...
        scale,...
        Leaves.leaf_parent(ileaf),...
        Leaves.twig_start_point(ileaf,:),...
        LeafTris);
end


% Plot QSM.
hQSM =  QSM_merged.plot_model( 'Closed', ...
    'FaceCount',[10 20]);
% Set bark color.
set(hQSM,'FaceColor',[150,100,50]./255,'EdgeColor',[0 0 0]);

hold on;

% Plot leaves.
Colors = cool(length(filenames));
for file = 1:length(filenames)
    hLeaf = Leaves_plant{file}.plot_leaves();
    % Set leaf color
    set(hLeaf,'FaceColor',Colors(file,:));
end

hold off;
axis equal;
grid on;
zlim([0 35])
 
% % Export
% 
% % Use ngons when exporting leaves.
fUseNgon = true;
% 
% % Export in OBJ-format with individual leaf and QSM vertices and faces.
for file = 1:length(filenames)
    Leaves_plant{file}.export_geometry( ...
        'OBJ', ...
        fUseNgon, ...
        ['./outputs/test_leaves_export' num2str(file) '.obj'], ...
        4 ...
    );

    QSMs{file}.export( ...
        'OBJ', ...
        ['./outputs/test_qsm_export' num2str(file) '.obj'], ...
        'Closed', ...
        'Precision',4 ...
    );
end

