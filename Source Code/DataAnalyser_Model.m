classdef DataAnalyser_Model < handle
    %DATAANALYSER_CONTROLLER : the model part of DataAnalyser app (under MVC frame)
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
        inputData;          % instance of Data_2d, a container of initial data
        fittedData;         % instance of fitPolynomial
        findPeaks;          % instance of FindPeaks
        el_inputchanged;    % event listener, respond to 'data_updated' events in inputData
        el_peakFinding;
        el_curveFitting;
    end
    
    events
        peakFinding_complete;
        fitting_complete;
    end
    
    methods
        % constructor
        function obj = DataAnalyser_Model(xaxis, yaxis)
            %DATAANALYSER_MODEL Construct an instance of this class
            %   Detailed explanation goes here
            obj.inputData = Data_2d(xaxis, yaxis);
            obj.fittedData = fitPolynomial(obj.inputData,2);
            obj.findPeaks = FindPeaks(obj.inputData);
            obj.el_inputchanged = addlistener(obj.inputData,...
                'data_updated', @obj.renewData);
            obj.el_curveFitting = addlistener(obj.fittedData,...
                'fitting_complete',@obj.notifyTranser_fitted);
            obj.el_peakFinding = addlistener(obj.findPeaks,...
                'peakFinding_complete',@obj.notifyTranser_findPeaks);
        end
        
        % refit: renew data after xaxis or yaxis in inputData changed
        function obj = renewData(obj,src,event)
            disp('Data renewed')
            delete(obj.fittedData);
            delete(obj.findPeaks);
            delete(obj.el_peakFinding);
            delete(obj.el_curveFitting);
            obj.fittedData = fitPolynomial(obj.inputData,2);
            obj.findPeaks = FindPeaks(obj.inputData);
            obj.el_curveFitting = addlistener(obj.fittedData,...
                'fitting_complete',@obj.notifyTranser_fitted);
            obj.el_peakFinding = addlistener(obj.findPeaks,...
                'peakFinding_complete',@obj.notifyTranser_findPeaks);
        end
    end
    
    methods
        function notifyTranser_findPeaks(obj,src,event)
            notify(obj, 'peakFinding_complete')
        end
        
        function notifyTranser_fitted(obj,src,event)
            notify(obj, 'fitting_complete')
        end
    end
    
end

