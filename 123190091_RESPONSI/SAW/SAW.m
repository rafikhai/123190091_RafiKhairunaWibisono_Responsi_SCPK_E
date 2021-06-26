function varargout = SAW(varargin)
% SAW MATLAB code for SAW.fig
%      SAW, by itself, creates a new SAW or raises the existing
%      singleton*.
%
%      H = SAW returns the handle to a new SAW or the handle to
%      the existing singleton*.
%
%      SAW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAW.M with the given input arguments.
%
%      SAW('Property','Value',...) creates a new SAW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SAW_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SAW_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SAW

% Last Modified by GUIDE v2.5 26-Jun-2021 07:39:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SAW_OpeningFcn, ...
                   'gui_OutputFcn',  @SAW_OutputFcn, ...
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


% --- Executes just before SAW is made visible.
function SAW_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SAW (see VARARGIN)

% Choose default command line output for SAW
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SAW wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SAW_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in showdata.
function showdata_Callback(hObject, eventdata, handles)
% hObject    handle to showdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opts = detectImportOptions('DATA_RUMAH.xlsx');
opts.SelectedVariableNames = (1:7);
data = readmatrix('DATA_RUMAH.xlsx', opts);
set(handles.tabel1,'data',data,'visible','on'); %membaca file dan menampilkan pada tabel


% --- Executes on button press in proses.
function proses_Callback(hObject, eventdata, handles)
% hObject    handle to proses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opts = detectImportOptions('DATA_RUMAH.xlsx');
opts.SelectedVariableNames = (2:7);
data = readmatrix('DATA_RUMAH.xlsx', opts); %membaca file dataset
a=[0,1,1,1,1,1]; %%nilai atribut, dimana 0= atribut biaya &1= atribut keuntungan
b=[0.3,0.2,0.23,0.1,0.07,0.1]; % bobot untuk masing-masing kriteria
%tahapan 1. normalisasi matriks
[m n]=size (data); %matriks m x n dengan ukuran sebanyak variabel data 
mx=zeros (m,n); %membuat matriks X, yang merupakan matriks kosong
my=zeros (m,n); %membuat matriks Y, yang merupakan titik kosong
for i=1:n,
    if a(i)==1, %statement untuk kriteria dengan atribut keuntungan
        mx(:,i)=data(:,i)./max(data(:,i));
    else 
        mx(:,i)=min(data(:,i))./data(:,i);
    end;
end;

%tahapan kedua, proses perangkingan
for j=1:m,
    dnilai(j)= sum(b.*mx(j,:)) %proses perhitungan nilai   
end;

opts = detectImportOptions('DATA_RUMAH.xlsx');
opts.SelectedVariableNames = (1);
baru = readmatrix('DATA_RUMAH.xlsx', opts);
xlswrite('hasil_saw.xlsx', baru, 'Sheet1', 'A1'); %menulis data pada file kolom A1
dnilai=dnilai'; %merubah data hasil perhitungan dari horizontal ke vertikal matrix
xlswrite('hasil_saw.xlsx', dnilai, 'Sheet1', 'B1'); %menulis data pada file kolom B1

opts = detectImportOptions('hasil_saw.xlsx');
opts.SelectedVariableNames = (1:2);
data = readmatrix('hasil_saw.xlsx', opts); %membaca file

sortr=sortrows(data,2,'descend'); %mengurutkan data dari file dari kolom ke-2 dari terbesar ke terkecil
sortr=sortr(1:25,1:2); %memilih 25 data teratas
set(handles.tabel3,'data',sortr,'visible','on'); %menampilkan data yang telah diurutkan ke dalam tabel
