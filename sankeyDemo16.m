% sankey demo16 : Layer adjMat to global adjMat
% -----------------------
% @author : slandarer
% 公众号  : slandarer随笔
% 知乎    : slandarer

figure('Name','sankey demo16', 'Units','normalized', 'Position',[.05,.2,.5,.56])

% Define inter-layer adjacency matrices
% 定义层间邻接矩阵
A12 = [1,2,1; 1,2,3; 2,0,1];
A23 = [1,4; 2,1; 0,3];
A34 = [1,5; 2,3];

% Assemble global block matrix (main diagonal = O, super-diagonal = A12, A23, A34)
% 组装全局分块矩阵 (主对角线为零矩阵，上对角线为 A12, A23, A34)
adjMat = mergeAdjMat({A12, A23, A34});

SK = SSankey([],[],[], 'AdjMat',adjMat);
SK.NodeList = {'A','B','C','A','B','C','A','B','A','B'};
SK.draw()