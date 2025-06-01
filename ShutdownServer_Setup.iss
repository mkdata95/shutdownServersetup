[Setup]
AppName=PC 종료 서버 (ShutdownServer)
AppVersion=1.0
AppPublisher=PC Control Solutions
DefaultDirName={autopf}\ShutdownServer
DefaultGroupName=PC 종료 서버
AllowNoIcons=yes
OutputDir=.
OutputBaseFilename=ShutdownServer_Setup
SetupIconFile=
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin
DisableDirPage=yes
DisableProgramGroupPage=yes

[Languages]
Name: "korean"; MessagesFile: "compiler:Languages\Korean.isl"

[Files]
Source: "ShutdownServer.exe"; DestDir: "{app}"; Flags: ignoreversion

[Run]
; 방화벽 규칙 추가
Filename: "netsh"; Parameters: "advfirewall firewall add rule name=""ShutdownServer"" dir=in action=allow protocol=TCP localport=8081"; Flags: runhidden; Description: "방화벽에서 8081 포트 허용"

; ICMP 핑 허용 (IPv4)
Filename: "netsh"; Parameters: "advfirewall firewall add rule name=""Allow ICMP IPv4"" protocol=icmpv4:8,any dir=in action=allow"; Flags: runhidden; Description: "방화벽에서 ICMPv4 핑 허용"

; ICMP 핑 허용 (IPv6)  
Filename: "netsh"; Parameters: "advfirewall firewall add rule name=""Allow ICMP IPv6"" protocol=icmpv6:128,any dir=in action=allow"; Flags: runhidden; Description: "방화벽에서 ICMPv6 핑 허용"

; 작업 스케줄러에 등록 (UAC 없이 관리자 권한으로 실행)
Filename: "schtasks"; Parameters: "/create /tn ""ShutdownServer"" /tr ""\""{app}\ShutdownServer.exe\"""" /sc onlogon /rl highest /f"; Flags: runhidden; Description: "작업 스케줄러에 PC 종료 서버 등록"

; ShutdownServer 즉시 시작
Filename: "{app}\ShutdownServer.exe"; Description: "PC 종료 서버 시작"; Flags: postinstall runasoriginaluser nowait

[UninstallRun]
; 실행 중인 프로세스 종료
Filename: "taskkill"; Parameters: "/f /im ShutdownServer.exe"; Flags: runhidden

; 작업 스케줄러에서 제거
Filename: "schtasks"; Parameters: "/delete /tn ""ShutdownServer"" /f"; Flags: runhidden

; 방화벽 규칙 제거
Filename: "netsh"; Parameters: "advfirewall firewall delete rule name=""ShutdownServer"""; Flags: runhidden

; ICMP 방화벽 규칙 제거
Filename: "netsh"; Parameters: "advfirewall firewall delete rule name=""Allow ICMP IPv4"""; Flags: runhidden

Filename: "netsh"; Parameters: "advfirewall firewall delete rule name=""Allow ICMP IPv6"""; Flags: runhidden

[UninstallDelete]
; VBS 파일은 더 이상 사용하지 않으므로 삭제 항목에서 제거 