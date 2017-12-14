classdef FindPeaks < handle
    %	FINDPEAKS : find peak and doing decomposition
    %   Detailed explanation goes here
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
    
    properties(SetAccess = public, GetAccess = public, SetObservable, GetObservable, AbortSet)
        m_initialData;          % initial data, belongs to Class "Data_2d"
        m_peakNumber;           % total number of peaks
        m_peakIndex;            % index of peaks;
        m_peakLocation;         % xaxis of peaks;
        m_peakHeight;           % height of peaks;
        m_peakWidth;            % Full width at half maximum
        m_minPeakHeight;        % min peak height, threshold for peak finding
        m_minPeakDistance;      % min peak spacing, threshold for peak finding
        m_tolerance;            % tolerance for optimiztion in peak finding
    end
    
    events
        pop_error;
        peakFinding_complete;
    end
    
    methods
        % constructor
        function obj = FindPeaks(inputData)
            %FINDPEAKS Construct an instance of this class
            obj.m_initialData = inputData;
        end
        
        % get peaks location from outside
        function result = get_peakLocation(obj)
            result = obj.m_peakLocation;
        end
        
        % get peaks height from outside
        function result = get_peakHeight(obj)
            result = obj.m_peakHeight;
        end
        
        % get peaks width from outside
        function result = get_peakWidth(obj)
            result = obj.m_peakWidth;
        end
        
        % get peaks index from outside
        function result = get_peakIndex(obj)
            result = obj.m_peakIndex;
        end
        
        % set min peak height (m_minPeakHeight) from outside
        function obj = set_heightThreshold(obj, thre)
            if (isnumeric(thre) && numel(thre)==1)
                obj.m_minPeakHeight = thre;
            else
                obj.m_minPeakHeight = 1E6;
                str_error = 'Invalid threshold.';
                notify(obj, 'pop_error', EventMessage(str_error));
            end
        end
        
        % set min peak spacing (m_minPeakHeight) from outside
        function obj = set_spacingThreshold(obj, thre)
            if (isnumeric(thre) && numel(thre)==1)
                obj.m_minPeakDistance = thre;
            else
                obj.m_minPeakDistance = 1E6;
                str_error = 'Invalid threshold.';
                notify(obj, 'pop_error', EventMessage(str_error));
            end
        end
        
        % set min peak spacing (m_tolerance) from outside
        function obj = set_tolerance(obj, thre)
            if (isnumeric(thre) && numel(thre)==1)
                obj.m_tolerance = thre;
            else
                obj.m_tolerance = 1E-3;
                str_error = 'Invalid threshold.';
                notify(obj, 'pop_error', EventMessage(str_error));
            end
        end
        
        % do peak finding when called (callback of controller)
        function obj = doPeakFinding(obj)
            % initialization
            numPeaks = 0;
            numDataPoints = obj.m_initialData.get_length();
            xData = obj.m_initialData.get_xaxis();
            yData = obj.m_initialData.get_yaxis();
            dYData = obj.m_initialData.get_1orderDerivative();
            ddYData = obj.m_initialData.get_2orderDerivative();
            threHeight = obj.m_minPeakHeight;
            threSpacing = obj.m_minPeakDistance;
            tolerance = obj.m_tolerance;
            stepSize = mean(diff(xData));
            threPeakDistance_range = ceil(threSpacing./stepSize) + 1;
            autoScale = max(yData) ./ (max(dYData)*2);
            % calculation
            % critiera for peaks : derivative critiera
            idx_possible_peaks = find( autoScale.*abs(dYData()) < tolerance & ... % 1 order dev = 0
                ddYData() < 0 & ... % 2 order dev < 0
                yData() > threHeight);   % y value > min height
            % critiera for peaks : local maximum within the threshold of min peak spacing
            peaks = zeros([1,3]);
            for idx = 1 : 1 : length(idx_possible_peaks)
                if (idx_possible_peaks(idx)>threPeakDistance_range)
                    idx_forward = idx_possible_peaks(idx) - threPeakDistance_range;
                else
                    idx_forward = 1;
                end
                
                if (idx_possible_peaks(idx) + threPeakDistance_range - 1 > numDataPoints)
                    idx_backward = length(xData);
                else
                    idx_backward = idx_possible_peaks(idx) + threPeakDistance_range;
                end
                %     select the maximum peak value with threPeakDistance
                if (numPeaks >= 1)
                    [temp_peaks_val, temp_peaks_idx] = max(yData(idx_forward:idx_backward));
                    temp_peaks_idx = idx_forward + temp_peaks_idx - 1;
                    if (temp_peaks_idx - peaks(numPeaks,1) > threPeakDistance_range)
                        numPeaks = numPeaks + 1;
                        peaks(numPeaks,1) = temp_peaks_idx;
                        peaks(numPeaks,3) = temp_peaks_val;
                        peaks(numPeaks,2) = xData(temp_peaks_idx);
                    else
                        if (temp_peaks_val > peaks(numPeaks,3))
                            peaks(numPeaks,1) = temp_peaks_idx;
                            peaks(numPeaks,3) = temp_peaks_val;
                            peaks(numPeaks,2) = xData(temp_peaks_idx);
                        end
                    end
                else
                    numPeaks = numPeaks + 1;
                    [peaks(numPeaks,3), peaks(numPeaks,1)] = max(yData(idx_forward:idx_backward));
                    peaks(numPeaks,1) = peaks(numPeaks,1) + idx_forward - 1;
                    peaks(numPeaks,2) = xData(peaks(numPeaks,1));
                end
            end
            obj.m_peakNumber = numPeaks;
            obj.m_peakIndex = peaks(:,1);
            obj.m_peakLocation = peaks(:,2);
            obj.m_peakHeight = peaks(:,3);
            obj.m_peakWidth = zeros([numPeaks,1]);
            [~,~,obj.m_peakWidth] = findpeaks(yData,xData,...
                'NPeaks', numPeaks,...
                'MinPeakDistance', threSpacing,...
                'MinPeakHeight', threHeight,...
                'WidthReference', 'halfheight');
            notify(obj, 'peakFinding_complete')
        end
    end
end

