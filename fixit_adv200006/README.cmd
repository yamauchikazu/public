Fix it for ADV200006 Vulnerability

ADV200006 | Type 1 Font Parsing Remote Code Execution Vulnerability
https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/adv200006

Windows 8.1/Server 2012 R2 以前の場合は、バッチ（fixit_adv200006.cmd）を 2 回実行すると確実。そうでないと DisableATMFD レジストリがちゃんと設定されないことがあるみたい。Undo バッチも同様。
