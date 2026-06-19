%% sankey demo5 : Set block/link/label

figure('Name','sankey demo1','Units','normalized','Position',[.05,.2,.5,.56])

links={'a1','A',1.2;'a2','A',1;'a1','B',.6;'a3','A',1; 'a3','C',0.5;
       'b1','B',.4; 'b2','B',1;'b3','B',1; 'c1','C',1;
       'c2','C',1;  'c3','C',1;'A','AA',2; 'A','BB',1.2;
       'B','BB',1.5; 'B','AA',1.5; 'C','BB',2.3; 'C','AA',1.2};

% Create a Sankey diagram object (创建桑基图对象)
SK=SSankey(links(:,1),links(:,2),links(:,3));

% Start drawing (开始绘图)
SK.draw()

% As of SSankey version 8.0.0 and later, 
% the set function can be used directly 
% to set properties for multiple handles in batch.

% Set Block Properties (设置方块属性)
set(SK.blockHdl(2), 'EdgeColor',[0,0,0],'LineWidth',6)

% Batch setting of block properties
set(SK.blockHdl, 'FaceColor',[.5,.5,.5])

% Set Link Properties (设置连接属性)
set(SK.linkHdl(5), 'FaceColor',[0,0,0],'FaceAlpha',.5)

% Set Label Properties (设置标签属性)
set(SK.labelHdl(11), 'FontSize',40,'Color',[0,0,.8])

title(gca,'sankey plot by slandarer','FontSize',30,'FontName','Cambria')




% % Set Block Properties (设置方块属性)
% SK.setBlock(2,'EdgeColor',[0,0,0],'LineWidth',6)
% 
% 
% % Loop Set Block Properties (循环设置方块属性)
% for i=1:14
%     SK.setBlock(i,'FaceColor',[.5,.5,.5])
% end
% 
% % Set Link Properties (设置连接属性)
% SK.setLink(5,'FaceColor',[0,0,0],'FaceAlpha',.5)
% 
% % Set Label Properties (设置标签属性)
% SK.setLabel(11,'FontSize',40,'Color',[0,0,.8])
% 
% title(gca,'sankey plot by slandarer','FontSize',30,'FontName','Cambria')


