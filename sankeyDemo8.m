%% sankey demo8 : A complex demo

figure('Name','sankey demo8','Units','normalized','Position',[.05,.2,.5,.56])

% Randomly generated data (随机生成数据)
clc;clear;rng(1)
layerName = {'A','B','C','D','E'};
layerSize = [9,6,4,7,10];
cumSumSize = [0, cumsum(layerSize)];
nodeList{sum(layerSize)} = '';
layerAdj{length(layerSize) - 1} = [];
layerAdj{1} = rand(layerSize(1:2));

for i = 1:length(layerSize)
    nodeList((cumSumSize(i) + 1):cumSumSize(i + 1)) = ...
        compose([layerName{i},'%d'], 1:layerSize(i));
end
for i = 2:(length(layerSize) - 1)
    layerAdj{i} = rand(layerSize(i:(i + 1)));
    layerAdj{i} = layerAdj{i}./sum(layerAdj{i}, 2).*(sum(layerAdj{i - 1}, 1).');
end
adjMat = mergeAdjMat(layerAdj);

% Create a Sankey diagram object (创建桑基图对象)
SK=SSankey([],[],[], 'AdjMat',adjMat);
SK.NodeList = nodeList;


% Set link color rendering method (修改链接颜色渲染方式)
% 'left'/'right'/'interp'(default)/'map'/'simple'
SK.RenderingMethod='interp';  

% Set alignment (修改对齐方式)
% 'up'/'down'/'center'(default)
SK.Align='center';
% Set Text Location (修改文本位置)
% 'left'(default)/'right'/'top'/'center'/'bottom'
SK.LabelLocation='top';

% Set separation distance proportion (设置缝隙占比)
SK.Sep=.4;

% Start drawing (开始绘图)
SK.draw()




