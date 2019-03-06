:: Basic additional Chrome Settings
REG ADD "HKLM\SOFTWARE\WOW6432Node\Policies\Google\Chrome" /v DefaultBrowserSettingEnabled /d 0 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\WOW6432Node\Policies\Google\Chrome" /v DefaultPopupsSetting /d 1 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\WOW6432Node\Policies\Google\Chrome" /v DefaultCookiesSetting /d 4 /t REG_DWORD /f
