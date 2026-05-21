% sankey demo0 : Basic uasge - equivalent code
% -----------------------
% gitee/github      : slandarer
% fileexchange      : Zhaoxu Liu / slandarer
% 公众号            : slandarer随笔
% 知乎              : slandarer



%% Basic usage - links
figure()
% Define links
links={'a', 'A', 3; 'a', 'B', 1; 'a', 'C', 1; 
       'b', 'A', 1; 'b', 'B', 5;
       'c', 'B', 2; 'c', 'C', 4;
       'A', 'AA', 4; 'A', 'CC', 1; 
       'B', 'BB', 5; 'B', 'CC', 3; 
       'C', 'AA', 5};

% 创建桑基图对象(Create a Sankey diagram object)
SK1 = SSankey(links(:,1), links(:,2), links(:,3));

% 设置节点顺序及层次(Set node order and layer)
SK1.NodeList = {'a', 'b', 'c', 'A', 'B', 'C', 'AA', 'BB', 'CC'};
SK1.Layer = [1, 1, 1, 2, 2, 2, 3, 3, 3];

% 开始绘图(Start drawing)
SK1.draw()




%% Basic usage - adjMat
figure()
% 定义层间邻接矩阵(Define inter-layer adjacency matrices)
A12 = [3,1,1; 1,5,0; 0,2,4];   % a,b,c -> A,B,C
A23 = [4,0,1; 0,5,3; 5,0,0];   % A,B,C -> AA,BB,CC

% 组装全局分块矩阵(Assemble global block matrix)
% 主对角线为零，上对角线为 A12, A23(main diagonal = zero, super-diagonal = A12, A23)
adjMat = mergeAdjMat({A12, A23});

SK2 = SSankey([], [], [], 'AdjMat',adjMat);

% 设置节点名称(Set node names)
SK2.NodeList = {'a', 'b', 'c', 'A', 'B', 'C', 'AA', 'BB', 'CC'};

SK2.draw()
