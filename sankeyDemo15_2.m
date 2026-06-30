%% sankey demo15_2 : Add nodes and links using the + operator
figure('Name','sankey demo15_2','Units','normalized','Position',[.05,.2,.5,.56])

A12 = [1,2,1; 1,2,3; 2,0,1];
A23 = [1,4; 2,1; 0,3];
A34 = [1,5; 2,3];
adjMat = mergeAdjMat({A12, A23, A34});

SK = SSankey([],[],[], NodeList = compose('C%d',1:size(adjMat, 1)), AdjMat = adjMat).draw();

% Add nodes and links using the + operator (使用 + 运算符添加节点和链接)
% add link: obj + [source, target, value]
% add node: obj + {'Name', layer}
SK + {'add1', 1} + {'add2'} + {} + {'layerNode5', 5} + [13, 14, 5] + [10, 14, 3] + [12, 14, 5];

