require ["vnd.dovecot.pipe", "copy", "imapsieve", "environment", "variables"];

if environment :matches "imap.mailbox" "*" {
  set "mailbox" "${1}";
}


if anyof (
  string "${mailbox}" "Trash",
  string "${mailbox}" "Deleted Messages",
  string "${mailbox}" "Elementy usuni&ARk-te"
) {
  stop;
}


if environment :matches "imap.user" "*" {
  set "username" "${1}";
}

pipe :copy "rspamd-learn-ham.sh" [ "${username}" ];
