classdef Data_2d < handle
    %   DATA_2D : A class of 2d spectrum data.
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
    
    properties (SetAccess = private, GetAccess = public, SetObservable, GetObservable, AbortSet)
        % public properties
        m_units_x;              % units of xaxis
        m_units_y;              % units of yaxis
        m_name_x;               % name of xaxis
        m_name_y;               % name of yaxis
    end
    
    properties (SetAccess = private, GetAccess = private, SetObservable, GetObservable, AbortSet)
        % private properties
        m_xaxis;                % initial xaxis data
        m_yaxis;                % initial yaxia data
        m_dy;                   % 1 order derivative for yaxis
        m_ddy;                  % 2 order derivative for yaxis
        m_inty;                 % integration of yaxis
        m_data_points;          % number of data points
        el_xaxis;               % event listener of xaxis (m_xaxis) changes
        el_yaxis;               % event listener of yaxis (m_yaxis) changes
    end
    
    %---------------------------------------------------------------------%
    
    events
        pop_error;                      % 
        pop_warning;                    %
        data_updated;                   % notified if method 'update' is called 
    end
    
    
    %---------------------------------------------------------------------%
    
    methods
        
        % constructor
        function obj = Data_2d(xdata, ydata)    
            %   DATA_2D constructor
            %   xdata: 1d column vector
            %   ydata: 1d column vector
            %-----------------------------------------%
            % plant flag to check input data structure
            % check vector size and data type
            xdata = isValidData(obj, xdata, 'increasing')
            ydata = isValidData(obj, ydata);
            [xdata, ydata] = isSameLength(obj, xdata, ydata);
            %-----------------------------------------%
            % set xaxis and yaxis
            obj.m_xaxis = xdata;
            obj.m_yaxis = ydata;
            %-----------------------------------------%
            % initialize other private properties
            obj.m_data_points = length(obj.m_xaxis);
            obj.m_name_x = 'X';
            obj.m_name_y = 'Y';
            obj.m_units_x = [];
            obj.m_units_y = [];
            %-----------------------------------------%
            % data processing
            obj = numDerivative14(obj);
            obj = numDerivative24(obj);
            obj = numIntegrate(obj);
            %-----------------------------------------%
            % add events listeners of value changes
            obj.el_xaxis = addlistener(obj,'m_xaxis','PostSet',...
                @(src,event)obj.update(obj,src,event));     % listener to xaxis changes
            obj.el_yaxis = addlistener(obj,'m_yaxis','PostSet',...
                @(src,event)obj.update(obj,src,event));     % listener to yaxis changes
        end
        
        % get xaxis(m_xaxis) from out side
        function result = get_xaxis(obj)
        % get xaxis(m_xaxis) data from outside
            result = obj.m_xaxis;
        end
       
        % set xaxis(m_xaxis) from out side
        function obj = set_xaxis(obj, xdata)
            % determine if data is column vector
            % set xaxis(m_xaxis) data from outside 
            xdata = isValidData(obj, xdata, 'increasing');
            obj.m_xaxis = xdata;
        end
        
        % get yaxis(m_yaxis) data from outside
        function result = get_yaxis(obj)
            result = obj.m_yaxis;
        end
        
        % set yaxis(m_yaxis) data from outside
        function obj = set_yaxis(obj, ydata)
        % determine if data is column vector
        % set xaxis(m_xaxis) data from outside 
            ydata = isValidData(obj, ydata);
            obj.m_yaxis = ydata;
        end  
        
        
        % get 1 order numerical derivative data from outside
        function result = get_1orderDerivative(obj)
        % get 2 order numerical derivative (m_inty) data from outside
            result = obj.m_dy;
        end
        
        % get 2 order numerical derivative data from outside
        function result = get_2orderDerivative(obj)
        % get 2 order numerical derivative data from outside
            result = obj.m_ddy;
        end
        
        % get numerical integration data from outside
        function result = get_integration(obj)
        % get numerical integration (obj.m_inty) data from outside
            result = obj.m_inty;
        end
        
        % set xlabel(m_name_x) from outside
        function obj = set_xlabel(obj, name_x)
        % determine if input is char or string
        % set xlabel(m_name_x) from outside
            if (isstring(name_x) || ischar(name_x))
                obj.m_name_x = name_x;
            else
                str_error = 'Invalid data type.';
                notify(obj, 'pop_error', EventMessage(str_error));
                error(str_error);
            end
        end
        
        % set xlabel(m_name_x) from outside
        function obj = set_ylabel(obj, name_y)
        % determine if input is string or char
        % set ylabel(m_name_y) from outside
            if (isstring(name_y) || ischar(name_y))
                obj.m_name_y = name_y;
            else
                str_error = 'Invalid data type.';
                notify(obj, 'pop_error', EventMessage(str_error));
                error(str_error);
            end
        end
        
        % set units of xaxis(m_units_x) from outside 
        function obj = set_xunits(obj, xunits)
        % determine if input is char or string
        % set units of xaxis(m_units_x) from outside
            if (isstring(xunits) || ischar(xunits))
                obj.m_units_x = xunits;
            else
                str_error = 'Invalid data type.';
                notify(obj, 'pop_error', EventMessage(str_error));
                error(str_error);
            end
        end
        
        % set units for yaxis(m_name_y) from outside
        function obj = set_yunits(obj, yunits)
        % determine if input is char or sting
        % set units for yaxis(m_name_y) from outside
            if (isstring(yunits) || ischar(yunits))
                obj.m_units_y = yunits;
            else
                str_error = 'Invalid data type.';
                notify(obj, 'pop_error', EventMessage(str_error));
                error(str_error);
            end
        end
        
        % get xlabel (m_name_x) from outside
        function result = get_xlabel(obj)
            result = obj.m_name_x;
        end
        
        % get ylabel (m_name_y) from outside
        function result = get_ylabel(obj)
            result = obj.m_name_y;
        end
        
        % get x units (m_units_x) from outside
        function result = get_xunits(obj)
            result = obj.m_units_x;
        end
        
        % get y units (m_units_y) from outside
        function result = get_yunits(obj)
            result = obj.m_units_y;
        end
        
        %
        function delete(obj)
            delete(obj.el_xaxis);
            delete(obj.el_yaxis);
        end
        
    end
    
    %---------------------------------------------------------------------%
    
    methods (Access = public)
        
        % calculate 1 order numerical derivative with 4 order uncertainty
        function obj = numDerivative14(obj)
            %---------------------------------------------------%
            % Basic input data processing
            xdata = obj.m_xaxis;
            ydata = obj.m_yaxis;
            [xdata, ydata, flag_Samelength] = isSameLength(obj, xdata, ydata);
            if (flag_Samelength)
                dh = mean(diff(xdata));
                nData = length(xdata);
                %---------------------------------------------------%
                % First Order Direct Numerical Derivative Functions
                centralFiniteDiff1 = @(y) (1*y(1) - 8*y(2) + 8*y(4) -1*y(5)) ./ (12.*dh);
                forwardFiniteDiff1 = @(y) (-25*y(1) + 48*y(2) - 36*y(3) + 16*y(4) - 3*y(5)) ./ (12.*dh);
                backwardFiniteDiff1 = @(y) (3*y(1) - 16*y(2) + 36*y(3) - 48*y(4) + 25*y(5)) ./ (12.*dh);
                %---------------------------------------------------%
                % Derivatie Calculation
                dy = zeros(nData,1);
                for idx = 1 : 1 : nData
                    if (idx>=3 && idx<=(nData-2))
                        dy(idx) = centralFiniteDiff1(ydata(idx-2 : idx+2));
                    elseif (idx<=2)
                        dy(idx) = forwardFiniteDiff1(ydata(idx : idx+4));
                    elseif (idx>=(nData-2))
                        dy(idx) = backwardFiniteDiff1(ydata(idx-4 : idx));
                    else
                        str_error = 'Index problem happened when calculating numerical differentiation.';
                        notify(obj, 'pop_error', EventMessage(str_error));
                        error(str_error);
                    end
                end
                obj.m_dy = dy;
            else
                obj.m_dy = [];
            end
            %---------------------------------------------------%
        end
        
        % calculate 2 order numerical derivative with 4 order uncertainty
        function obj = numDerivative24(obj)
            %---------------------------------------------------%
            % Basic input data processing
            xdata = obj.m_xaxis;
            ydata = obj.m_yaxis;
            [xdata, ydata, flag_Samelength] = isSameLength(obj, xdata, ydata);
            %---------------------------------------------------%
            if (flag_Samelength)
                dh = mean(diff(xdata));
                nData = length(xdata);
                %---------------------------------------------------%
                % First Order Direct Numerical Derivative Functions
                centralFiniteDiff2 = @(y) (-1*y(1) + 16*y(2) - 30*y(3) + 16*y(4) - 1*y(5))./ (12.*dh.^2);
                forwardFiniteDiff2 = @(y) (35*y(1) - 104*y(2) + 114*y(3) - 56*y(4) + 11*y(5))./ (12.*dh.^2);
                backwardFiniteDiff2 = @(y) (11*y(1) - 56*y(2) + 114*y(3) - 104*y(4) + 35*y(5))./ (12.*dh.^2);
                %---------------------------------------------------%
                % Derivatie Calculation
                ddy = zeros([nData,1]);
                for idx = 1 : 1 : nData
                    if (idx>=3 && idx<=(nData-2))
                        ddy(idx)= centralFiniteDiff2(ydata(idx-2 : idx+2));
                    elseif (idx<=2)
                        ddy(idx)= forwardFiniteDiff2(ydata(idx : idx+4));
                    elseif (idx>=(nData-2))
                        ddy(idx)= backwardFiniteDiff2(ydata(idx-4 : idx));
                    else
                        str_error = 'Index problem happened when calculating numerical differentiation.';
                        notify(obj, 'pop_error', EventMessage(str_error));
                        error(str_error);
                    end
                end
                obj.m_ddy = ddy;
            else
                obj.m_ddy = [];
            end
            %---------------------------------------------------%
        end
        
        % calculate numerical integration using trapezoidal method
        function obj = numIntegrate(obj)
            %---------------------------------------------------%
            % Basic input data processing
            xdata = obj.m_xaxis;
            ydata = obj.m_yaxis;
            [xdata, ydata, flag_Samelength] = isSameLength(obj, xdata, ydata);
            if (flag_Samelength)
                int_y = cumtrapz(xdata, ydata);
                obj.m_inty = int_y;
            else
                obj.m_inty = [];
            end
            %---------------------------------------------------%
        end
        
    end
    
    %---------------------------------------------------------------------%
    
    methods (Access = private)
        
        % exaim if input data is valid
        function [output_data, exitFlag] = isValidData(obj, input_data, str_increasing)
        % isValidData: exaim if input data is valid
        % valid data type: nonempty real numeric column & nonnan
        % return input data if it is valid, two exceptions
        % exp 1: if it's row vector, transpose it and examin again
        % exp 2: if it has nan, delete it and examin again
            %---------------------------------------------------%
            exitFlag = logical(false);
            %---------------------------------------------------%
            switch nargin
                case 2
                    flag_isIncreasing = logical(false);
                    str_increasing = 'none';
                case 3
                    flag_isIncreasing = strcmp(str_increasing, 'increasing');
                    if flag_isIncreasing
                        str_increasing = 'increasing';
                    else
                        str_increasing = 'none';
                    end
            end
            %---------------------------------------------------%
            try
                if flag_isIncreasing
                    validateattributes(input_data, {'numeric'},...
                        {'nonempty', 'column', 'real', 'nonnan', 'finite', 'increasing'})
                else
                    validateattributes(input_data, {'numeric'},...
                        {'nonempty', 'column', 'real', 'nonnan', 'finite'})
                end
                output_data = input_data;
                exitFlag = logical(true);
            catch ME
                switch ME.identifier
                    case 'MATLAB:expectedNonNaN'
                        output_data = input_data(~any(isnan(input_data),2));
                        str_warning = 'Invalid data type: Nan have been deleted.';
                        notify(obj, 'pop_warning', EventMessage(str_warning));
                        warning(str_warning);
                        output_data = isValidData(obj, output_data, str_increasing);
                    case 'MATLAB:expectedFinite'
                        output_data = input_data(~any(isinf(input_data),2));
                        str_warning = 'Invalid data type: Nan have been deleted.';
                        notify(obj, 'pop_warning', EventMessage(str_warning));
                        warning(str_warning);
                        output_data = isValidData(obj, output_data, str_increasing);
                    case 'MATLAB:expectedColumn'
                        output_data = input_data.';
                        str_warning = 'Invalid data type: row vector has been transposed to column vector.';
                        notify(obj, 'pop_warning', EventMessage(str_warning));
                        warning(str_warning);
                        output_data = isValidData(obj, output_data, str_increasing);
                    otherwise
                        output_data = [];
                        rethrow(ME);
                end
            end
            %---------------------------------------------------%
        end
        
        % examine if xaxis and yaxis are in same length
        function [x_output, y_output, exitFlag] = isSameLength(obj, x_input, y_input)
            % if it is, return input x and y
            % else, output warning and return empty array
            if (size(x_input) == size(y_input))
                x_output = x_input;
                y_output = y_input;
                exitFlag = logical(true);
            else
                x_output = [];
                y_output = [];
                exitFlag = logical(false);
                %str_error = 'Invalid data size.';
                %notify(obj, 'pop_error', EventMessage(str_error));
                %error(str_error);
            end
        end
        
    end
    
    %---------------------------------------------------------------------%

    methods (Static)
        % call back for upadte info
        function update(obj,src,evnt)
            switch src.Name
                case {'m_xaxis','m_yaxis'}
                    [~, ~, flag_sameLength] = isSameLength(obj, obj.m_xaxis, obj.m_yaxis);
                    if(flag_sameLength)
                        obj.m_data_points = length(obj.m_xaxis);
                        obj = numDerivative14(obj);
                        obj = numDerivative24(obj);
                        obj = numIntegrate(obj);
                        notify(obj, 'data_updated');
                    end
                otherwise
                    str_error = 'Update failed: Invalid updated case';
                    notify(obj, 'pop_error', EventMessage(str_error));
                    error(str_error);
            end
        end
        
    end
    
end

