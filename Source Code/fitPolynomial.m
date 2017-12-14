classdef fitPolynomial < handle
    %	fitPolynomial : fit data with polynomial
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
    properties (SetAccess = private, GetAccess = public, SetObservable, GetObservable, AbortSet)
        m_initialData;          % initial data, belongs to Class "Data_2d"
        m_degree;               % degree of polynomial, between 2 and 8
        m_xaxis;                % initial x data
        m_yaxis;                % initial y data
        m_ymodel;               % fitted y data
        m_expression = ["f(x) = p1*x + p2";...
            "f(x) = p1*x^2 + p2*x + p3";...
            "f(x) = p1*x^3 + p2*x^2 + p3*x + p4";...
            "f(x) = p1*x^4 + p2*x^3 + p3*x^2 + p4*x + p5";...
            "f(x) = p1*x^5 + p2*x^4 + p3*x^3 + p4*x^2 + p5*x + p6";...
            "f(x) = p1*x^6 + p2*x^5 + p3*x^4 + p4*x^3 + p5*x^2 + p6*x + p7";...
            "f(x) = p1*x^7 + p2*x^6 + p3*x^5 + p4*x^4 + p5*x^3 + p6*x^2 + p7*x + p8";...
            "f(x) = p1*x^8 + p2*x^7 + p3*x^6 + p4*x^5 + p5*x^4 + p6*x^3 + p7*x^2 + p8*x + p9"
            ];
        m_coeffGuess;           % initial guess of coefficients
        m_coeff;                % coefficients
        m_coeffSigma;           % 95% confidence bounds for coefficients
        m_RES;                  % fitting residuals;
        m_SSE;                  % sum of squares due to error 
        m_SD;                   % standard deviation of SSE
        m_RSq;                  % R-Squared
        m_RMSE;                 % Rooted Mean Squared Error
        m_adjustedRSquared;     % degrees of freedom adjusted R-Square
        el_degree;              % event listener of degree (m_degree) changes
        el_initialguess;        % event listener of initialguess (m_coeffGuess) changes
    end
    
    events
        pop_error;
        fitting_complete;
    end
    
    methods
        % constructot
        function obj = fitPolynomial(initialData, degree)
            %FITPOLYNOMIAL Construct an instance of this class
            %   Detailed explanation goes here
            if (class(initialData)=='Data_2d')
                %-----------------------------------------------%
                obj.m_initialData = initialData;
                switch nargin
                    case 1
                        obj.m_degree = 2;
                    case 2
                        obj.m_degree = degree;
                    otherwise
                        error('Invalid fitting parameter');
                end
                %----------------------------------------------%
                obj.m_coeffGuess = ones([obj.m_degree,1]);
                obj.m_xaxis = obj.m_initialData.get_xaxis;
                obj.m_yaxis = obj.m_initialData.get_yaxis;
                obj.m_coeff = ones([obj.m_degree,1]);
                obj.m_coeffSigma = zeros(size(obj.m_coeffSigma));
                obj.m_SSE = 0;
                obj.m_RSq = 0;
                obj.m_adjustedRSquared = 0;
                %----------------------------------------------%
                obj = fitting(obj);
                %----------------------------------------------%
                obj.el_degree = addlistener(obj,'m_degree','PostSet',...
                @obj.fitting);     % listener to degree changes
                obj.el_initialguess = addlistener(obj,'m_coeffGuess','PostSet',...
                @obj.fitting);     % listener to degree changes
            
            else
                return;
            end
        end
        
        % set degree from outside
        function obj = set_degree(obj, degree)
            flag_validData = isnumeric(degree) &&...
                numel(degree) == 1 &&...
                ~isinf(degree) &&...
                ~isnan(degree) &&...
                degree >= 2 &&...
                degree <= 9;
            if (flag_validData)
                obj.m_degree = round(degree);
                obj.m_coeffGuess = ones([obj.m_degree,1]);
            else
                obj.m_degree = 2;
                str_error = 'Invalid fitting parameter.';
                notify(obj, 'pop_error', EventMessage(str_error));
            end
        end
        
        % set initial guess from outside
        function obj = set_initialguess(obj, initialguess)
            flag_validData = isnumeric(initialguess) &&...
                numel(initialguess) == obj.m_degree &&...
                sum(~isinf(initialguess)) == obj.m_degree &&...
                sum(~isnan(initialguess)) == obj.m_degree;
            if (flag_validData)
                obj.m_coeffGuess = initialguess;
            else
                obj.m_coeffGuess = ones([obj.m_degree,1]);
                str_error = 'Invalid fitting parameter.';
                notify(obj, 'pop_error', EventMessage(str_error));
            end
        end
        
        % get initial guess from outside
        function result = get_initialguess(obj)
            result = obj.m_coeffGuess;
        end
        
        % get xaxis (m_xaxis) from outside
        function result = get_xaxis(obj)
            result = obj.m_xaxis;
        end
       
        % get yaxis (m_yaxis) from outside
        function result = get_yaxis(obj)
            result = obj.m_yaxis;
        end
        
        % get fitted yaxis (m_xaxis) from outside
        function result = get_fitted_yaxis(obj)
            result = obj.m_ymodel;
        end
        
        % get residual (m_RES) from outside
        function result = get_residual(obj)
            result = obj.m_RES;
        end
        
        % get coefficient (m_coeff) from outside
        function result = get_coefficient(obj)
            result = obj.m_coeff;
        end
        
        % get goodness of fit from outside
        function result = get_gof(obj)
            result{1,1} =...
                sprintf('Fitting model : %d order polynomial\n',...
                obj.m_degree-1);
            result{2,1} =...
                sprintf('\t%s\n', obj.m_expression(obj.m_degree-1));
            result{3,1} =...
                sprintf('\nCoefficients (with 95%% confidence bounds):\n');
            for idx = 1 : 1 : length(obj.m_coeffSigma)
                result{3+idx,1} = sprintf('\tp%d =  %.4e  (±%.4e)\n',...
                    idx,obj.m_coeff(idx),obj.m_coeffSigma(idx));
            end
            result{end+1,1} = sprintf('\nGoodness of fit:\n');
            result{end+1,1} = sprintf('\tSSE : %.4e\n', obj.m_SSE);
            result{end+1,1} =...
                sprintf('\tR-square : %.4f\n', obj.m_RSq);
            result{end+1,1} =...
                sprintf('\tAdjusted R-square : %.4f\n', obj.m_adjustedRSquared);
            result{end+1,1} =...
                sprintf('\tRMSE : %.4e\n', obj.m_RMSE);
        end
        
        % get formula (m_expression) from outside
        function result = get_formula(obj)
            result = obj.m_expression(obj.m_degree-1);
        end
        
    end
    
    methods (Access = private)
        % function of polynomial, using Horner Algorithm
        function result = polynomial(obj, xaxis, coeff)
            nData = length(xaxis);
            degree = length(coeff);
            result = coeff(1) .* ones([nData,1]);
            for idx = 2 : 1 : degree
                result = result.*xaxis + coeff(idx);
            end
        end
        
        % getSumSq : compute sum of squre of residuals for fitting
        function result = getSumSq(obj,xaxis,yaxis,coeff)
            model_y = polynomial(obj, xaxis, coeff);
            result = sum((yaxis - model_y).^2);
        end
            
        % getRSq : compute R squared for fitting
        function result = getRSq(obj,xaxis,yaxis,coeff)
            SSE = getSumSq(obj,xaxis,yaxis,coeff);
            result = 1 - (SSE./sum((yaxis - mean(yaxis)).^2));
        end
        
        % getVar : compute standard deviation for data
        function result = getVar(obj,xaxis,yaxis,coeff)
            degree = length(coeff);
            nData = length(xaxis);
            model_y = polynomial(obj,xaxis,coeff);
            err = yaxis - model_y;
            result = (1./(nData-degree)) * sum((err-mean(err)).^2);
        end
        
        % getChiSq : compute Chi squared for fitting parameters
        function result = getChiSq(obj,xaxis,yaxis,coeff)
            model_y = polynomial(obj, xaxis, coeff);
            result = sum((yaxis-model_y).^2./(model_y).^2);
        end
        
        
        % fitting : fit data to polynomial and calculate goodness of fit
        function obj = fitting(obj,src,event)
            %--------------------------------------------%
            xaxis = obj.m_initialData.get_xaxis;
            yaxis = obj.m_initialData.get_yaxis;
            degree = obj.m_degree;
            initialGuess = obj.m_coeffGuess;
            %--------------------------------------------%
            opts = optimset('MaxFunEvals', 1E10, 'MaxIter', 1E7,...
                'TolFun', 1e-8, 'TolX', 1e-8,...
                'Display', 'final');
            [opt_coeff,~,exitFlag] =...
                fminsearch(@(coeff)getSumSq(obj,xaxis,yaxis,coeff), initialGuess, opts);
            %--------------------------------------------%
            if (exitFlag)
                obj.m_coeff = opt_coeff;
                obj.m_ymodel = polynomial(obj,xaxis,opt_coeff);
                obj.m_RES = obj.m_ymodel - obj.m_yaxis;
                obj.m_SSE = getSumSq(obj,xaxis,yaxis,opt_coeff);
                obj.m_SD = sqrt(getVar(obj,xaxis,yaxis,opt_coeff));
                obj.m_RSq = getRSq(obj,xaxis,yaxis,opt_coeff);
                adjustParam = length(xaxis) - degree;
                obj.m_RMSE = sqrt(obj.m_SSE./adjustParam);
                obj.m_adjustedRSquared = 1 - ((obj.m_SSE*(length(xaxis)-1))./(sum((yaxis - mean(yaxis)).^2)*adjustParam));
                obj.m_coeffSigma = getCoeffSigma(obj, xaxis, yaxis, opt_coeff);
                notify(obj, 'fitting_complete')
            else
                str_error = 'Fitting failed.';
                notify(obj, 'pop_error', EventMessage(str_error));
            end
            
        end
        
        % getCoeffSigma
        function result = getCoeffSigma(obj, xaxis, yaxis, coeff)
            result = zeros(size(coeff));
            chisq0 = getChiSq(obj,xaxis,yaxis,coeff);
            for idx = 1 : 1 : length(coeff)
                stepSize = 1e-3*abs(coeff(idx));
                % Calculate p + h and p - h
                pplush = coeff;
                pplush(idx) = pplush(idx) + stepSize;
                pminush = coeff;
                pminush(idx) = pminush(idx) - stepSize;
                % Compute second derivative
                chisqplush = getChiSq(obj,xaxis,yaxis,pplush);
                chisqminush = getChiSq(obj,xaxis,yaxis,pminush);
                d2chidp2 = (chisqplush - 2*chisq0 + chisqminush)/(stepSize^2);
                % Compute quadratic constants
                a = d2chidp2 / 2;
                b = -2 * a * coeff(idx);
                c = chisq0 - a*coeff(idx)^2 - b*coeff(idx);
                % Find the zeros of the quadratic equation
                % chiqs0+1 = a(p0+sigmap)^2 + b(p0+sigmap) + c
                result(idx) = (-b + sqrt(b^2 - 4*a*(c-chisq0-1)))/(2*a) - coeff(idx);
            end
            result = result.*2;
        end
        

        
    end
end

