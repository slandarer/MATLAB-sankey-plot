%% sankey demo20 :Rotate the Sankey diagram by 90 degrees to make it vertical

figure('Name','sankey demo20', 'Units','normalized', 'Position',[.05,.1,.4,.7])

A12 = [1,2,1; 1,2,3; 5,0,1];
A23 = [1,4,2; 3,1,0; 0,3,2];
adjMat = mergeAdjMat({A12, A23});

SK = SSankey([],[],[], 'AdjMat',adjMat);
SK.NodeList = {'AAA','BBB','CCC','prop1','prop2','prop3','set1','set2','set3'};
SK.RenderingMethod = 'left';
SK.ValueLabelLocation = 'left';
SK.ValueLabelFormat = @(X) ['sample number = ',num2str(X)];
SK.ColorList = [ 36, 59, 90; 199, 49, 68; 161,137,111; 
                 73, 84,114; 209, 90,105; 226,209,191;
                 30, 30, 30;  30, 30, 30;  30, 30, 30]./255;
SK.Align = 'down';
SK.draw()
SK.setLabelLocation(3, 'right')
SK.setLink(1:15, 'FaceAlpha',.5)

pause(1)
% Rotate the entire diagram to vertical orientation (将整个图旋转为竖向)
rotateSankey(SK)