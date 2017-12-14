classdef DataAnalyser_view < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        DataAnalyser211UIFigure         matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        ImportDataTab                   matlab.ui.container.Tab
        Panel                           matlab.ui.container.Panel
        DATABROWSERPanel                matlab.ui.container.Panel
        IMPORTDATAButton                matlab.ui.control.Button
        XAXISPanel                      matlab.ui.container.Panel
        NAMELabel                       matlab.ui.control.Label
        XNameEditField                  matlab.ui.control.EditField
        UNITSLabel                      matlab.ui.control.Label
        XUnitsEditField                 matlab.ui.control.EditField
        YAXISPanel                      matlab.ui.container.Panel
        NAMELabel_2                     matlab.ui.control.Label
        YNameEditField                  matlab.ui.control.EditField
        UNITSLabel_2                    matlab.ui.control.Label
        YUnitsEditField                 matlab.ui.control.EditField
        InitialDataTable                matlab.ui.control.Table
        PlotTab                         matlab.ui.container.Tab
        PLOTOPTIONSPanel                matlab.ui.container.Panel
        InitialDataCheckBox             matlab.ui.control.CheckBox
        orderderivativeCheckBox         matlab.ui.control.CheckBox
        orderderivativeCheckBox_2       matlab.ui.control.CheckBox
        IntegrationCheckBox             matlab.ui.control.CheckBox
        InitialDataUIAxes               matlab.ui.control.UIAxes
        CurveFittingTab                 matlab.ui.container.Tab
        Panel_2                         matlab.ui.container.Panel
        RESULTTextAreaLabel             matlab.ui.control.Label
        RESULTTextArea                  matlab.ui.control.TextArea
        FITOPTIONSPanel                 matlab.ui.container.Panel
        MethodDropDown                  matlab.ui.control.DropDown
        DegreeLabel                     matlab.ui.control.Label
        DegreeDropDown                  matlab.ui.control.DropDown
        INITIALGUESSButton              matlab.ui.control.Button
        SaveFittingResultButton         matlab.ui.control.Button
        Panel_3                         matlab.ui.container.Panel
        FittingResultUIAxes             matlab.ui.control.UIAxes
        Panel_4                         matlab.ui.container.Panel
        ResidualUIAxes                  matlab.ui.control.UIAxes
        PeakFindingTab                  matlab.ui.container.Tab
        Panel_6                         matlab.ui.container.Panel
        PeaksOptionsPanel               matlab.ui.container.Panel
        MinimumPeakHeightSpinnerLabel   matlab.ui.control.Label
        MinimumPeakHeightSpinner        matlab.ui.control.Spinner
        MinimumPeakSpacingSpinnerLabel  matlab.ui.control.Label
        MinimumPeakSpacingSpinner       matlab.ui.control.Spinner
        ToleranceEditFieldLabel         matlab.ui.control.Label
        ToleranceEditField              matlab.ui.control.NumericEditField
        PeaksTable                      matlab.ui.control.Table
        FINDPEAKSButton                 matlab.ui.control.Button
        SAVEButton                      matlab.ui.control.Button
        PeaksUIAxes                     matlab.ui.control.UIAxes
    end


    properties (Access = public)
        modelObj                                 DataAnalyser_Model                      % handle of DataAnalyser_Controller
        controllerObj                            DataAnalyser_Controller                 % handle of DataAnalyser_Controller
        handle_initialDataLegend                 matlab.graphics.illustration.Legend     % handle for legend in InitialDataUIAxes
        lineH_InitialDataUIAxes_initialData      matlab.graphics.primitive.Line          % handle for line of initial data in InitialDataUIAxes
        lineH_InitialDataUIAxes_1orderDerivative matlab.graphics.primitive.Line          % handle for line of 1 order derivative data in InitialDataUIAxes
        lineH_InitialDataUIAxes_2orderDerivative matlab.graphics.primitive.Line          % handle for line of 2 order derivative in InitialDataUIAxes
        lineH_InitialDataUIAxes_integration      matlab.graphics.primitive.Line          % handle for line of integration in InitialDataUIAxes
    end

    methods (Access = private)
    
        % regeister callbacks for view (this app) in controller(DataAnalyser_Controller)
        function app = attachToController(app, controller)
            % register callback for ImportButton in controller
            hFunc_callback_ImportDataButton = @controller.callback_ImportDataButton;
            addlistener(app.IMPORTDATAButton,'ButtonPushed',hFunc_callback_ImportDataButton);
            
            % register callback for XNameEditField in controller
            hFunc_callback_XNameEditField = @controller.callback_XNameEditField;
            addlistener(app.XNameEditField,'ValueChanged',hFunc_callback_XNameEditField);
            
            % register callback for XUnitsEditField in controller
            hFunc_callback_XUnitsEditField = @controller.callback_XUnitsEditField;
            addlistener(app.XUnitsEditField,'ValueChanged',hFunc_callback_XUnitsEditField);
            
            % register callback for YNameEditField in controller
            hFunc_callback_YNameEditField = @controller.callback_YNameEditField;
            addlistener(app.YNameEditField,'ValueChanged',hFunc_callback_YNameEditField);
            
            % register callback for XUnitsEditField in controller
            hFunc_callback_YUnitsEditField = @controller.callback_YUnitsEditField;
            addlistener(app.YUnitsEditField,'ValueChanged',hFunc_callback_YUnitsEditField);
            
            % register callback for checkboxes in PlotOptionPanel (in this app)
            addlistener(app.InitialDataCheckBox, 'ValueChanged', @app.plotInitialDataUIAxes);
            addlistener(app.orderderivativeCheckBox, 'ValueChanged', @app.plotInitialDataUIAxes);
            addlistener(app.orderderivativeCheckBox_2, 'ValueChanged', @app.plotInitialDataUIAxes);
            addlistener(app.IntegrationCheckBox, 'ValueChanged', @app.plotInitialDataUIAxes);
            
            % register callback for DegreeDropDown in CurveFittingTab 
            hFunc_callback_DegreeDropDown = @controller.callback_DegreeDropDown;
            addlistener(app.DegreeDropDown, 'ValueChanged', hFunc_callback_DegreeDropDown);
            
            % register callback for MinimumPeakHeightSpinner in Peaks Finding Tab
            hFunc_callback_MinimumPeakHeightSpinner = @controller.callback_MinimumPeakHeightSpinner;
            addlistener(app.MinimumPeakHeightSpinner, 'ValueChanged', hFunc_callback_MinimumPeakHeightSpinner);
            
            % register callback for MinimumPeakSpacingSpinner in Peaks Finding Tab
            hFunc_callback_MinimumPeakSpacingSpinner = @controller.callback_MinimumPeakSpacingSpinner;
            addlistener(app.MinimumPeakSpacingSpinner, 'ValueChanged', hFunc_callback_MinimumPeakSpacingSpinner);
            
            % register callback for ToleranceEditField in Peaks Finding Tab
            hFunc_callback_ToleranceEditField = @controller.callback_ToleranceEditField;
            addlistener(app.ToleranceEditField, 'ValueChanged', hFunc_callback_ToleranceEditField);
            
            % register callback for FINDPEAKSButton in Peaks Finding Tab
            hFunc_callback_FINDPEAKSButton = @controller.callback_FINDPEAKSButton;
            addlistener(app.FINDPEAKSButton,'ButtonPushed',hFunc_callback_FINDPEAKSButton);
            
        end
        
        % set xlabel using data in modelObj
        function setXLabel(app, src, event)
            strXLabel = strcat(app.modelObj.inputData.get_xlabel, 32, app.modelObj.inputData.get_xunits);
            app.InitialDataUIAxes.XLabel.String = strXLabel;
            app.FittingResultUIAxes.XLabel.String = strXLabel;
            app.ResidualUIAxes.XLabel.String = strXLabel;
            app.PeaksUIAxes.XLabel.String = strXLabel;
            app.InitialDataTable.ColumnName(1) = {app.modelObj.inputData.get_xlabel};
        end
        
        % set ylabel using data in modelObj
        function setYLabel(app, src, event)
            strYLabel = strcat(app.modelObj.inputData.get_ylabel, 32, app.modelObj.inputData.get_yunits);
            app.InitialDataUIAxes.YLabel.String = strYLabel;
            app.FittingResultUIAxes.YLabel.String = strYLabel;
            app.PeaksUIAxes.XLabel.String = strYLabel;
            app.InitialDataTable.ColumnName(2) = {app.modelObj.inputData.get_ylabel};
        end
        
        function updateInitialDataTable(app, src, event)
            app.InitialDataTable.Data = [app.modelObj.inputData.get_xaxis, app.modelObj.inputData.get_yaxis];
        end
        
        % decide what to plot in InitialDataUIAxes after data updated
        function plotInitialDataUIAxes(app,src,event)
            % initial data
            if(app.InitialDataCheckBox.Value)
                app.plotInitialData(app.modelObj.inputData.get_xaxis, app.modelObj.inputData.get_yaxis);
            else
                delete(app.lineH_InitialDataUIAxes_initialData);
            end
            % 1 order derivative
            if(app.orderderivativeCheckBox.Value)
                app.plot1OrderDerivative(app.modelObj.inputData.get_xaxis, app.modelObj.inputData.get_1orderDerivative);
            else
                delete(app.lineH_InitialDataUIAxes_1orderDerivative);
            end
            % 2 order derivative
            if(app.orderderivativeCheckBox_2.Value)
                app.plot2OrderDerivative(app.modelObj.inputData.get_xaxis, app.modelObj.inputData.get_2orderDerivative);
            else
                delete(app.lineH_InitialDataUIAxes_2orderDerivative);
            end
            % integration
            if(app.IntegrationCheckBox.Value)
                app.plotIntegration(app.modelObj.inputData.get_xaxis, app.modelObj.inputData.get_integration);
            else
                delete(app.lineH_InitialDataUIAxes_integration);
            end
        end
        
         % method to plot initial data
        function plotInitialData(app,xdata,ydata)
            delete(app.lineH_InitialDataUIAxes_initialData);
            app.lineH_InitialDataUIAxes_initialData = line(app.InitialDataUIAxes,...
                'xdata', xdata,...
                'ydata', ydata,...
                'linestyle', '-',... 
                'color', [0,0.45,0.74]);
            app.handle_initialDataLegend.String(end) = {'initial data'};
        end
        
        % method to plot 1 order derivative
        function plot1OrderDerivative(app,xdata,ydata)
            autoScale1 = max(app.modelObj.inputData.get_yaxis) ./ (max(ydata)*2); 
            ydata = autoScale1 .* ydata;
            delete(app.lineH_InitialDataUIAxes_1orderDerivative);
            app.lineH_InitialDataUIAxes_1orderDerivative = line(app.InitialDataUIAxes,...
                'xdata', xdata,...
                'ydata', ydata,...
                'linestyle', '--',... 
                'color', [0.85,0.33,0.10]);
            app.handle_initialDataLegend.String(end) = {'1 order derivative'};
        end
        
        % method to plot 2 order derivative
        function plot2OrderDerivative(app,xdata,ydata)
            autoScale2 = (max(app.modelObj.inputData.get_1orderDerivative) ./ (max(ydata)*2)) ...
                .* (max(app.modelObj.inputData.get_yaxis) ./ (max(ydata)*2));
            ydata = autoScale2 .* ydata;
            delete(app.lineH_InitialDataUIAxes_2orderDerivative);
            app.lineH_InitialDataUIAxes_2orderDerivative = line(app.InitialDataUIAxes,...
                'xdata', xdata,...
                'ydata', ydata,...
                'linestyle', '-.',...
                'linewidth',1,...
                'color', [0.93,0.69,0.13]);
            app.handle_initialDataLegend.String(end) = {'2 order derivative'};
        end
        
        % method to plot integration
        function plotIntegration(app,xdata,ydata)
            delete(app.lineH_InitialDataUIAxes_integration);
            app.lineH_InitialDataUIAxes_integration = line(app.InitialDataUIAxes,...
                'xdata', xdata,...
                'ydata', ydata,...
                'linestyle', '-',...
                'color', [0.47,0.67,0.19]);
            app.handle_initialDataLegend.String(end) = {'integration'};
        end
         
        % plot on FittingResultUIAxes and ResidualUIAxes after fitting complete
        function plotFittedData(app,src,event)
            % draw initial data and fitted line in FittingResultUIAxes
            delete(allchild(app.FittingResultUIAxes));
            plot(app.FittingResultUIAxes,...
                app.modelObj.fittedData.get_xaxis, app.modelObj.fittedData.get_fitted_yaxis,...
                'linestyle', '-',...
                'color', [0,0.45,0.74]);
            plot(app.FittingResultUIAxes,...
                app.modelObj.fittedData.get_xaxis, app.modelObj.fittedData.get_yaxis,...
                'linestyle', 'none',...
                'marker', 'x',...
                'markersize', 6,...
                'color', [0.85,0.33,0.10]);
            % draw residual in ResidualUIAxes as stem
            delete(allchild(app.ResidualUIAxes))
            stem(app.ResidualUIAxes,...
                app.modelObj.fittedData.get_xaxis, app.modelObj.fittedData.get_residual,...
                'color','k',...
                'markersize',4,...
                'markerface','k');
        end
        
        % update message in ResultTextArea after fitting completed
        function updateFittingResult(app,src,event)
            fittingResult = app.modelObj.fittedData.get_gof();
            app.RESULTTextArea.Value = fittingResult;
        end
        
        function plotPeaks(app,src,event)
            delete(allchild(app.PeaksUIAxes));
            xAxis = app.modelObj.inputData.get_xaxis;
            yAxis = app.modelObj.inputData.get_yaxis;
            xPeaks = app.modelObj.findPeaks.get_peakLocation;
            yPeaks = app.modelObj.findPeaks.get_peakHeight;
            plot(app.PeaksUIAxes,...
                xAxis, yAxis,...
                'linestyle', '-',... 
                'color', [0,0.45,0.74]);
            plot(app.PeaksUIAxes,...
                xPeaks,yPeaks,...
                'linewidth', 2,...
                'linestyle', 'none',...
                'marker', '+',...
                'MarkerFaceColor', 'g')
            legend(app.PeaksUIAxes,{'Initial Data','Peaks'},'fontsize',12,'location','northeast','FontWeight','normal');
        end
        
        function updatePeaksData(app,src,event)
            app.PeaksTable.Data = [app.modelObj.findPeaks.get_peakLocation,...
                app.modelObj.findPeaks.get_peakHeight,...
                app.modelObj.findPeaks.get_peakWidth];
        end
        
    end


    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % instantiate control_obj and attach to it
            x0 = linspace(-3,3,100).';
            y0 = sin(x0);
            app.modelObj = DataAnalyser_Model(x0,y0);
            app.controllerObj = DataAnalyser_Controller(app, app.modelObj);
            app.attachToController(app.controllerObj);                   % need corresponding method
            % add listener to events in modelObj
            addlistener(app.modelObj.inputData, 'data_updated', @app.plotInitialDataUIAxes);
            addlistener(app.modelObj.inputData, 'data_updated', @app.updateInitialDataTable);
            addlistener(app.modelObj, 'fitting_complete', @app.plotFittedData);
            addlistener(app.modelObj, 'fitting_complete', @app.updateFittingResult);
            addlistener(app.modelObj,'peakFinding_complete',@app.plotPeaks);
            addlistener(app.modelObj,'peakFinding_complete',@app.updatePeaksData);
            % add listener to predefined events in modelObj
            addlistener(app.modelObj.inputData, 'm_name_x', 'PostSet', @app.setXLabel);
            addlistener(app.modelObj.inputData, 'm_name_y', 'PostSet', @app.setYLabel);
            addlistener(app.modelObj.inputData, 'm_units_x', 'PostSet', @app.setXLabel);
            addlistener(app.modelObj.inputData, 'm_units_y', 'PostSet', @app.setYLabel);
            % set data tables
            app.InitialDataTable.RowName = 'numbered';
            app.InitialDataTable.Data = [app.modelObj.inputData.get_xaxis, app.modelObj.inputData.get_yaxis];
            % set PeaksTable
            app.PeaksTable.RowName = 'numbered';
            % instantiate legend handel under UIAxes
            app.handle_initialDataLegend = legend(app.InitialDataUIAxes,...
                {},...
                'location', 'northeast',...
                'fontsize',12,...
                'FontWeight','normal');
        end

        % Button pushed function: INITIALGUESSButton
        function INITIALGUESSButtonPushed(app, event)
            prompt={'Enter space-separated initial guess'};
            name = 'Initial Guess';
            defaultans = {num2str(app.modelObj.fittedData.get_initialguess().')};
            options.Interpreter = 'tex';
            options.Resize = 'On';
            answer = inputdlg(prompt,name,[1 100],defaultans,options);
            if ~isempty(answer)
                initialguess = str2num(answer{:}).';
                app.controllerObj.callback_InitialGuessButtonPushed(initialguess);
            end
        end

        % Button pushed function: SaveFittingResultButton
        function SaveFittingResultButtonPushed(app, event)
            outputData = app.RESULTTextArea.Value;
            [fileName, pathName, filterIndex] = uiputfile({'*.xls';'*.xlsx'},'Save as');
            if(filterIndex)
                filePath = strcat(pathName, fileName);
                xlswrite(filePath, outputData);
            end
        end

        % Button pushed function: SAVEButton
        function SAVEButtonPushed(app, event)
            outputData = num2cell(app.PeaksTable.Data);
            outputRows = length(outputData)+1;
            output = cell([outputRows,3]);
            output(1,:) = app.PeaksTable.ColumnName;
            output(2:end,:) = outputData;
            [fileName, pathName, filterIndex] = uiputfile({'*.xls';'*.xlsx'},'Save as');
            if(filterIndex)
                filePath = strcat(pathName, fileName);
                xlswrite(filePath, output);
            end
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create DataAnalyser211UIFigure
            app.DataAnalyser211UIFigure = uifigure;
            app.DataAnalyser211UIFigure.Color = [1 1 1];
            app.DataAnalyser211UIFigure.Position = [100 100 1174 779];
            app.DataAnalyser211UIFigure.Name = 'DataAnalyser (2.1.1)';
            app.DataAnalyser211UIFigure.Resize = 'off';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.DataAnalyser211UIFigure);
            app.TabGroup.Position = [1 1 1174 779];

            % Create ImportDataTab
            app.ImportDataTab = uitab(app.TabGroup);
            app.ImportDataTab.Title = 'Import Data';
            app.ImportDataTab.BackgroundColor = [1 1 1];

            % Create Panel
            app.Panel = uipanel(app.ImportDataTab);
            app.Panel.BackgroundColor = [1 1 1];
            app.Panel.Position = [57 37 410 678];

            % Create DATABROWSERPanel
            app.DATABROWSERPanel = uipanel(app.Panel);
            app.DATABROWSERPanel.Title = ' DATA BROWSER';
            app.DATABROWSERPanel.BackgroundColor = [1 1 1];
            app.DATABROWSERPanel.FontWeight = 'bold';
            app.DATABROWSERPanel.FontSize = 16;
            app.DATABROWSERPanel.Position = [18 515 374 138];

            % Create IMPORTDATAButton
            app.IMPORTDATAButton = uibutton(app.DATABROWSERPanel, 'push');
            app.IMPORTDATAButton.BackgroundColor = [1 1 1];
            app.IMPORTDATAButton.FontSize = 16;
            app.IMPORTDATAButton.Position = [112 44 150 33];
            app.IMPORTDATAButton.Text = 'IMPORT DATA';

            % Create XAXISPanel
            app.XAXISPanel = uipanel(app.Panel);
            app.XAXISPanel.Title = ' X AXIS';
            app.XAXISPanel.BackgroundColor = [1 1 1];
            app.XAXISPanel.FontWeight = 'bold';
            app.XAXISPanel.FontSize = 16;
            app.XAXISPanel.Position = [18 266 374 188];

            % Create NAMELabel
            app.NAMELabel = uilabel(app.XAXISPanel);
            app.NAMELabel.VerticalAlignment = 'center';
            app.NAMELabel.FontSize = 16;
            app.NAMELabel.Position = [27 109 61 20];
            app.NAMELabel.Text = 'NAME';

            % Create XNameEditField
            app.XNameEditField = uieditfield(app.XAXISPanel, 'text');
            app.XNameEditField.FontSize = 16;
            app.XNameEditField.Position = [93 109 259 27];
            app.XNameEditField.Value = 'XAXIS';

            % Create UNITSLabel
            app.UNITSLabel = uilabel(app.XAXISPanel);
            app.UNITSLabel.VerticalAlignment = 'center';
            app.UNITSLabel.FontSize = 16;
            app.UNITSLabel.Position = [27 46 67 20];
            app.UNITSLabel.Text = 'UNITS';

            % Create XUnitsEditField
            app.XUnitsEditField = uieditfield(app.XAXISPanel, 'text');
            app.XUnitsEditField.FontSize = 16;
            app.XUnitsEditField.Position = [93 41 259 27];

            % Create YAXISPanel
            app.YAXISPanel = uipanel(app.Panel);
            app.YAXISPanel.Title = ' Y AXIS';
            app.YAXISPanel.BackgroundColor = [1 1 1];
            app.YAXISPanel.FontWeight = 'bold';
            app.YAXISPanel.FontSize = 16;
            app.YAXISPanel.Position = [18 26 374 188];

            % Create NAMELabel_2
            app.NAMELabel_2 = uilabel(app.YAXISPanel);
            app.NAMELabel_2.VerticalAlignment = 'center';
            app.NAMELabel_2.FontSize = 16;
            app.NAMELabel_2.Position = [27 109 61 20];
            app.NAMELabel_2.Text = 'NAME';

            % Create YNameEditField
            app.YNameEditField = uieditfield(app.YAXISPanel, 'text');
            app.YNameEditField.FontSize = 16;
            app.YNameEditField.Position = [93 109 259 27];
            app.YNameEditField.Value = 'YAXIS';

            % Create UNITSLabel_2
            app.UNITSLabel_2 = uilabel(app.YAXISPanel);
            app.UNITSLabel_2.VerticalAlignment = 'center';
            app.UNITSLabel_2.FontSize = 16;
            app.UNITSLabel_2.Position = [27 46 67 20];
            app.UNITSLabel_2.Text = 'UNITS';

            % Create YUnitsEditField
            app.YUnitsEditField = uieditfield(app.YAXISPanel, 'text');
            app.YUnitsEditField.FontSize = 16;
            app.YUnitsEditField.Position = [93 41 259 27];

            % Create InitialDataTable
            app.InitialDataTable = uitable(app.ImportDataTab);
            app.InitialDataTable.ColumnName = {'XAXIS'; 'YAXIS'};
            app.InitialDataTable.RowName = {};
            app.InitialDataTable.FontSize = 16;
            app.InitialDataTable.Position = [606 37 504 678];

            % Create PlotTab
            app.PlotTab = uitab(app.TabGroup);
            app.PlotTab.Title = 'Plot';
            app.PlotTab.BackgroundColor = [1 1 1];

            % Create PLOTOPTIONSPanel
            app.PLOTOPTIONSPanel = uipanel(app.PlotTab);
            app.PLOTOPTIONSPanel.TitlePosition = 'centertop';
            app.PLOTOPTIONSPanel.Title = '          PLOT OPTIONS';
            app.PLOTOPTIONSPanel.BackgroundColor = [1 1 1];
            app.PLOTOPTIONSPanel.FontWeight = 'bold';
            app.PLOTOPTIONSPanel.FontSize = 16;
            app.PLOTOPTIONSPanel.Position = [0 1 1174 86];

            % Create InitialDataCheckBox
            app.InitialDataCheckBox = uicheckbox(app.PLOTOPTIONSPanel);
            app.InitialDataCheckBox.Text = ' Initial Data';
            app.InitialDataCheckBox.FontSize = 16;
            app.InitialDataCheckBox.Position = [61 17 139 21];
            app.InitialDataCheckBox.Value = true;

            % Create orderderivativeCheckBox
            app.orderderivativeCheckBox = uicheckbox(app.PLOTOPTIONSPanel);
            app.orderderivativeCheckBox.Text = ' 1 order derivative';
            app.orderderivativeCheckBox.FontSize = 16;
            app.orderderivativeCheckBox.Position = [375 17 150 20];
            app.orderderivativeCheckBox.Value = true;

            % Create orderderivativeCheckBox_2
            app.orderderivativeCheckBox_2 = uicheckbox(app.PLOTOPTIONSPanel);
            app.orderderivativeCheckBox_2.Text = ' 2 order derivative';
            app.orderderivativeCheckBox_2.FontSize = 16;
            app.orderderivativeCheckBox_2.Position = [699 17 150 20];
            app.orderderivativeCheckBox_2.Value = true;

            % Create IntegrationCheckBox
            app.IntegrationCheckBox = uicheckbox(app.PLOTOPTIONSPanel);
            app.IntegrationCheckBox.Text = ' Integration';
            app.IntegrationCheckBox.FontSize = 16;
            app.IntegrationCheckBox.Position = [1023 17 150 20];
            app.IntegrationCheckBox.Value = true;

            % Create InitialDataUIAxes
            app.InitialDataUIAxes = uiaxes(app.PlotTab);
            xlabel(app.InitialDataUIAxes, 'X')
            ylabel(app.InitialDataUIAxes, 'Y')
            app.InitialDataUIAxes.FontSize = 16;
            app.InitialDataUIAxes.FontWeight = 'bold';
            app.InitialDataUIAxes.GridLineStyle = '--';
            app.InitialDataUIAxes.Box = 'on';
            app.InitialDataUIAxes.LineWidth = 1;
            app.InitialDataUIAxes.NextPlot = 'add';
            app.InitialDataUIAxes.XGrid = 'on';
            app.InitialDataUIAxes.YGrid = 'on';
            app.InitialDataUIAxes.BackgroundColor = [1 1 1];
            app.InitialDataUIAxes.Position = [1 98 1172 657];

            % Create CurveFittingTab
            app.CurveFittingTab = uitab(app.TabGroup);
            app.CurveFittingTab.Title = 'Curve Fitting';
            app.CurveFittingTab.BackgroundColor = [1 1 1];

            % Create Panel_2
            app.Panel_2 = uipanel(app.CurveFittingTab);
            app.Panel_2.BackgroundColor = [1 1 1];
            app.Panel_2.Position = [40 30 346 691];

            % Create RESULTTextAreaLabel
            app.RESULTTextAreaLabel = uilabel(app.Panel_2);
            app.RESULTTextAreaLabel.VerticalAlignment = 'center';
            app.RESULTTextAreaLabel.FontSize = 16;
            app.RESULTTextAreaLabel.FontWeight = 'bold';
            app.RESULTTextAreaLabel.Position = [16 383 68 20];
            app.RESULTTextAreaLabel.Text = 'RESULT';

            % Create RESULTTextArea
            app.RESULTTextArea = uitextarea(app.Panel_2);
            app.RESULTTextArea.Editable = 'off';
            app.RESULTTextArea.FontSize = 16;
            app.RESULTTextArea.Position = [16 61 310 315];

            % Create FITOPTIONSPanel
            app.FITOPTIONSPanel = uipanel(app.Panel_2);
            app.FITOPTIONSPanel.Title = ' FIT OPTIONS';
            app.FITOPTIONSPanel.BackgroundColor = [1 1 1];
            app.FITOPTIONSPanel.FontWeight = 'bold';
            app.FITOPTIONSPanel.FontSize = 16;
            app.FITOPTIONSPanel.Position = [18 429 310 242];

            % Create MethodDropDown
            app.MethodDropDown = uidropdown(app.FITOPTIONSPanel);
            app.MethodDropDown.Items = {' Polynomial'};
            app.MethodDropDown.FontSize = 16;
            app.MethodDropDown.BackgroundColor = [1 1 1];
            app.MethodDropDown.Position = [34 162 242 31];
            app.MethodDropDown.Value = ' Polynomial';

            % Create DegreeLabel
            app.DegreeLabel = uilabel(app.FITOPTIONSPanel);
            app.DegreeLabel.VerticalAlignment = 'center';
            app.DegreeLabel.FontSize = 16;
            app.DegreeLabel.Position = [34 97 62 20];
            app.DegreeLabel.Text = ' Degree';

            % Create DegreeDropDown
            app.DegreeDropDown = uidropdown(app.FITOPTIONSPanel);
            app.DegreeDropDown.Items = {'2', '3', '4', '5', '6', '7', '8', '9'};
            app.DegreeDropDown.FontSize = 16;
            app.DegreeDropDown.BackgroundColor = [1 1 1];
            app.DegreeDropDown.Position = [107 89 163 31];
            app.DegreeDropDown.Value = '2';

            % Create INITIALGUESSButton
            app.INITIALGUESSButton = uibutton(app.FITOPTIONSPanel, 'push');
            app.INITIALGUESSButton.ButtonPushedFcn = createCallbackFcn(app, @INITIALGUESSButtonPushed, true);
            app.INITIALGUESSButton.BackgroundColor = [1 1 1];
            app.INITIALGUESSButton.FontSize = 16;
            app.INITIALGUESSButton.Position = [34 17 242 31];
            app.INITIALGUESSButton.Text = 'INITIAL GUESS';

            % Create SaveFittingResultButton
            app.SaveFittingResultButton = uibutton(app.Panel_2, 'push');
            app.SaveFittingResultButton.ButtonPushedFcn = createCallbackFcn(app, @SaveFittingResultButtonPushed, true);
            app.SaveFittingResultButton.BackgroundColor = [1 1 1];
            app.SaveFittingResultButton.FontSize = 16;
            app.SaveFittingResultButton.Position = [18 20 308 27];
            app.SaveFittingResultButton.Text = 'SAVE';

            % Create Panel_3
            app.Panel_3 = uipanel(app.CurveFittingTab);
            app.Panel_3.BackgroundColor = [1 1 1];
            app.Panel_3.Position = [431 379 696 350];

            % Create FittingResultUIAxes
            app.FittingResultUIAxes = uiaxes(app.Panel_3);
            xlabel(app.FittingResultUIAxes, 'X')
            ylabel(app.FittingResultUIAxes, 'Y')
            app.FittingResultUIAxes.FontWeight = 'bold';
            app.FittingResultUIAxes.GridLineStyle = '--';
            app.FittingResultUIAxes.Box = 'on';
            app.FittingResultUIAxes.LineWidth = 1;
            app.FittingResultUIAxes.NextPlot = 'add';
            app.FittingResultUIAxes.XGrid = 'on';
            app.FittingResultUIAxes.YGrid = 'on';
            app.FittingResultUIAxes.BackgroundColor = [1 1 1];
            app.FittingResultUIAxes.Position = [0 1 695 349];

            % Create Panel_4
            app.Panel_4 = uipanel(app.CurveFittingTab);
            app.Panel_4.BackgroundColor = [1 1 1];
            app.Panel_4.Position = [431 30 696 346];

            % Create ResidualUIAxes
            app.ResidualUIAxes = uiaxes(app.CurveFittingTab);
            xlabel(app.ResidualUIAxes, 'X')
            ylabel(app.ResidualUIAxes, 'Residual')
            app.ResidualUIAxes.FontWeight = 'bold';
            app.ResidualUIAxes.GridLineStyle = '--';
            app.ResidualUIAxes.Box = 'on';
            app.ResidualUIAxes.LineWidth = 1;
            app.ResidualUIAxes.NextPlot = 'add';
            app.ResidualUIAxes.XGrid = 'on';
            app.ResidualUIAxes.YGrid = 'on';
            app.ResidualUIAxes.BackgroundColor = [1 1 1];
            app.ResidualUIAxes.Position = [432 31 694 338];

            % Create PeakFindingTab
            app.PeakFindingTab = uitab(app.TabGroup);
            app.PeakFindingTab.Title = 'Peak Finding';
            app.PeakFindingTab.BackgroundColor = [1 1 1];

            % Create Panel_6
            app.Panel_6 = uipanel(app.PeakFindingTab);
            app.Panel_6.BackgroundColor = [1 1 1];
            app.Panel_6.Position = [45 33 346 691];

            % Create PeaksOptionsPanel
            app.PeaksOptionsPanel = uipanel(app.Panel_6);
            app.PeaksOptionsPanel.Title = ' Options';
            app.PeaksOptionsPanel.BackgroundColor = [1 1 1];
            app.PeaksOptionsPanel.FontWeight = 'bold';
            app.PeaksOptionsPanel.FontSize = 16;
            app.PeaksOptionsPanel.Position = [15 497 310 170];

            % Create MinimumPeakHeightSpinnerLabel
            app.MinimumPeakHeightSpinnerLabel = uilabel(app.PeaksOptionsPanel);
            app.MinimumPeakHeightSpinnerLabel.HorizontalAlignment = 'right';
            app.MinimumPeakHeightSpinnerLabel.FontSize = 16;
            app.MinimumPeakHeightSpinnerLabel.Position = [13 104 162 20];
            app.MinimumPeakHeightSpinnerLabel.Text = 'Minimum Peak Height';

            % Create MinimumPeakHeightSpinner
            app.MinimumPeakHeightSpinner = uispinner(app.PeaksOptionsPanel);
            app.MinimumPeakHeightSpinner.Position = [190 104 100 23];

            % Create MinimumPeakSpacingSpinnerLabel
            app.MinimumPeakSpacingSpinnerLabel = uilabel(app.PeaksOptionsPanel);
            app.MinimumPeakSpacingSpinnerLabel.HorizontalAlignment = 'right';
            app.MinimumPeakSpacingSpinnerLabel.FontSize = 16;
            app.MinimumPeakSpacingSpinnerLabel.Position = [13 61 174 20];
            app.MinimumPeakSpacingSpinnerLabel.Text = 'Minimum Peak Spacing';

            % Create MinimumPeakSpacingSpinner
            app.MinimumPeakSpacingSpinner = uispinner(app.PeaksOptionsPanel);
            app.MinimumPeakSpacingSpinner.Position = [190 60 100 23];

            % Create ToleranceEditFieldLabel
            app.ToleranceEditFieldLabel = uilabel(app.PeaksOptionsPanel);
            app.ToleranceEditFieldLabel.HorizontalAlignment = 'right';
            app.ToleranceEditFieldLabel.FontSize = 16;
            app.ToleranceEditFieldLabel.Position = [13 18 75 20];
            app.ToleranceEditFieldLabel.Text = 'Tolerance';

            % Create ToleranceEditField
            app.ToleranceEditField = uieditfield(app.PeaksOptionsPanel, 'numeric');
            app.ToleranceEditField.Position = [190 17 100 22];

            % Create PeaksTable
            app.PeaksTable = uitable(app.Panel_6);
            app.PeaksTable.ColumnName = {'LOCATION'; 'HEIGHT'; 'FWHM'};
            app.PeaksTable.RowName = {};
            app.PeaksTable.Position = [18 59 310 370];

            % Create FINDPEAKSButton
            app.FINDPEAKSButton = uibutton(app.Panel_6, 'push');
            app.FINDPEAKSButton.BackgroundColor = [1 1 1];
            app.FINDPEAKSButton.FontSize = 16;
            app.FINDPEAKSButton.Position = [72 449 202 27];
            app.FINDPEAKSButton.Text = 'FIND PEAKS';

            % Create SAVEButton
            app.SAVEButton = uibutton(app.Panel_6, 'push');
            app.SAVEButton.ButtonPushedFcn = createCallbackFcn(app, @SAVEButtonPushed, true);
            app.SAVEButton.BackgroundColor = [1 1 1];
            app.SAVEButton.FontSize = 16;
            app.SAVEButton.Position = [69 12 202 27];
            app.SAVEButton.Text = 'SAVE';

            % Create PeaksUIAxes
            app.PeaksUIAxes = uiaxes(app.PeakFindingTab);
            xlabel(app.PeaksUIAxes, 'X')
            ylabel(app.PeaksUIAxes, 'Y')
            app.PeaksUIAxes.FontSize = 14;
            app.PeaksUIAxes.FontWeight = 'bold';
            app.PeaksUIAxes.GridLineStyle = '--';
            app.PeaksUIAxes.Box = 'on';
            app.PeaksUIAxes.LineWidth = 1;
            app.PeaksUIAxes.NextPlot = 'add';
            app.PeaksUIAxes.XGrid = 'on';
            app.PeaksUIAxes.YGrid = 'on';
            app.PeaksUIAxes.BackgroundColor = [1 1 1];
            app.PeaksUIAxes.Position = [424 33 712 691];
        end
    end

    methods (Access = public)

        % Construct app
        function app = DataAnalyser

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.DataAnalyser211UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.DataAnalyser211UIFigure)
        end
    end
end