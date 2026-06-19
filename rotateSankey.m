function rotateSankey(SK_obj)
% rotateSankey - Rotate the Sankey diagram to vertical orientation
%   This function exchanges the X and Y coordinates of all graphical objects
%   (blocks, links, and labels), and sets the Y-axis direction to 'reverse'
%   to achieve a visual 90° rotation effect.

% Swap X and Y coordinates for blocks (交换方块的 X 和 Y 坐标)
for i = 1:length(SK_obj.blockHdl)
    tX = SK_obj.blockHdl(i).XData;
    SK_obj.blockHdl(i).XData = SK_obj.blockHdl(i).YData;
    SK_obj.blockHdl(i).YData = tX;
end

% Swap X and Y coordinates for links (交换链接的 X 和 Y 坐标)
for i = 1:length(SK_obj.linkHdl)
    tX = SK_obj.linkHdl(i).XData;
    SK_obj.linkHdl(i).XData = SK_obj.linkHdl(i).YData;
    SK_obj.linkHdl(i).YData = tX;
end

% Adjust label positions and alignment (调整标签位置和对齐方式)
for i = 1:length(SK_obj.labelHdl)
    SK_obj.labelHdl(i).Position([1, 2]) = SK_obj.labelHdl(i).Position([2, 1]);
    SK_obj.labelHdl(i).HorizontalAlignment = 'center';
    if strcmp(SK_obj.LabelLocation{min(i, length(SK_obj.LabelLocation))}, 'left')
        SK_obj.labelHdl(i).VerticalAlignment = 'bottom';
    end
    if strcmp(SK_obj.LabelLocation{min(i, length(SK_obj.LabelLocation))}, 'right')
        SK_obj.labelHdl(i).VerticalAlignment = 'top';
    end
end

% Adjust value label positions and rotation (调整数值标签位置和旋转角度)
for i = 1:length(SK_obj.valueLabelHdl)
    SK_obj.valueLabelHdl(i).Position([1, 2]) = SK_obj.valueLabelHdl(i).Position([2, 1]);
    SK_obj.valueLabelHdl(i).Rotation = -90;
end

SK_obj.ax.YDir = 'reverse';
end