classdef DumbbellChart
    % DumbellChart is an object that is used inside the dumbbellPlot
    % function, providing a robust building brick for its more complex
    % functionalities.

    properties
        Value1 (1,:) double
        Value2 (1,:) double
        YLabels (1,:) cell
        colors (2,3) double
        sz (1,:) double
        LineWidth (1,1) double
        TextSize (1,1) double
        TextInside (1,1) logical
        ColorDist (1,1) string
        AxesFontSize (1,1) double
    end

    methods
        function obj = DumbbellChart(x1, x2, YLabels, colors, sz, LineWidth, TextSize, TextInside, ColorDist, AxesFontSize)
            % Object constructor method
            % Required inputs: x1 and x2, which are the 2 sets of data
            % confronted
            % YLabels sets the labels of the Y ticks
            % Input validation handled by the main function for separation
            % of concerns
            
            obj.Value1 = x1;
            obj.Value2 = x2;
            obj.YLabels = YLabels;
            obj.colors = colors;
            obj.sz = sz;
            obj.LineWidth = LineWidth;
            obj.TextSize = TextSize;
            obj.TextInside = TextInside;
            obj.ColorDist = ColorDist;
            obj.AxesFontSize = AxesFontSize;
        end

        function [h1, h2] = build(obj, axesHandle)
            % Draw method that builds the dumbbell chart in the specified
            % axes

            if isempty(axesHandle) 
                axesHandle = gca;
            end

            hold(axesHandle, 'on');
            
            % Y positions
            n= numel(obj.YLabels);
            Yposition= 1:n;

            % lines and descrioptors
            allValues = [obj.Value1, obj.Value2];
            dataRange = max(allValues) - min(allValues);
            dx = dataRange * 0.02; % data text horizontal offset
            dy= 0.2; % vertical offset

            if obj.ColorDist ~= "false"

                switch obj.ColorDist
                    case "directional"
                        differences = obj.Value2 - obj.Value1;
                    case "magnitude"
                        differences = abs(obj.Value1 - obj.Value2);
                    case "robust"
                        differences = obj.Value2 - obj.Value1;
                end
                
                cmap = turbo(256);
                numColors = size(cmap, 1);

                % TBD: if corrent clipping method is adequate for
                % robust scaling, and if it might be necessary to introduce
                % another robust method that uses sigmoid function instead
                % of clipping the values

                if obj.ColorDist == "robust"
                    cmapDiff = (differences - median(differences)) / iqr(differences);
                    cmapDiff = max(-2, min(2, cmapDiff)); % clip is too recent, TO DEBATE if use clip or privilege backwards compatibility
                    cmapIdx = ceil(((cmapDiff + 2) / 4) * (numColors - 1)) + 1;
                    lineColors = cmap(cmapIdx, :);
                else
                    cmapDiff = rescale(differences);
                    cmapIdx= ceil(cmapDiff * (numColors - 1)) + 1;
                    lineColors = cmap(cmapIdx, :);
                end

            end

            for i = 1:n
                if obj.ColorDist == "false"
                    lineColor = 'k';
                else
                    lineColor = lineColors(i,:);
                end
                line(axesHandle, [obj.Value1(i), obj.Value2(i)], ...
                    [Yposition(i), Yposition(i)], ...
                    "Color", lineColor, ...
                    "LineWidth", obj.LineWidth, ...
                    "HandleVisibility", "off")
            end


            switch obj.TextInside
                case false
                    for i = 1:n
                        text(axesHandle, obj.Value1(i)-dx, Yposition(i)-dy, num2str(obj.Value1(i)), ...
                            "HorizontalAlignment","right", "VerticalAlignment", "middle", "FontSize", obj.TextSize)
                        text(axesHandle, obj.Value2(i)+dx, Yposition(i)-dy, num2str(obj.Value2(i)), ...
                            "HorizontalAlignment","left", "VerticalAlignment", "middle", "FontSize", obj.TextSize)
                    end

                    h1 = scatter(axesHandle, obj.Value1, Yposition, obj.sz, obj.colors(1, 1:3), "filled", "o", "MarkerEdgeColor", "k");
                    h2 = scatter(axesHandle, obj.Value2, Yposition, obj.sz, obj.colors(2, 1:3), "filled", "o", "MarkerEdgeColor", "k");
                case true
                    if obj.sz == 70.1
                        obj.sz = 400; %overwrite default value
                    end

                    h1 = scatter(axesHandle, obj.Value1, Yposition, obj.sz, obj.colors(1, 1:3), "filled", "o", "MarkerEdgeColor", obj.colors(2,1:3));
                    h2 = scatter(axesHandle, obj.Value2, Yposition, obj.sz, obj.colors(2, 1:3), "filled", "o", "MarkerEdgeColor", obj.colors(1,1:3));

                    for i = 1:n
                        text(axesHandle, obj.Value1(i), Yposition(i), num2str(obj.Value1(i)), ...
                            "HorizontalAlignment","center", "VerticalAlignment", "middle", "FontSize", obj.TextSize, ...
                            "Color", obj.colors(2, 1:3))
                        text(axesHandle, obj.Value2(i), Yposition(i), num2str(obj.Value2(i)), ...
                            "HorizontalAlignment","center", "VerticalAlignment", "middle", "FontSize", obj.TextSize, ...
                            "Color", obj.colors(1, 1:3))
                    end

            end
            
            % TO DECIDE: if it's best to keep the text below, or above the
            % points, or maybe the first above and the second below the
            % data points. alignment with the datapoints doesn't look
            % convenient in case of big numbers...
            

            ylim(axesHandle, [0.5 n+0.5])
            xlim(axesHandle, "padded")
            yticks(axesHandle, Yposition)
            yticklabels(axesHandle, obj.YLabels)
            xlabel(axesHandle, "Values")

            set(axesHandle, 'FontSize', obj.AxesFontSize)

            hold(axesHandle, 'off');
        end

        function [h1, h2]= buildVertical(obj, axesHandle)

            YValue1= obj.Value1';
            YValue2= obj.Value2';

            if isempty(axesHandle) 
                axesHandle = gca;
            end

            hold(axesHandle, 'on')

            n= numel(obj.YLabels);
            Xposition= 1:n;
            
            % set vertical % offset based on the data
            allValues = [obj.Value1, obj.Value2];
            dataRange = max(allValues) - min(allValues);
            dy = dataRange * 0.02; 

            if obj.ColorDist ~= "false"

                switch obj.ColorDist
                    case "directional"
                        differences = obj.Value2 - obj.Value1;
                    case "magnitude"
                        differences = abs(obj.Value1 - obj.Value2);
                    case "robust"
                        differences = obj.Value2 - obj.Value1;
                end
                
                cmap = turbo(256);
                numColors = size(cmap, 1);

                if obj.ColorDist == "robust"
                    cmapDiff = (differences - median(differences)) / iqr(differences);
                    cmapDiff = max(-2, min(2, cmapDiff)); 
                    cmapIdx = ceil(((cmapDiff + 2) / 4) * (numColors - 1)) + 1;
                    lineColors = cmap(cmapIdx, :);
                else
                    cmapDiff = rescale(differences);
                    cmapIdx= ceil(cmapDiff * (numColors - 1)) + 1;
                    lineColors = cmap(cmapIdx, :);
                end

            end

            for i = 1:n
                if obj.ColorDist == "false"
                    lineColor = 'k';
                else
                    lineColor = lineColors(i,:);
                end
                line(axesHandle, [Xposition(i), Xposition(i)], ...
                    [YValue1(i), YValue2(i)], ...
                    "Color", lineColor, ...
                    "LineWidth", obj.LineWidth, ...
                    "HandleVisibility", "off")
            end


            switch obj.TextInside
                case false
                    for i = 1:n
                        text(axesHandle, Xposition(i), YValue1(i)-dy, num2str(YValue1(i)), ...
                            "HorizontalAlignment","center", "VerticalAlignment", "top", "FontSize", obj.TextSize)
                        text(axesHandle, Xposition(i), YValue2(i)+dy, num2str(YValue2(i)), ...
                            "HorizontalAlignment","center", "VerticalAlignment", "bottom", "FontSize", obj.TextSize)
                    end

                    h1 = scatter(axesHandle, Xposition, YValue1, obj.sz, obj.colors(1, 1:3), "filled", "o", "MarkerEdgeColor", "k");
                    h2 = scatter(axesHandle, Xposition, YValue2, obj.sz, obj.colors(2, 1:3), "filled", "o", "MarkerEdgeColor", "k");
                case true
                    if obj.sz == 70.1
                        obj.sz = 400; %overwrite default value
                    end

                    h1 = scatter(axesHandle, Xposition, YValue1, obj.sz, obj.colors(1, 1:3), "filled", "o", "MarkerEdgeColor", obj.colors(2,1:3));
                    h2 = scatter(axesHandle, Xposition, YValue2, obj.sz, obj.colors(2, 1:3), "filled", "o", "MarkerEdgeColor", obj.colors(1,1:3));

                    for i= 1:n
                        text(axesHandle, Xposition(i), YValue1(i), num2str(YValue1(i)), ...
                            "HorizontalAlignment","center", "VerticalAlignment", "middle", "FontSize", obj.TextSize, ...
                            "Color", obj.colors(2,1:3))
                        text(axesHandle, Xposition(i), YValue2(i), num2str(YValue2(i)), ...
                            "HorizontalAlignment","center", "VerticalAlignment", "middle", "FontSize", obj.TextSize, ...
                            "Color", obj.colors(1,1:3))
                    end

            end

            xlim(axesHandle, [0.5 n+0.5])
            ylim(axesHandle, "padded") %lerting MATLAB handle based on the data

            xticks(axesHandle, Xposition)
            xticklabels(axesHandle, obj.YLabels)
            ylabel(axesHandle, "Values")

            set(axesHandle, 'FontSize', obj.AxesFontSize)

            hold(axesHandle, 'off')
        end
    end
end
