# Contributing

Hi! Thanks for considering a contribution to this project.  Below you will find a short set of guidelines to help you with your contribution. Be it a bug report, a pull request, or even a question. Let me (us) also let you know that you don't have to file a pull-request, or contribute "raw code" to this project.  I (we) would never ask you to do that if you do not wish to, or currently are unable to. All I (we) ask is that you file bug reports, and be respectful of the fact that this software is provided for free, and at mostly the authors expense via time (and sometimes cash.)

## Dependecies

This project has a strict policy on dependencies.  We do not do major updates (major version updates) of our current dependencies in anything bug major releases, regardless of backwards compatibility. Dependencies are locked until the next major version. If there are is a security reason for a major update, we ask that you file a bug with the original library and ask them to cut a minor release of the last release, which is proper.

## Language Versions
### Policies

You can test on more than one version back of Ruby, and to continue to support a minor version, for example if our software starts with `2.2` and the version is currently `2.5` and we have no plans for a major update you can add `2.5` to the list of supported Rubies, however, the next major will drop it to `2.4`, and `2.5`

* ***Ruby:*** Latest + 1 Back
* ***JRuby:*** Latest Release ***only***
* ***Rubinius:*** We do not support Rubinius at all.
* ***Node.js:*** Latest LTS + Latest Release + 1 Back
* ***Go:*** Latest + 1 Back


## Bugs

If you do not wish to (or are unable to) file a pull-request you can file a bug report for any issue you have... as long as it is not a question.  Issues include random results, random errors, segfaults, or anything of that nature.  When you do, please make sure to include the system you are working from, the version of the language or compiler you are working with, and any relevant information that can be used to replicate the issue.  ***Unreplicable issues will be closed.*** ***You can (and are encouraged to) ask questions if they are about something not documented, or if there is a question about an ambiguity in the documentation, this will prompt me (us) to update the documentation to fix the problem.***

### What to not do

* Ask us to put an urgency on your issue.
* Be disrespectful; ***we will block your comments***.
* ":+1:" comments, we will lock issues; preventing further comments.
* Ask if there are "any updates"

### Policies
#### Closing
##### *1 Week*
* **Status:** `needs-user-debug`
* **Status:** `unable-to-replicate`
* **Status:** `needs-user-info`

***Issues closed because of this will probably be re-opened once an update is given, and the time reset.  Closing it does not mean we do not believe the issue exists, it means that it's filling a backlog space for something you consider unimportant.***

#### Fixing
##### Bugfix x.x.X
* **Status:** `needs-hotfix`
* **Milestone:** As Set by Author
* **Status:** `major-bug`

##### Minor x.X.x
* **Status:** `next-minor`
* **Milestone:** As set by author.
* **Status:** `minor-bug`

##### Major X.x.x
* **Milestone:** As set by author.
* **Status:** `major-feature` (***Locked On Close***)
* **Status:** `breaking-refactor`
* **Status:** `api-change`

##### Any X.X.X
* **Status:** `non-breaking-refactor`
* **Status:** `feature` (***Locked On Close***)
* **Status:** `any-version`

## Pull Requests
### Tests

If you change a method in any way, your tests ***must*** pass, and if there is an additional surface added you ***must add tests***, in Ruby I (we) generally prefer to use RSpec, you should refer to RSpec's documentation for information on how, in Go, we (I) prefer to use Go's native testing.

* ***Ruby:*** `rake spec`
* ***Go:*** `go test -cover -v`
* `script/test`

### Code

Code updates should follow the formatting of the given repository, formatting changes that are unrelated will be rejected and asked to be removed, regardless of your personal preference.  You must remember that you are in Rome, so be respectful of the territory, and it will respect you back.

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

Your pull-request should not add additional information outside of the Git-Commit.  I (we) understand this is Github, but explanitory data should remain in Git itself, not within Github (for the most part.)  You should put the comment body of your pull request inside of your commit.

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
