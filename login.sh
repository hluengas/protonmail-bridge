#!/usr/bin/expect

# Initialize pass
spawn gpg --generate-key --batch /proton/gpgparams
expect eof
spawn pass init pass-key
expect eof

if { $env(2FA_CODE) == "123456" } {
    # Login
    spawn /proton/proton-bridge --cli;
    expect ">>> "
    send "login\r"
    expect "Username:"
    send "$env(USERNAME)\r"
    expect "Password:"
    send "$env(PASSWORD)\r"
    expect ">>> "
    send "list\r"
    expect ">>> "
    send "exit\r"
    expect eof
} else {
    # Login
    spawn /proton/proton-bridge --cli;
    expect ">>> "
    send "login\r"
    expect "Username:"
    send "$env(USERNAME)\r"
    expect "Password:"
    send "$env(PASSWORD)\r"
    expect "Two factor code:"
    send "$env(2FA_CODE)\r"
    expect ">>> "
    send "list\r"
    expect ">>> "
    send "exit\r"
    expect eof
}