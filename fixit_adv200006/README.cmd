Fix it for ADV200006 Vulnerability

ADV200006 | Type 1 Font Parsing Remote Code Execution Vulnerability
https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/adv200006

<s>Windows 8.1/Server 2012 R2 以前の場合は、回避策適用バッチ（fixit_adv200006.cmd）を 2 回実行すると確実。
そうしないと DisableATMFD レジストリがちゃんと設定されないことがあるみたい。回避策解除のための Undo バッチ（undofixit_...）も同様。</s>
2020/3/26 JST fix bug
