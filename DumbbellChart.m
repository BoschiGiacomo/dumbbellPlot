classdef DumbbellChart
    % DumbellChart is an object that is used inside the dumbbellPlot
    % function, providing a robust building brick for its more complex
    % functionalities.

    properties
        Value1 (1,:) double
        Value2 (1,:) double
        YLabels (1,:) cell
    end

    methods
        function obj = DumbbellChart(x1, x2, YLabels)
            % Object constructor method
            % Required inputs: x1 and x2, which are the 2 sets of data
            % confronted
            % YLabels sets the labels of the Y ticks
            % Input validation handled by the main function for separation
            % of concerns
            
            obj.Value1 = x1;
            obj.Value2 = x2;
            obj.YLabels = YLabels;
        end

        function [h1, h2] = build(obj, axesHandle)
            % Draw method that builds the dumbbell chart in the specified
            % axes

            if isempty(axesHandle) % handle the axes empty case
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
            dy= 0.15; % vertical offset
            for i = 1:n
                line(axesHandle, [obj.Value1(i), obj.Value2(i)], ...
                    [Yposition(i), Yposition(i)], "Color", "k", "HandleVisibility", "off")
                text(axesHandle, obj.Value1(i)-dx, Yposition(i)-dy, num2str(obj.Value1(i)), ...
                    "HorizontalAlignment","right", "VerticalAlignment", "middle", "FontSize", 12)
                text(axesHandle, obj.Value2(i)+dx, Yposition(i)-dy, num2str(obj.Value2(i)), ...
                    "HorizontalAlignment","left", "VerticalAlignment", "middle", "FontSize", 12)
            end

            h1 = scatter(axesHandle, obj.Value1, Yposition, 70, [0.85, 0.35, 0.35], "filled", "o", "MarkerEdgeColor", "k");
            h2 = scatter(axesHandle, obj.Value2, Yposition, 70, [0.25, 0.45, 0.8], "filled", "o", "MarkerEdgeColor", "k");

            ylim(axesHandle, [0.5 n+0.5])
            xlim(axesHandle, "padded")
            yticks(axesHandle, Yposition)
            yticklabels(axesHandle, obj.YLabels)
            xlabel(axesHandle, "Values")

            set(axesHandle, 'FontSize', 13)

            hold(axesHandle, 'off');
        end
    end
end
