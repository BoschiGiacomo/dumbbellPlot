classdef DumbbellChart
    % DumbellChart is an object that is used inside the dumbbellPlot
    % function, providing a robust building brick for its more complex
    % functionalities.

    properties
        Value1 (1,:) double
        Value2 (1,:) double
        YLabels (1,:) cell
        colors (2,3) double
        size (1,:) double
        LineWidth (1,1) double
        Fontsize (1,1) double
        TextInside (1,1) logical
    end

    methods
        function obj = DumbbellChart(x1, x2, YLabels, colors, size, LineWidth, Fontsize, TextInside)
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
            obj.size = size;
            obj.LineWidth = LineWidth;
            obj.Fontsize = Fontsize;
            obj.TextInside = TextInside;
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
            for i = 1:n
                line(axesHandle, [obj.Value1(i), obj.Value2(i)], ...
                    [Yposition(i), Yposition(i)], "Color", "k", "HandleVisibility", "off", "LineWidth", obj.LineWidth)
            end

            switch obj.TextInside
                case false
                    for i = 1:n
                        text(axesHandle, obj.Value1(i)-dx, Yposition(i)-dy, num2str(obj.Value1(i)), ...
                            "HorizontalAlignment","right", "VerticalAlignment", "middle", "FontSize", obj.Fontsize)
                        text(axesHandle, obj.Value2(i)+dx, Yposition(i)-dy, num2str(obj.Value2(i)), ...
                            "HorizontalAlignment","left", "VerticalAlignment", "middle", "FontSize", obj.Fontsize)
                    end

                    h1 = scatter(axesHandle, obj.Value1, Yposition, obj.size, obj.colors(1, 1:3), "filled", "o", "MarkerEdgeColor", "k");
                    h2 = scatter(axesHandle, obj.Value2, Yposition, obj.size, obj.colors(2, 1:3), "filled", "o", "MarkerEdgeColor", "k");
                case true
                    if obj.size == 70.1
                        obj.size = 400; %overwrite default value
                    end

                    h1 = scatter(axesHandle, obj.Value1, Yposition, obj.size, obj.colors(1, 1:3), "filled", "o", "MarkerEdgeColor", obj.colors(2,1:3));
                    h2 = scatter(axesHandle, obj.Value2, Yposition, obj.size, obj.colors(2, 1:3), "filled", "o", "MarkerEdgeColor", obj.colors(1,1:3));

                    for i = 1:n
                        text(axesHandle, obj.Value1(i), Yposition(i), num2str(obj.Value1(i)), ...
                            "HorizontalAlignment","center", "VerticalAlignment", "middle", "FontSize", obj.Fontsize, ...
                            "Color", obj.colors(2, 1:3))
                        text(axesHandle, obj.Value2(i), Yposition(i), num2str(obj.Value2(i)), ...
                            "HorizontalAlignment","center", "VerticalAlignment", "middle", "FontSize", obj.Fontsize, ...
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

            set(axesHandle, 'FontSize', 13)

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

            for i = 1:n
                line(axesHandle, [Xposition(i), Xposition(i)], [YValue1(i),YValue2(i)], ...
                    "Color", "k", "HandleVisibility", "off", "LineWidth", obj.LineWidth)
            end

            switch obj.TextInside
                case false
                    for i = 1:n
                        text(axesHandle, Xposition(i), YValue1(i)-dy, num2str(YValue1(i)), ...
                            "HorizontalAlignment","center", "VerticalAlignment", "top", "FontSize", obj.Fontsize)
                        text(axesHandle, Xposition(i), YValue2(i)+dy, num2str(YValue2(i)), ...
                            "HorizontalAlignment","center", "VerticalAlignment", "bottom", "FontSize", obj.Fontsize)
                    end

                    h1 = scatter(axesHandle, Xposition, YValue1, obj.size, obj.colors(1, 1:3), "filled", "o", "MarkerEdgeColor", "k");
                    h2 = scatter(axesHandle, Xposition, YValue2, obj.size, obj.colors(2, 1:3), "filled", "o", "MarkerEdgeColor", "k");
                case true
                    if obj.size == 70.1
                        obj.size = 400; %overwrite default value
                    end

                    h1 = scatter(axesHandle, Xposition, YValue1, obj.size, obj.colors(1, 1:3), "filled", "o", "MarkerEdgeColor", obj.colors(2,1:3));
                    h2 = scatter(axesHandle, Xposition, YValue2, obj.size, obj.colors(2, 1:3), "filled", "o", "MarkerEdgeColor", obj.colors(1,1:3));

                    for i= 1:n
                        text(axesHandle, Xposition(i), YValue1(i), num2str(YValue1(i)), ...
                            "HorizontalAlignment","center", "VerticalAlignment", "middle", "FontSize", obj.Fontsize, ...
                            "Color", obj.colors(2,1:3))
                        text(axesHandle, Xposition(i), YValue2(i), num2str(YValue2(i)), ...
                            "HorizontalAlignment","center", "VerticalAlignment", "middle", "FontSize", obj.Fontsize, ...
                            "Color", obj.colors(1,1:3))
                    end

            end

            xlim(axesHandle, [0.5 n+0.5])
            ylim(axesHandle, "padded") %lerting MATLAB handle based on the data

            xticks(axesHandle, Xposition)
            xticklabels(axesHandle, obj.YLabels)
            ylabel(axesHandle, "Values")

            set(axesHandle, 'FontSize', 13)

            hold(axesHandle, 'off')
        end
    end
end
