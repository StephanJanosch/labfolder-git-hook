# git hook for Labfolder

This project is about using git hook in conjunction with the electronic lab notebook (ELN) Labfolder.

* Project Code : `labfolder-git-hook`
* Lab : Scientific Computing Facility @mpi-cbg.de
* Contact Person : [Stephan Janosch](mailto:janosch@extern.mpi-cbg.de)
* Scripts Repository : https://gitlab.gwdg.de/labfolder-api-tools/git-hook
* Start Date: July 2019
* Data location : n/a

Currently only one git hook is used: [pre-push](#pre-push). For changes please read [changelog](doc/changelog.md).

## technical requirements

command line dependencies:
* bash (new MacOs use zsh by default)
* curl
* jq

## limitations/known issues

* using git from an IDE might result in a problem reading the password from the keyboard. For now divert to pushing from command line

## user documentation pre-push

The documentation how to set up and use the pre-push hook can be found in [pre-push.md](doc/pre-push.md)




