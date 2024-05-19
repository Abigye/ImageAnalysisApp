classdef s1871633_gui < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        ImageAnalysisGUIPanel   matlab.ui.container.Panel
        ImageInputOutputPanel   matlab.ui.container.Panel
        UIAxes                  matlab.ui.control.UIAxes
        Panel_3                 matlab.ui.container.Panel
        GraphingoutputPanel     matlab.ui.container.Panel
        UIAxes2                 matlab.ui.control.UIAxes
        FunctionsPanel          matlab.ui.container.Panel
        IntensityProfileButton  matlab.ui.control.Button
        ResizeButton            matlab.ui.control.Button
        ResetButton             matlab.ui.control.Button
        SaveButton              matlab.ui.control.Button
        cropButton              matlab.ui.control.Button
        PseudocolourButton      matlab.ui.control.Button
        RotateButton            matlab.ui.control.Button
        BrowseButton            matlab.ui.control.Button
        ValueEditField          matlab.ui.control.NumericEditField
        ValueEditFieldLabel     matlab.ui.control.Label
        ImagehistogramButton    matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: BrowseButton
        function BrowseButtonPushed(app, event)
            % Declare a global variable to store the selected image
            global img;
            
            % Open a file selection dialog
            [filename, pathname] = uigetfile('*.*', 'Pick an Image');
            
            % Check if the user cancelled the operation
            if isequal(filename, 0) || isequal(pathname, 0)
                % User cancelled the operation
                title(app.UIAxes, 'No image selected, selection cancelled');
                disp('Image selection cancelled.');
                return;
            end
            
            % Try to read the selected image
            try
                % Read the image using imread and create the full file path
                img = imread(fullfile(pathname, filename));
                
                % Display the image on the UIAxes
                imshow(img, 'Parent', app.UIAxes);
                
                % Set the title of the UIAxes to indicate it's the original image
                title(app.UIAxes, 'Original Image');
            catch ME
                % Handle errors during image reading or display
                title(app.UIAxes, 'No image displayed', ME.message);
                disp(['Error reading image: ', ME.message]);
                return;
            end
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
           global img;

            % Check if the global variable img is not empty
            if ~isempty(img)
                % Display the original image in UIAxes
                imshow(img, 'Parent', app.UIAxes);
                title(app.UIAxes, 'Original Image');
        
                % Clear the second axes and reset the title
                cla(app.UIAxes2);
                title(app.UIAxes2, '');
        
                % Reset the scale factor to 0
                app.ValueEditField.Value = 0;
            else
                % If img is empty, display an error message
                disp('No image loaded.');
                title(app.UIAxes, 'No Image loaded');
            end      
        end

        % Button pushed function: cropButton
        function cropButtonPushed(app, event)
            imgObj = findobj(app.UIAxes, 'Type', 'Image');
            if isempty(imgObj)
                disp('No image loaded.');
                title(app.UIAxes, 'No Image loaded');
                return; % Exit the function if no image is loaded
            end
            
            try
                % Get the image data from the Image object
                imageData = get(imgObj, 'CData');

                % Interactive crop: Let the user draw a rectangle
                croppedImage = imcrop(imageData);

                % Display the cropped image
                imshow(croppedImage, 'Parent', app.UIAxes);
                title(app.UIAxes, 'Cropped Image');

                % Close the figure opened by imcrop
                close gcf; % gcf refers to the current figure

            catch ME
                disp(['Error  image: ', ME.message]);
                return;
            end
        end

        % Button pushed function: PseudocolourButton
        function PseudocolourButtonPushed(app, event)
            imgObj = findobj(app.UIAxes, 'Type', 'Image');
            if isempty(imgObj)
                disp('No image loaded.');
                title(app.UIAxes, 'No Image loaded');
                return; % Exit the function if no image is loaded
            end
            
            try
                % Get the image data from the Image object
                imageData = get(imgObj, 'CData');

                % Convert the image to grayscale
                gray_image = im2gray(imageData);
               
                % Pseudocolour the image using the current colormap
                indexed_image = gray2ind(gray_image, 256);
                        
                % Use the scaled indexed image directly with ind2rgb
                rgb_image = ind2rgb(indexed_image, colormap);

                % Display the cropped image
                imshow(rgb_image,'Parent', app.UIAxes);
                title(app.UIAxes, 'Pseudocoloured Image');

                % Close the figure opened by pseudocolour
                close gcf; % gcf refers to the current figure
            catch ME
                disp(['Error  image: ', ME.message]);
                return;
            end
        end

        % Button pushed function: RotateButton
        function RotateButtonPushed(app, event)
            imgObj = findobj(app.UIAxes, 'Type', 'Image');
            if isempty(imgObj)
                disp('No image loaded.');
                title(app.UIAxes, 'No Image loaded');
                return; % Exit the function if no image is loaded
            end
                
            try
                % Get the rotation angle from the ValueEditField
                rotationAngle = app.ValueEditField.Value;
        
                % Validate the rotation angle
                if ~isnumeric(rotationAngle) || ~isscalar(rotationAngle) || isnan(rotationAngle)
                    errordlg('Invalid rotation angle. Please enter a numeric value (positive or negative) in the value field');
                end
                
                % Get the image data from the Image object
                imageData = get(imgObj, 'CData');

                % Rotate the image
                rotatedImage = imrotate(imageData, rotationAngle);
    
                % Display the rotated image in UIAxes
                imshow(rotatedImage, 'Parent', app.UIAxes);
                title(app.UIAxes, ['Rotated Image by ', num2str(rotationAngle), ' degrees']);
              
            catch ME
                % Handle errors
                disp(['Error: ', ME.message]);
                title(app.UIAxes, 'Error occurred');
            end
        end

        % Button pushed function: ImagehistogramButton
        function ImagehistogramButtonPushed(app, event)

            % Find the image object in UIAxes
            imgObj = findobj(app.UIAxes, 'Type', 'Image');

             % Check if there is no image loaded
            if isempty(imgObj)
                disp('No image loaded.');
                title(app.UIAxes, 'No Image loaded');
                return; % Exit the function if no image is loaded
            end

            try
                % Get the image data from the Image object
                imageData = get(imgObj, 'CData');

                % Display the histogram of the current image UIAxes2 using histogram
                histogram(app.UIAxes2, imageData(:), 'BinMethod', 'auto','EdgeColor','none','LineWidth', 0.5);
         
                % Set the title and labels
                title(app.UIAxes2, 'Image Histogram');
                xlabel(app.UIAxes2, 'Pixel Value');
                ylabel(app.UIAxes2, 'Frequency');
            catch ME
                % Handle errors
                disp(['Error: ', ME.message]);
                title(app.UIAxes2, 'Error occurred');
            end
        end

        % Button pushed function: ResizeButton
        function ResizeButtonPushed(app, event)
           % Find the image object in UIAxes
            imgObj = findobj(app.UIAxes, 'Type', 'Image');
        
            % Check if there is no image loaded
            if isempty(imgObj)
                disp('No image loaded.');
                title(app.UIAxes, 'No Image loaded');
                return; % Exit the function if no image is loaded
            end
        
            try
                % Get the scale factor from the ValueEditField
                scaleFactor = app.ValueEditField.Value;
        
                % Validate the scale factor
                if ~isnumeric(scaleFactor) || scaleFactor <= 0 || isnan(scaleFactor)
                    % Prompt the user to enter a valid scale factor
                    errordlg('Please enter a valid scale factor in the value field before resizing.', 'Invalid Scale Factor');
                    return;
                end
        
                % Create a dialog box to select the resizing method
                methods = {'bilinear', 'nearest', 'bicubic', 'lanczos3','lanczos2', 'cubic', 'triangle', 'box'};
                defaultMethod = 'bicubic'; % Set the default method to bicubic
        
                % Use inputdlg instead of listdlg to handle the case where the user closes the dialog
                dlgTitle = 'Select Resizing Method';
                prompt = 'Choose resizing method:';
                [methodIndex, ok] = listdlg('ListString', methods, 'SelectionMode', 'single', ...
                    'ListSize', [200, 300], 'InitialValue', find(strcmpi(defaultMethod, methods)), ...
                    'Name', dlgTitle, 'PromptString', prompt);
        
                % Check if the user canceled the operation
                if isempty(methodIndex) || ~ok
                    disp('Resizing canceled.');
                    return;
                end
        
                % Map the selected index to the method
                method = methods{methodIndex};
        
                % Get the image data from the Image object
                imageData = get(imgObj, 'CData');
        
                % Resize the image using the selected method
                resizedImage = imresize(imageData, scaleFactor, method);
        
                % Display the resized image in UIAxes
                imshow(resizedImage, 'Parent', app.UIAxes);
                title(app.UIAxes, ['Resized Image by a factor of ', num2str(scaleFactor), ' by ', method, ' method']);
        
            catch ME
                % Handle errors
                disp(['Error: ', ME.message]);
                title(app.UIAxes, 'Error occurred');
            end
        end

        % Button pushed function: IntensityProfileButton
        function IntensityProfileButtonPushed(app, event)
            % Check if an image is loaded
            imgObj = findobj(app.UIAxes, 'Type', 'Image');
            if isempty(imgObj)
                disp('No image loaded.');
                title(app.UIAxes2, 'No Image loaded');
                return; % Exit the function if no image is loaded
            end
        
            % Get the image data from the Image object
            imageData = get(imgObj, 'CData');
        
            % Check image dimensions
            [~, ~, channels] = size(imageData);
        
            if channels == 3
                % RGB image
                % Let the user choose the exploration option using a custom dialog box
                dlgTitle = 'Intensity Profile Exploration';
                prompt = 'Choose exploration option:';
                options = {'Explore all channels', 'Explore individual channel', 'Explore intensity in grayscale'};
                choice = uiconfirm(app.UIFigure, prompt, dlgTitle, 'Options', options, 'DefaultOption', 'Explore all channels');
                
                if isempty(choice)
                    disp('Intensity profile canceled.');
                    return;
                end        
           
                disp(choice);
        
                % Let the user draw a line on the image with a different color
                h = drawline(app.UIAxes);
                wait(h);    % Wait for the user to finish drawing the line
                position = h.Position;
                % delete(h);  % Remove the drawn line from the UIAxes
        
                % Extract the coordinates of the line
                x = position(:, 1);
                y = position(:, 2);

                colors = {'red', 'green', 'blue'}; 

                % Generate the intensity profiles based on user choice
                if strcmpi(choice, 'Explore all channels')
                    % Generate the intensity profiles along the line for each channel
                    numChannels = size(imageData, 3);
                    profileValues = []; % Initialize as empty, size will be adjusted dynamically
                    for channel = 1:numChannels
                        channelData = imageData(:,:,channel);
                        tempProfile = improfile(channelData, x, y);
            
                        % Check the size and adjust profileValues accordingly
                        if isempty(profileValues)
                            profileValues = zeros(length(tempProfile), numChannels);
                        else
                            % Check if the size matches
                            if size(tempProfile, 1) ~= size(profileValues, 1)
                                % Adjust the size of profileValues
                                profileValues = zeros(length(tempProfile), numChannels);
                            end
                        end

                    profileValues(:, channel) = tempProfile;
        
                    % Plot each channel with its corresponding color
                    plot(app.UIAxes2, tempProfile, 'LineWidth', 1.5, 'DisplayName', sprintf('Channel %d', channel), 'Color', colors{channel});
                    hold(app.UIAxes2, 'on');
                    end
        
                % Set plot title and labels
                title(app.UIAxes2, 'Intensity Profiles (All Channels)');
                xlabel(app.UIAxes2, 'Position');
                ylabel(app.UIAxes2, 'Intensity');
                hold(app.UIAxes2, 'off');
                
                elseif strcmpi(choice, 'Explore individual channel')
                    % Ask the user to select a channel
                    channelLabels = cell(1, channels);
                    for channel = 1:channels
                        channelLabels{channel} = sprintf('%d - %s', channel, colors{channel});
                    end
                    
                    channelChoice = listdlg('PromptString', 'Choose a channel:', 'ListString', channelLabels, 'SelectionMode', 'single');
                                        
                    if isempty(channelChoice)
                        title(app.UIAxes2, 'Intensity profile cancelled.');
                        disp('Intensity profile cancelled.');
                        return;
                    else
                    % Extract the selected channel data
                    selectedChannel = imageData(:,:,channelChoice);
                    
                    % Generate the intensity profile along the line for the selected channel
                    profileValues = improfile(selectedChannel, x, y);
                    
                    % Plot the intensity profile on UIAxes2 using the selected color
                    selectedColor = colors{channelChoice};
                    plot(app.UIAxes2, profileValues, 'LineWidth', 1.5, 'DisplayName', sprintf('Channel %d - %s', channelChoice, selectedColor), 'Color', selectedColor);
                    title(app.UIAxes2, ['Intensity Profile (Channel ', num2str(channelChoice), ' - ', selectedColor, ')']);
                    xlabel(app.UIAxes2, 'Distance along profile');
                    ylabel(app.UIAxes2, 'Intensity');
                    end
                else
                    % Convert RGB to grayscale
                    grayscaleImage = rgb2gray(imageData);
                    
                    % Generate the intensity profile along the line for the grayscale image
                    profileValues = improfile(grayscaleImage, x, y);
        
                    % Plot the intensity profile on UIAxes2
                    plot(app.UIAxes2, profileValues);
                    title(app.UIAxes2, 'Intensity Profile (RGB Image in Grayscale)');
                    xlabel(app.UIAxes2, 'Distance along profile');
                    ylabel(app.UIAxes2, 'Intensity');
                end
            else
                % Grayscale image (M*N)
                % Let the user draw a line on the image
                h = drawline(app.UIAxes);
                wait(h);    % Wait for the user to finish drawing the line
                position = h.Position;
               
                % Extract the coordinates of the line
                x = position(:, 1);
                y = position(:, 2);
        
                % Generate the intensity profile along the line for the grayscale image
                profileValues = improfile(imageData, x, y);
        
                % Plot the intensity profile on UIAxes2
                plot(app.UIAxes2, profileValues);
                title(app.UIAxes2, 'Intensity Profile for M*N image');
                xlabel(app.UIAxes2, 'Distance along profile');
                ylabel(app.UIAxes2, 'Intensity');
            end
        end

        % Button pushed function: SaveButton
        function SaveButtonPushed(app, event)
            imgObj = findobj(app.UIAxes, 'Type', 'Image');
            if isempty(imgObj)
                disp('No image loaded.');
                title(app.UIAxes, 'No Image loaded');
                return; % Exit the function if no image is loaded
            end
        
            % Create a confirmation dialog box
            choice = uiconfirm(app.UIFigure, 'What do you want to save?', 'Save', ...
                'Options', {'Image', 'Graph', 'Cancel'}, 'DefaultOption', 'Image');
        
            switch choice
                case 'Image'
                    % Save the image
                    [file, path] = uiputfile({'*.png'; '*.jpg'; '*.bmp'}, 'Save Image As');
                    if isequal(file, 0) || isequal(path, 0)
                        disp('Image saving cancelled.');
                        return;
                    end
                     % Capture the content of UIAxes and save it as an image
                    exportgraphics(app.UIAxes, fullfile(path, file));
                    disp(['Image saved successfully: ', fullfile(path, file)]);
                case 'Graph'
                    % Save the intensity profile graph
                    [file, path] = uiputfile({'*.png'; '*.jpg'; '*.bmp'}, 'Save Graph As');
                    if isequal(file, 0) || isequal(path, 0)
                        disp('Graph saving cancelled.');
                        return;
                    end
                     % Capture the content of UIAxes2 and save it as an image
                    exportgraphics(app.UIAxes2, fullfile(path, file));
                    disp(['Graph saved successfully: ', fullfile(path, file)]);
                case 'Cancel'
                    % User cancelled the operation
                    disp('Saving cancelled.');
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 673 489];
            app.UIFigure.Name = 'MATLAB App';

            % Create ImageAnalysisGUIPanel
            app.ImageAnalysisGUIPanel = uipanel(app.UIFigure);
            app.ImageAnalysisGUIPanel.TitlePosition = 'centertop';
            app.ImageAnalysisGUIPanel.Title = 'Image Analysis GUI';
            app.ImageAnalysisGUIPanel.BackgroundColor = [0.902 0.902 0.902];
            app.ImageAnalysisGUIPanel.Position = [11 9 648 472];

            % Create Panel_3
            app.Panel_3 = uipanel(app.ImageAnalysisGUIPanel);
            app.Panel_3.Position = [374 9 260 433];

            % Create FunctionsPanel
            app.FunctionsPanel = uipanel(app.Panel_3);
            app.FunctionsPanel.BorderColor = [0.8 0.8 0.8];
            app.FunctionsPanel.TitlePosition = 'centertop';
            app.FunctionsPanel.Title = 'Functions';
            app.FunctionsPanel.BackgroundColor = [0.902 0.902 0.902];
            app.FunctionsPanel.Position = [16 253 231 168];

            % Create ImagehistogramButton
            app.ImagehistogramButton = uibutton(app.FunctionsPanel, 'push');
            app.ImagehistogramButton.ButtonPushedFcn = createCallbackFcn(app, @ImagehistogramButtonPushed, true);
            app.ImagehistogramButton.BackgroundColor = [0.8 0.8 0.8];
            app.ImagehistogramButton.Position = [9 14 98 23];
            app.ImagehistogramButton.Text = 'Image histogram';

            % Create ValueEditFieldLabel
            app.ValueEditFieldLabel = uilabel(app.FunctionsPanel);
            app.ValueEditFieldLabel.HorizontalAlignment = 'right';
            app.ValueEditFieldLabel.Position = [121 14 34 22];
            app.ValueEditFieldLabel.Text = 'Value';

            % Create ValueEditField
            app.ValueEditField = uieditfield(app.FunctionsPanel, 'numeric');
            app.ValueEditField.Position = [170 14 44 22];

            % Create BrowseButton
            app.BrowseButton = uibutton(app.FunctionsPanel, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.BackgroundColor = [0.8 0.8 0.8];
            app.BrowseButton.Position = [9 111 59 23];
            app.BrowseButton.Text = 'Browse';

            % Create RotateButton
            app.RotateButton = uibutton(app.FunctionsPanel, 'push');
            app.RotateButton.ButtonPushedFcn = createCallbackFcn(app, @RotateButtonPushed, true);
            app.RotateButton.BackgroundColor = [0.8 0.8 0.8];
            app.RotateButton.Position = [9 81 59 23];
            app.RotateButton.Text = 'Rotate';

            % Create PseudocolourButton
            app.PseudocolourButton = uibutton(app.FunctionsPanel, 'push');
            app.PseudocolourButton.ButtonPushedFcn = createCallbackFcn(app, @PseudocolourButtonPushed, true);
            app.PseudocolourButton.BackgroundColor = [0.8 0.8 0.8];
            app.PseudocolourButton.Position = [9 48 98 23];
            app.PseudocolourButton.Text = 'Pseudocolour';

            % Create cropButton
            app.cropButton = uibutton(app.FunctionsPanel, 'push');
            app.cropButton.ButtonPushedFcn = createCallbackFcn(app, @cropButtonPushed, true);
            app.cropButton.BackgroundColor = [0.8 0.8 0.8];
            app.cropButton.Position = [83 111 61 23];
            app.cropButton.Text = 'crop';

            % Create SaveButton
            app.SaveButton = uibutton(app.FunctionsPanel, 'push');
            app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed, true);
            app.SaveButton.BackgroundColor = [0.8 0.8 0.8];
            app.SaveButton.Position = [159 111 55 23];
            app.SaveButton.Text = 'Save';

            % Create ResetButton
            app.ResetButton = uibutton(app.FunctionsPanel, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.BackgroundColor = [0.8 0.8 0.8];
            app.ResetButton.Position = [159 81 57 23];
            app.ResetButton.Text = 'Reset';

            % Create ResizeButton
            app.ResizeButton = uibutton(app.FunctionsPanel, 'push');
            app.ResizeButton.ButtonPushedFcn = createCallbackFcn(app, @ResizeButtonPushed, true);
            app.ResizeButton.BackgroundColor = [0.8 0.8 0.8];
            app.ResizeButton.Position = [85 81 59 23];
            app.ResizeButton.Text = 'Resize';

            % Create IntensityProfileButton
            app.IntensityProfileButton = uibutton(app.FunctionsPanel, 'push');
            app.IntensityProfileButton.ButtonPushedFcn = createCallbackFcn(app, @IntensityProfileButtonPushed, true);
            app.IntensityProfileButton.BackgroundColor = [0.8 0.8 0.8];
            app.IntensityProfileButton.Position = [121 48 95 23];
            app.IntensityProfileButton.Text = 'Intensity Profile';

            % Create GraphingoutputPanel
            app.GraphingoutputPanel = uipanel(app.Panel_3);
            app.GraphingoutputPanel.BorderColor = [0.8 0.8 0.8];
            app.GraphingoutputPanel.TitlePosition = 'centertop';
            app.GraphingoutputPanel.Title = 'Graphing output';
            app.GraphingoutputPanel.BackgroundColor = [0.902 0.902 0.902];
            app.GraphingoutputPanel.Position = [16 11 231 235];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.GraphingoutputPanel);
            title(app.UIAxes2, 'Title')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [9 17 210 175];

            % Create ImageInputOutputPanel
            app.ImageInputOutputPanel = uipanel(app.ImageAnalysisGUIPanel);
            app.ImageInputOutputPanel.BorderColor = [0.651 0.651 0.651];
            app.ImageInputOutputPanel.TitlePosition = 'centertop';
            app.ImageInputOutputPanel.Title = 'Image Input / Output';
            app.ImageInputOutputPanel.BackgroundColor = [1 1 1];
            app.ImageInputOutputPanel.Position = [10 9 356 433];

            % Create UIAxes
            app.UIAxes = uiaxes(app.ImageInputOutputPanel);
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            app.UIAxes.Position = [10 22 332 382];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = s1871633_gui

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end