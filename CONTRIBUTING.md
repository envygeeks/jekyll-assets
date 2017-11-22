[@envygeeks]: https://github.com/envygeeks

# Contributing

**Hi!** *Thanks for considering a contribution to this project*.  Below you will find a short set of guidelines to help you with your contribution. Be it a bug report, a pull request, or even a question. Let me also let you know that you don't have to file a pull-request, or contribute "raw code" to this project.  I would never ask you to do that if you do not wish to, or currently are unable to. All I ask is that you file bug reports, and be respectful of the fact that this software is provided for free, on a donation basis, and at mostly [@envygeeks] expense via time (and sometimes cash.)

## Dependencies

This project has an almost strict policy on dependencies.  I do not do major updates (major version updates) of our current dependencies in anything but major releases, regardless of backwards compatibility. Dependencies are locked until the next major version. If there is a security reason for a major update, I ask that you file a bug with the upstream library and ask them to cut a minor release of the last release, which is proper.

***If they cannot provide a security update for the latest version, I will consider adding the major version as an optional version, but not restricting it as the only acceptable starting version, but I will complain about having to do so, because that's not cool.***

### Languages

When it comes to the language versions I support, if a language version becomes EOL (end-of-life) before a major release can be made, I will remove all official support for it before a major release, and update the list of supported versions inside of the testing.  This is done to encourage users to keep updating quickly, rather than remaining on old, unstable, and unsupported versions of the language.

#### Policies

I tend to test on more than one version, and more than one back version of any given language if a major update hasn't been done in a while, and continue to support them as long as they are not end-of-life. For example, if my software starts with Ruby `2.2`, and the version is currently `2.5`, and I have no plans for a major update you can add `2.5` to the list of supported Rubies, however, the next major update will drop it to `2.4`, and `2.5`.  If `2.2` becomes end-of-life, I will also drop it from the list.

* ***Ruby:*** Latest + 1 Back
* ***JRuby:*** Latest Release ***only***
* ***Rubinius:*** We do not support Rubinius at all.
* ***Node.js:*** Latest LTS + Latest Release + 1 Back
* ***Go:*** Latest + 1 Back


## Bugs/Features

***If you do not wish to (or are unable to) file a pull-request, you can file a bug report for any issue you have...*** as long as it is not a question.  Issues include *random results*, *random errors*, *segfaults*, or anything of that nature.  When you do, please make sure to include the system you are working from, the version of the language or compiler you are working with, and any relevant information that can be used to replicate the issue.  ***Unreplicable issues will be closed.*** ***You can (and are encouraged to) ask questions if they are about something not documented, or if there is a question about an ambiguity in the documentation, this will prompt me to update the documentation to fix the problem.***

### What to not do

* Ask me to put an urgency on your issue.
* Be disrespectful; ***I will block your comments***.
* ":+1:" comments, I will lock issues; preventing further comments.
* Ask if there are "any updates"

***I do accept donations for fixing issues on a case-by-case urgency basis, as well as for creating features, if you need an issue addressed quickly.  If you wish to do this you should contact [@envygeeks].  Otherwise issues are fixed based on complexity, time, and general importance. All my projects get equal love and sometimes it takes a minute to get back around.***

### Policies
#### Closing
##### *1 Week*
* **Status:** `needs-user-debug`
* **Status:** `unable-to-replicate`
* **Status:** `needs-user-info`

***Issues closed because of this will probably be re-opened once an update is given, and the time reset.  Closing it does not mean we do not believe the issue exists, it means that it's filling a backlog space for something you consider unimportant.***

#### Fixing
##### Bugfix x.x.X
* **Status:** `security`
* **Status:** `needs-hotfix`
* **Status:** `major-bug`

##### Minor x.X.x
* **Status:** `next-minor`
* **Status:** `api-change`
* **Status:** `has-deprecation`
* **Status:** `minor-bug`

##### Major X.x.x
* **Status:** `api-change`
* **Status:** `lacks-deprecation`
* **Status:** `breaking-refactor`
* **Status:** `major-feature`

##### Any X.X.X
* **Status:** `any-version`
* **Status:** `non-breaking-refactor`
* **Status:** `feature`

## Pull Requests
### Tests

If you change a method in any way, your tests ***must*** pass, and if there is an additional surface added, then you ***must add tests***, in Ruby I generally prefer to use RSpec, you should refer to RSpec's documentation for information on how it works, in Go, I prefer to use Go's native testing.

* ***Ruby:*** `rake spec`
* ***Go:*** `go test -cover -v`
* `script/test`

### Code

Code updates should follow the formatting of the given repository, formatting in Ruby is generally done via `rubocop` and is generally tied into `rake` and `rake spec`. Changes that are unrelated will be rejected and asked to be removed, regardless of your personal preference.  You can always port those unrelated changes into another pull-request, unless they are arbitrary.

#### Basics

* Write your code in a clean and readable format.
* Comment your code, at the high level, not lots of inline comments.
* Stay at 80 lines if you can.

##### Good

```ruby
# @param hello [String] your greeting
# Allows you to send a greeting back to the user
# @raise if the given object is not a string
# @return [String] the greeting
def greet(hello)
  raise ArgumentError, "needs string" unless hello.is_a?(String)
  alert hello, {
    class: ".greeting"
  }
end
```

##### Bad

```ruby
# @param hello [String] your greeting
# Allows you to send a greeting back to the user
# @return [String] the greeting
def greet(hello)
  # @raise if the given object is not a string
  raise ArgumentError, "needs string" unless hello.is_a?(String)
  # Ship it to the user
  alert hello, {
    class: ".greeting"
  }
end
```

#### Commits

Your pull-request should not add additional information outside of the Git-Commit.  I understand this is Github, but explanitory data should remain in Git itself, not within Github (for the most part.)  You should put the comment body of your pull request inside of your commit.

```
Message

This pull-request solves X issue because it was really buggy.
Please do not add extra `\n\n` here because Github displays it
badly, so just let it flow, besides, this is what was intended for
Git anyways, you only keep your message at 80c.
```


### Documentation

Documentation updates should follow the formatting of the given repository.  You will be required to go through an approval process and even a comment processes.  This process is mostly simple and should not impede a quick resolution. You should be prepared for the following:

* Requests for unrelated changes to be removed.
* Requests for language changes if the author feels it's ambiguous.
* Requests for formatting changes.
* Requests for `git squash`


## Financial contributions

We also welcome financial contributions in full transparency on our [open collective](https://opencollective.com/jekyll-assets).
Anyone can file an expense. If the expense makes sense for the development of the community, it will be "merged" in the ledger of our open collective by the core contributors and the person who filed the expense will be reimbursed.


## Credits


### Contributors

Thank you to all the people who have already contributed to jekyll-assets!
<a href="graphs/contributors"><img src="https://opencollective.com/jekyll-assets/contributors.svg?width=890" /></a>


### Backers

Thank you to all our backers! [[Become a backer](https://opencollective.com/jekyll-assets#backer)]

<a href="https://opencollective.com/jekyll-assets#backers" target="_blank"><img src="https://opencollective.com/jekyll-assets/backers.svg?width=890"></a>


### Sponsors

Thank you to all our sponsors! (please ask your company to also support this open source project by [becoming a sponsor](https://opencollective.com/jekyll-assets#sponsor))

<a href="https://opencollective.com/jekyll-assets/sponsor/0/website" target="_blank"><img src="https://opencollective.com/jekyll-assets/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/jekyll-assets/sponsor/1/website" target="_blank"><img src="https://opencollective.com/jekyll-assets/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/jekyll-assets/sponsor/2/website" target="_blank"><img src="https://opencollective.com/jekyll-assets/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/jekyll-assets/sponsor/3/website" target="_blank"><img src="https://opencollective.com/jekyll-assets/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/jekyll-assets/sponsor/4/website" target="_blank"><img src="https://opencollective.com/jekyll-assets/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/jekyll-assets/sponsor/5/website" target="_blank"><img src="https://opencollective.com/jekyll-assets/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/jekyll-assets/sponsor/6/website" target="_blank"><img src="https://opencollective.com/jekyll-assets/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/jekyll-assets/sponsor/7/website" target="_blank"><img src="https://opencollective.com/jekyll-assets/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/jekyll-assets/sponsor/8/website" target="_blank"><img src="https://opencollective.com/jekyll-assets/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/jekyll-assets/sponsor/9/website" target="_blank"><img src="https://opencollective.com/jekyll-assets/sponsor/9/avatar.svg"></a>