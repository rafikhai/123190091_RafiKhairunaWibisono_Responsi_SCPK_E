function varargout = WP(varargin)
% WP MATLAB code for WP.fig
%      WP, by itself, creates a new WP or raises the existing
%      singleton*.
%
%      H = WP returns the handle to a new WP or the handle to
%      the existing singleton*.
%
%      WP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WP.M with the given input arguments.
%
%      WP('Property','Value',...) creates a new WP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WP

% Last Modified by GUIDE v2.5 26-Jun-2021 06:23:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WP_OpeningFcn, ...
                   'gui_OutputFcn',  @WP_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before WP is made visible.
function WP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WP (see VARARGIN)

% Choose default command line output for WP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Show Data.
function showdata_Callback(hObject, eventdata, handles)
% hObject    handle to Show Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opts = detectImportOptions('Real_estate.xlsx');
opts.SelectedVariableNames = (1:5);
data = readmatrix('Real_estate.xlsx', opts);
set(handles.tabel1,'data',data,'visible','on'); %membaca file dan menampilkan pada tabel


% --- Executes on button press in proses.
function proses_Callback(hObject, eventdata, handles)
% hObject    handle to proses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opts = detectImportOptions('Real_estate.xlsx');
opts.SelectedVariableNames = (2:5);
data = readmatrix('Real_estate.xlsx', opts); %membaca file dataset
a=[0,0,1,0]; %nilai atribut, dimana 0 = atribut biaya dan 1 atribut keuntungan
b=[3,5,4,1]; %%Nilai bobot tiap kriteria (1= sangat buruk, 2=buruk, 3= cukup, 4= tinggi, 5= sangat tinggi) 

%tahapan pertama, perbaikan bobot
[m n]=size (data); %inisialisasi ukuran data
b=b./sum(b); %membagi bobot per kriteria dengan jumlah total seluruh bobot

%tahapan kedua, melakukan perhitungan vektor(S) per baris (alternatif)
for i=1:n,
    if a(i)==0, b(i)=-1*b(i);
    end;
end;
for j=1:m,
    S(j)=prod(data(j,:).^b);
end;

opts = detectImportOptions('Real_estate.xlsx');
opts.SelectedVariableNames = (1);
new = readmatrix('Real_estate.xlsx', opts);
xlswrite('hasil_wp.xlsx', new, 'Sheet1', 'A1'); %menulis data pada file kolom A1
S=S'; %rubah data hasil perhitungan dari horizontal ke vertikal matrix
xlswrite('hasil_wp.xlsx', S, 'Sheet1', 'B1'); %menulis data pada file kolom B1

opts = detectImportOptions('hasil_wp.xlsx');
opts.SelectedVariableNames = (1:2);
data = readmatrix('hasil_wp.xlsx', opts); %membaca file

X=sortrows(data,2,'descend'); %urutkan data dari file dari kolom ke-2 dari terbesar ke tekecil
set(handles.tabel2,'data',X,'visible','on'); %tampilkan data yang telah diurutkan ke dalam tabel
