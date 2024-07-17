function [P E DP N] = ParameterRead(filename)
%% Experiment
[XLSnum XLStxt XLSraw]=xlsread(filename,'Experiment');
P.Info=XLSraw(1:10,1:2);
N.T=cell2mat(XLSraw(6,2));
N.O=cell2mat(XLSraw(7,2));
N.E=cell2mat(XLSraw(8,2));
N.C=cell2mat(XLSraw(9,2));
N.Z=cell2mat(XLSraw(10,2));

%% Subject
[XLSnum XLStxt XLSraw]=xlsread(filename,'Subject');
P.Subject=XLSraw(1:12,1:2);

%% Traces
[XLSnum XLStxt XLSraw]=xlsread(filename,'Traces');
E.Trace.Name=XLSraw(2:N.T+1,2);
E.Trace.Flow=cell2mat(XLSraw(2:N.T+1,3));

%% Odors
[XLSnum XLStxt XLSraw]=xlsread(filename,'Odors');
E.Odor.Name=XLSraw(2:N.O+1,2);
E.Odor.Group=XLSraw(2:N.O+1,3);
E.Odor.Abr=XLSraw(2:N.O+1,4);
E.Odor.Label=XLSraw(2:N.O+1,5);
if size(XLSraw,2)>=6 % for the extra cas number column
    E.Odor.CasNumber=XLSraw(2:N.O+1,6);
end

%% Concentrations
[XLSnum XLStxt XLSraw]=xlsread(filename,'Concentrations');
E.Conc.Vial=cell2mat(XLSraw(2:N.C+1,2));

%% Events
[XLSnum XLStxt XLSraw]=xlsread(filename,'Events');
E.Event.Log=cell2mat(XLSraw(2:N.E+1,1:7));
E.Event.Condition=XLSraw(2:N.E+1,8:9);

%% Zones
[XLSnum XLStxt XLSraw]=xlsread(filename,'Zones');
E.Zone.Name=XLSraw(2:N.Z+1,2);
E.Zone.Duration=cell2mat(XLSraw(2:N.Z+1,3:4));

%% Process
[XLSnum XLStxt XLSraw]=xlsread(filename,'Process');
DP.D=cell2mat(XLSraw(1:10,2));

%% Imaging
[XLSnum XLStxt XLSraw]=xlsread(filename,'Imaging');
P.Image=XLSraw(1:8,2);

%% ROI
[XLSnum XLStxt XLSraw]=xlsread(filename,'ROI');
P.ROI=XLSraw(1:5,2);
end
