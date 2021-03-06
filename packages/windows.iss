; This script need to use a special Inno Setup version located here : http://jrsoftware.org/isdl.php#qsp

[CustomMessages]
QWBFS_NAME=QWBFS Manager
QWBFS_COPYRIGHTS=2010-2012 Filipe AZEVEDO
QWBFS_URL=http://code.google.com/p/qwbfs/
QWBFS_ISSUES_URL=http://code.google.com/p/qwbfs/issues/list

#define QWBFS_VERSION GetEnv("VERSION")
#define QWBFS_VERSION_STR GetEnv("VERSION_STR")
#define QWBFS_SETUP_NAME "setup-qwbfsmanager-" +QWBFS_VERSION_STR +"-win32"
#define QT_PATH "Z:\" +GetEnv("CROSS_WIN32_QT_PATH")
#define DLLS_PATH "Z:\" +GetEnv("DLLS_PATH")

[Setup]
SourceDir=..\bin
OutputDir=..\packages\releases
OutputBaseFilename={#QWBFS_SETUP_NAME}
VersionInfoVersion={#QWBFS_VERSION}
VersionInfoCompany=Filipe AZEVEDO
VersionInfoDescription=Free, Fast and Powerfull cross platform Wii Backup File System Manager
VersionInfoTextVersion={#QWBFS_VERSION}
VersionInfoCopyright={cm:QWBFS_COPYRIGHTS}
AppCopyright={cm:QWBFS_COPYRIGHTS}
AppName={cm:QWBFS_NAME}
AppVerName={cm:QWBFS_NAME} {#QWBFS_VERSION}
InfoAfterFile=..\GPL-2
InfoBeforeFile=..\GPL-2
LicenseFile=..\GPL-2
ChangesAssociations=true
PrivilegesRequired=none
DefaultDirName={pf}\{cm:QWBFS_NAME}
EnableDirDoesntExistWarning=false
AllowNoIcons=true
DefaultGroupName={cm:QWBFS_NAME}
AlwaysUsePersonalGroup=true
;SetupIconFile=..\qwbfs\resources\qwbfsmanager.ico
AppPublisher={cm:QWBFS_COPYRIGHTS}
AppPublisherURL={cm:QWBFS_URL}
AppSupportURL={cm:QWBFS_ISSUES_URL}
AppVersion={#QWBFS_VERSION}
AppComments=Thanks using {cm:QWBFS_NAME}
AppContact={cm:QWBFS_ISSUES_URL}
UninstallDisplayName={cm:QWBFS_NAME}
ShowLanguageDialog=yes
UsePreviousLanguage=no

[_ISTool]
UseAbsolutePaths=false

[Files]
; Fresh framework related
Source: ..\fresh\translations\*.qm; DestDir: {app}\translations; Flags: promptifolder
; QWBFS Manager related files
Source: qwbfsmanager.exe; DestDir: {app}; Flags: promptifolder
Source: ..\packages\qt_windows.conf; DestDir: {app}; DestName: qt.conf; Flags: promptifolder
Source: ..\GPL-2; DestDir: {app}; Flags: promptifolder
Source: ..\translations\*.qm; DestDir: {app}\translations; Flags: promptifolder
; Qt related files
Source: {#QT_PATH}\bin\QtCore4.dll; DestDir: {app}; Flags: promptifolder
Source: {#QT_PATH}\bin\QtGui4.dll; DestDir: {app}; Flags: promptifolder
Source: {#QT_PATH}\bin\QtXml4.dll; DestDir: {app}; Flags: promptifolder
Source: {#QT_PATH}\bin\QtNetwork4.dll; DestDir: {app}; Flags: promptifolder
Source: {#QT_PATH}\plugins\accessible\*.dll; DestDir: {app}\qt\plugins\accessible; Flags: promptifolder; Excludes: *d4.dll
Source: {#QT_PATH}\plugins\codecs\*.dll; DestDir: {app}\qt\plugins\codecs; Flags: promptifolder; Excludes: *d4.dll
Source: {#QT_PATH}\plugins\graphicssystems\*.dll; DestDir: {app}\qt\plugins\graphicssystems; Flags: promptifolder; Excludes: *d4.dll
Source: {#QT_PATH}\plugins\imageformats\*.dll; DestDir: {app}\qt\plugins\imageformats; Flags: promptifolder; Excludes: *d4.dll
Source: {#QT_PATH}\translations\qt*.qm; DestDir: {app}\qt\translations; Flags: promptifolder recursesubdirs; Excludes: qt_help*.qm,qtconfig*.qm
; Dependencies related files
Source: {#QT_PATH}\bin\mingwm10.dll; DestDir: {app}; Flags: promptifolder
Source: {#QT_PATH}\bin\libgcc_s_dw2-1.dll; DestDir: {app}; Flags: promptifolder skipifsourcedoesntexist
Source: {#QT_PATH}\bin\libstdc++-6.dll; DestDir: {app}; Flags: promptifolder skipifsourcedoesntexist
Source: {#DLLS_PATH}\libeay32.dll; DestDir: {app}; Flags: promptifolder
Source: {#DLLS_PATH}\libssl32.dll; DestDir: {app}; Flags: promptifolder
Source: {#DLLS_PATH}\ssleay32.dll; DestDir: {app}; Flags: promptifolder

[Icons]
Name: {group}\{cm:QWBFS_NAME}; Filename: {app}\qwbfsmanager.exe; WorkingDir: {app}; IconFilename: {app}\qwbfsmanager.exe; IconIndex: 0
Name: {userdesktop}\{cm:QWBFS_NAME}; Filename: {app}\qwbfsmanager.exe; WorkingDir: {app}; IconFilename: {app}\qwbfsmanager.exe; IconIndex: 0
Name: {group}\Home Page; Filename: {app}\Home Page.url; WorkingDir: {app}
Name: {group}\Tracker; Filename: {app}\Tracker.url; WorkingDir: {app}

[INI]
Filename: {app}\Home Page.url; Section: InternetShortcut; Key: URL; String: {cm:QWBFS_URL}; Flags: createkeyifdoesntexist uninsdeleteentry uninsdeletesectionifempty; Components: 
Filename: {app}\Tracker.url; Section: InternetShortcut; Key: URL; String: {cm:QWBFS_ISSUES_URL}; Flags: createkeyifdoesntexist uninsdeleteentry uninsdeletesectionifempty

[UninstallDelete]
Name: {app}\Home Page.url; Type: files
Name: {app}\Tracker.url; Type: files
Name: {app}\*.ini; Type: files
Name: {app}; Type: dirifempty
[Run]
Filename: {app}\qwbfsmanager.exe; WorkingDir: {app}; Flags: postinstall skipifsilent; Description: {cm:QWBFS_NAME}
