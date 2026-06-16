%% sankey demo10 : Move the y‑coordinate of the node(block)

figure('Name','sankey demo10','Units','normalized','Position',[.05,.2,.5,.56])

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
% nodeList={'C1','C2',C3',...'C10'}
nodeList=compose('C%d',1:10);
layer=[1,1,2,4,4,3,6,6,7,7];

% Create a Sankey diagram object (创建桑基图对象)
SK=SSankey([],[],[],'NodeList',nodeList,'AdjMat',adjMat,'Layer',layer);
% SK.Layer = layer;

% Start drawing (开始绘图)
SK.draw()

SK.moveBlockY(3,-10)
SK.moveBlockY(6,-10)