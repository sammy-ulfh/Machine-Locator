# Machine Locator
<p align="center">
  <img src="images/main.jpg"
      alt="Finder jpg"
      width="300"
      style="float: left; margin-right: 10px;">
</p>


A tool for locating machines that have already been resolved by [S4vitar](https://s4vitar.github.io/).

This project consider the machines of the platforms:
- [HackTheBox](https://www.hackthebox.com/)
- [VulnHub](https://www.vulnhub.com/)
```diff
+ Other
```
"Other" contains machines that were created outside the platform, right now it only contains [one machine](https://drive.google.com/file/d/1bxoTy0arnh4-yRFEcEozTeHc932X28Hu/view) created by S4vitar/Wh1tedrvg0n.

With this tool you can perform searches across any platform using: machine information, employing one or multiple parameters.

## Table of content
- [Installation](#Instalation)
- [Application](#Application)
- [Credits](#Credits)

## Installation
1. Clone the repository:
```bash
  git clone https://github.com/yourusername/yourproject.git ## PENDNG
```

## Application
1. First, you need to download required files:
```bash
  ./MachineLocator_es.sh -u
```
This download retrieves the required files or updates them if one or more machines have been added or changed.

2. Second, you can search by parameters:
```diff
- Indivual:
@@ -u) @@ Download or update required files
@@ -m) @@ Search by name
@@ -i) @@ Search by IP
@@ -o) @@ Search by os
@@ -d) @@ Search by difficulty
@@ -s) @@ Search by skill
@@ -c) @@ Search by certification
@@ -y) @@ Get youtube link where the machine is solve
@@ -p) @@ Get machines by platform
@@ -h) @@ Show help panel

- Show possible combinations:
@@ -k) @@ Show combinations between parameters
@@ -l) @@ Show combinations for parameter -p
```

## Credits
This project is an improvement of the project to search machines of the platform HackTheBox given by S4vitar on [Hack4u Academy](https://hack4u.io/).

The program take the information of a [google sheet](https://docs.google.com/spreadsheets/d/1dzvaGlT_0xnT-PGO27Z_4prHgA8PHIpErmoWdlUrSoA/edit?gid=0#gid=0) that s4vitar updates when solve a new machine.
