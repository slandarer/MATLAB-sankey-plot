%% sankey demo19 : Link type

figure('Name','sankey demo19', 'Units','normalized', 'Position',[.05,.2,.6,.6])

layerNum = 5; 
layerAdj = cell(1, layerNum - 1);
layerSz = 3;
for i = 1:(layerNum - 1)
    layerAdj{i} = randi([0, 5], [layerSz, layerSz]);
end
adjMat = mergeAdjMat(layerAdj);


SK = SSankey([],[],[], 'AdjMat',adjMat);
SK.Layer = repmat(1:layerNum, [layerSz, 1]);

% link type : 'pchip'(default)/'linear'/'bezier'/'makima'/'spline'
SK.LinkType = 'linear';
SK.draw()
