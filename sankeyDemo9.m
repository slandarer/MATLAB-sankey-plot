%% sankey demo9 : Using an adjacency matrix as input.

figure('Name','sankey demo9','Units','normalized','Position',[.05,.2,.5,.56])

adjMat=[0,0,0,1,2,1,0,0,0,0;
        0,0,0,1,2,3,0,0,0,0;
        0,0,0,2,0,1,0,0,0,0;
        0,0,0,0,0,0,1,4,0,0;
        0,0,0,0,0,0,2,1,0,0;
        0,0,0,0,0,0,0,3,0,0;
        0,0,0,0,0,0,0,0,1,5;
        0,0,0,0,0,0,0,0,2,3;
        0,0,0,0,0,0,0,0,0,0;
        0,0,0,0,0,0,0,0,0,0];

nodeList=compose('C%d',1:10);

% Create a Sankey diagram object (创建桑基图对象)

SK=SSankey([],[],[],'NodeList',nodeList,'AdjMat',adjMat);
% method 1
% SK=SSankey([],[],[],'AdjMat',adjMat);
% method 2
% SK=SSankey([],[],[],'NodeList',nodeList,'AdjMat',adjMat)
% method 3
% SK=SSankey([],[],[]);
% SK.AdjMat=adjMat; 

% Start drawing (开始绘图)
SK.draw()
