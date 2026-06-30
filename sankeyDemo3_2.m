%% sankey demo3_2 : Set link rendering method for a specific layer

% Generate random adjacency matrices for three layers (生成三层随机邻接矩阵)
A12 = randi([0, 1], [40, 6]);
A23 = (rand([6, 9]) + 1);
A23(:, 1) = A23(:, 1).*5; A23(:, 2) = A23(:, 2).*3;
A23 = A23./sum(A23, 2).*sum(A12, 1).';
A34 = randi([1, 30], [9, 6]);
A34 = A34./sum(A34, 2).*sum(A23, 1).';

% Merge into global adjacency matrix (合并为全局邻接矩阵)
adjMat = mergeAdjMat({A12, A23, A34});


figure('Name','sankey demo3_2','Units','normalized','Position',[.05,.05,.6,.88])
SK = SSankey([],[],[],'AdjMat',adjMat, 'Sep',.06, 'BlockScale',.03);
SK.ColorList = [ones(40, 3).*.3; 
    [110, 124, 185; 123, 188, 213; 208, 226, 175; 245, 219, 153; 232, 156, 129; 210, 132, 141]./255;
    [110, 124, 185; 123, 188, 213; 208, 226, 175; 245, 219, 153; 232, 156, 129; 210, 132, 141]./255;
    [ 65, 140, 240; 252, 180,  65; 224,  64,  10]./255;
    ones(40, 3).*.3];
SK.RenderingMethod = 'left';
SK.draw();

% set rendering method for links of a specific layer
SK.setLinkRenderingMethod(1, 'right');

SK.setLabelLocation(4, 'right');
set(SK.blockHdl(47:55), 'FaceColor',ones(1, 3).*.3)