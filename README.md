# GuildAnnouncer

Automatically handles guild announce messages. [Wow 2.4.3]

## Usage

Configuration can only be done by means of slash commands:

<dl>
<dt>/gann message your_message_here</dt>
<dd>Sets guild recruitment message.</dd>
<dt>/gann interval interval_in_seconds</dt>
<dd>Sets interval between messages.</dd>
<dt>/gann on</dt>
<dd>Enables the addon.</dd>
<dt>/gann off</dt>
<dd>Disables the addon.</dd>
</dl>

> **Important!**
>
> Configuration is stored per character. You have to configure and enable
> Announcer on every officer character separately. It is also possible to
> store configuration under guild info tab, which will override manual
> settings.
>
> To synchronise the settings between all users, append the following text
> to your guild info: `{gann:interval_in_seconds:your_message_here}`. You
> still have to manually do `/gann on`, however.
>
> Example: `{gann:600:Best of best. See our site at ...}`
