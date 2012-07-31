# puncsig: Punctuation Signatures

## What Is This?

Inspired by Ward Cunningham's [Signature Survey: A Method for Browsing
Unfamiliar Code](http://c2.com/doc/SignatureSurvey/), "puncsig" is
short for "punctuation signature": it parses ruby code, and shows you
just the punctuation from the methods. It gives you a rough idea of
the length of each method, and helps you spot similar methods.

## Install

In your Gemfile:

```
gem 'puncsig'
```

...or on your command line:

```
$ gem install puncsig
```

You know, the basics.

## Use It

In your rails app:

```
$ bundle exec rake -T puncsig
rake puncsig:all          # Run puncsig on the whole app
rake puncsig:controllers  # Run puncsig on just the controllers
rake puncsig:helpers      # Run puncsig on just the helpers
rake puncsig:lib          # Run puncsig on just the files in lib
rake puncsig:models       # Run puncsig on just the models
```

TODO In a normal ruby app. It's not quite here yet, I want to separate
it out a bit more. Coming soon, promise!

## Example: rstat.us

Just for fun, let's take a look at the [rstat.us
source](https://github.com/hotsh/rstat.us). I chose rstat.us strictly
because a) it was open-source ruby, and b) it cleanly installed, so
whatever puncsig says about the source, that's a great start - and I
gave up on several others, because I couldn't get them installed
easily. We _all_ have code that needs some love, and I have much love
for the people behind rstat.us.

```
$ be rake puncsig:models

[...]

app/models/salmon_author.rb
author_attributes:  {:=>,:=>,:=>,:=>,:=>,:=>,:=>}==().==.==.==.&&==.&&==.&&==.&&==.&&==.
avatar_url:         @..{||..==}..
email:              =@.==
initialize:         ()@=
bio:                @..
name:               @..
uri:                @.
username:           @.

[...]

app/models/user.rb
no_malformed_username:                   (=~/[@!#$\%&()*,^~{}|`=:;\\\/\[\]\?]/).?&&(=~/^[.]/).?&&(=~/[.]$/).?&&(=~/[.]{,}/).?.(:,.,,.)
send_mention_notification:               (,)=.:=>=.:=>=://#{.}/=::.(.())=..=.(..)=::.(.,.)=.(.,,{-=>/-+})
edit_user_profile:                       ()[:].?[:].?[:]==[:].=[:]..=.==[:].=[:]..=[:].=[:].=[:].=[:]...
following_url?:                          ()=.(:=>).?.?(://#{.}/)=[/\/\/(.+)$/,]=[.(:=>)].?!(&).?!
send_unfollow_notification:              ()=.:=>=::.(.,..)=..=.(..)=::.(.,.)=.(.,,{-=>/-+})
send_follow_notification:                ()=.:=>=::.(.,..)=..=.(..)=::.(.,.)=.(.,,{-=>/-+})

[...]
```

Look at these two signatures from app/models/discussion_list.rb:

```
send_unfollow_notification:              ()=.:=>=::.(.,..)=..=.(..)=::.(.,.)=.(.,,{-=>/-+})
send_follow_notification:                ()=.:=>=::.(.,..)=..=.(..)=::.(.,.)=.(.,,{-=>/-+})
```

There's clearly something similar about them. Here's the source:

```
  # Send Salmon notification so that the remote user
  # knows this user is following them
  def send_follow_notification(to_feed_id)
    f = Feed.first :id => to_feed_id

    salmon = OStatus::Salmon.from_follow(author.to_atom, f.author.to_atom)

    envelope = salmon.to_xml self.to_rsa_keypair

    # Send envelope to Author's Salmon endpoint
    uri = URI.parse(f.author.salmon_url)
    http = Net::HTTP.new(uri.host, uri.port)
    res = http.post(uri.path, envelope, {"Content-Type" => "application/magic-envelope+xml"})
  end

  # Send Salmon notification so that the remote user
  # knows this user has stopped following them
  def send_unfollow_notification(to_feed_id)
    f = Feed.first :id => to_feed_id

    salmon = OStatus::Salmon.from_unfollow(author.to_atom, f.author.to_atom)

    envelope = salmon.to_xml self.to_rsa_keypair

    # Send envelope to Author's Salmon endpoint
    uri = URI.parse(f.author.salmon_url)
    http = Net::HTTP.new(uri.host, uri.port)
    res = http.post(uri.path, envelope, {"Content-Type" => "application/magic-envelope+xml"})
  end
```

Definitely some kind of duplication there, and these methods aren't
right next to each other in the source.

And it helps us find really long methods, like these bad boys:

```
app/models/update.rb
generate_html:              =.().!(/([]?:\/\/\+[---\/}])/,<=\\>\\</>).!()||$=.(:=>/^#{$}$/,:=>/^#{$}$/)=..?(/)=://#{.}#{}#{$}<=#{}>@#{$}@#{$}</>$=.(:=>/^#{$}$/)=..?(/)=://#{.}#{}#{$}<=#{}>@#{$}</>.!(/(^|\+)#(\+)/)||#{$}<=/?=%#{$}>##{$}</>.=
```

## TODOS

* break it up & test it a bit.