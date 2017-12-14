classdef DataAnalyser_Controller < handle
    %DATAANALYSER_CONTROLLER : the controller part of DataAnalyser app (under MVC frame)
    %
    %   Copyright (C) 2017  Wenjie Liao
    %
    %   This program is free software: you can redistribute it and/or modify
    %   it under the terms of the GNU General Public License as published by
    %   the Free Software Foundation, either version 3 of the License, or
    %   (at your option) any later version.
    %
    %   This program is distributed in the hope that it will be useful,
    %   but WITHOUT ANY WARRANTY; without even the implied warranty of
    %   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    %   GNU General Public License for more details.
    %
    %   You should have received a copy of the GNU General Public License
    %   along with this program.  If not, see <http://www.gnu.org/licenses/>.
    %---------------------------------------------------------------------%
    
    properties
        viewObj;
        modelObj;
    end
    
    methods
        % constructor
        function obj = DataAnalyser_Controller(view, model)
            %DATAANALYSER_CONTROLLER Construct an instance of this class
            obj.viewObj = view;
            obj.modelObj = model;
        end
        
        % callback function of ImportDataButton
        function callback_ImportDataButton(obj, src, event)
            [fileName,pathName,filterIndex] = uigetfile({'*.csv';'*.txt'},'Import Data');
            if (filterIndex)
                filePath = strcat(pathName, fileName);
                initialData = load(filePath);
                set_xaxis(obj.modelObj.inputData, initialData(:,1));
                set_yaxis(obj.modelObj.inputData, initialData(:,2));
            end
        end
        
        % callback function of NameEditField;
        function callback_XNameEditField(obj, src, event)
            xName = src.Value;
            set_xlabel(obj.modelObj.inputData, xName);
        end
        
        % callback funtion of XUnitsEditField
        function callback_XUnitsEditField(obj, src, event)
            xUnits = src.Value;
            set_xunits(obj.modelObj.inputData, xUnits);
        end
        
        % callback function of NameEditField;
        function callback_YNameEditField(obj, src, event)
            yName = src.Value;
            set_ylabel(obj.modelObj.inputData, yName);
        end
        
        % callback funtion of XUnitsEditField
        function callback_YUnitsEditField(obj, src, event)
            yUnits = src.Value;
            set_yunits(obj.modelObj.inputData, yUnits);
        end
        
        % callback function of DegreeDropDown
        function callback_DegreeDropDown(obj, src, event)
            degree = str2num(src.Value);
            obj.modelObj.fittedData.set_degree(degree);
        end
        
        % callbacl function of InitialGuessButtonPushed
        function callback_InitialGuessButtonPushed(obj, initialguess)
            set_initialguess(obj.modelObj.fittedData, initialguess);
        end
        
        % callback function of MinimumPeakHeightSpinner
        function callback_MinimumPeakHeightSpinner(obj, src, event)
            thre = src.Value;
            set_heightThreshold(obj.modelObj.findPeaks,thre);
        end
        
        % callback function of MinimumPeakSpacingSpinner
        function callback_MinimumPeakSpacingSpinner(obj, src, event)
            thre = src.Value;
            set_spacingThreshold(obj.modelObj.findPeaks,thre);
        end
        
        % callback function of ToleranceEditField
        function callback_ToleranceEditField(obj, src, event)
            tolerance = src.Value;
            set_tolerance(obj.modelObj.findPeaks,tolerance);
        end
        
        % callback function of FINDPEAKSButton
        function callback_FINDPEAKSButton(obj, src, event)
            doPeakFinding(obj.modelObj.findPeaks);
            disp('Button')
            ans = obj.modelObj.findPeaks
        end
    end
end

